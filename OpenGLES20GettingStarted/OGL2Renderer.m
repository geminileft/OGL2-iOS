//
//  OGL2Renderer.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OGL2Renderer.h"
#import "RenderTypes.h"
#import "PrimativeBuffer.h"
#import "TextureManager.h"
#import "RenderTarget.h"
#import "RenderProgram.h"
#import "ManagerFile.h"
#import "RenderTexture.h"
#import "RenderPolygon.h"

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@implementation OGL2Renderer

-(id) initWithLayer:(CALayer *)layer {
    
    self = [super init];
    if (self) {                
        // Make sure this is the right version!
        mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!mContext || ![EAGLContext setCurrentContext:mContext]) {
        }
        glGenFramebuffers(1, &mScreenFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mScreenFrameBuffer);
        
        glGenRenderbuffers(1, &mRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mRenderBuffer);
        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)layer];
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mRenderBuffer);
        if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"Failed!!");
        }
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mHeight);
        
        mScreenTarget = [[RenderTarget alloc] initWithFrameBuffer:mScreenFrameBuffer];
        [mScreenTarget setWidth:mWidth height:mHeight];
        
        [EAGLContext setCurrentContext:mContext];
        
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
        
        mBackBuffer = [[PrimativeBuffer alloc] init];
        mPrimBuffer = [[NSMutableDictionary alloc] init];
		[mPrimBuffer setValue:[[PrimativeBuffer alloc] init] forKey:@"polygon"];
		[mPrimBuffer setValue:[[PrimativeBuffer alloc] init] forKey:@"texture"];
        mShaderPrograms = [[NSMutableDictionary alloc] init];
        
        [self createPrograms];
        
        TextureManager* texMgr = [TextureManager sharedManager];
        [texMgr loadTextures];

        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(run)];
        [aDisplayLink setFrameInterval:1];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

-(void) run {
    [self copyToBuffer];
    
    RenderTarget* rt;    
    rt = mScreenTarget;
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    
    [self runTargetShaders:rt];
    
    //[self textureRender:[mPrimBuffer objectForKey:@"texture"]];
    //[self polygonRender:[mPrimBuffer objectForKey:@"polygon"]];
    
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}


-(void) runTargetShaders:(RenderTarget*) target {
    RenderProgram* rp;
    
    [target activate];
    glClear(GL_COLOR_BUFFER_BIT);
    for (NSString* sType in mPrimBuffer) {
        rp = [mShaderPrograms objectForKey:sType];
        if (rp != nil) {
            [rp activate:target];
            [rp run:target primatives:[mPrimBuffer objectForKey:sType]];
        } else {
            NSLog(@"Hrm.");
        }
    }
}

-(void) setRenderProvider:(id<RenderProvider>) provider {
    mProvider = [provider retain];
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:[mContext API] sharegroup:mContext.sharegroup];
    [mProvider renderInitialized:context];
}

-(void) copyToBuffer {
    @synchronized(mBackBuffer) {
        mBackBuffer->mTop = 0;
        [mProvider copyToBuffer:mBackBuffer];
        @synchronized(mPrimBuffer) {
            for (NSString* key in [mPrimBuffer allKeys]) {
                ((PrimativeBuffer*)[mPrimBuffer objectForKey:key])->mTop = 0;
            }
            
            int size = mBackBuffer->mTop;
            for (int i = 0;i < size;++i) {
                RenderPrimative primative = [mBackBuffer get:i];
                NSString* ptype;
                if (primative.mTextureBuffer == NULL) {
                    ptype = @"polygon";
                } else {
                    ptype = @"texture";
                }
                [((PrimativeBuffer*)[mPrimBuffer objectForKey:ptype]) add:primative];
            }
        }
        //[((PrimativeBuffer*)[mPrimBuffer objectForKey:@"texture"]) add:mTexPrimative];
    }
}

-(void) setScreenFrameBuffer:(unsigned int) screenFrameBuffer {
    mScreenFrameBuffer = screenFrameBuffer;
}

-(void) createPrograms {
    NSString* vertexSource;
    NSString* fragmentSource;
    RenderProgram* rp;
    
    vertexSource = [ManagerFile readFileContents:@"texture.vs"];
    fragmentSource = [ManagerFile readFileContents:@"texture.fs"];
    rp = [[RenderTexture alloc] initWithVertexSource:vertexSource fragmentSource:fragmentSource];
    [mShaderPrograms setObject:rp forKey:@"texture"];
    [rp addAttribute:@"aVertices"];
    [rp addAttribute:@"aTextureCoords"];
    
    vertexSource = [ManagerFile readFileContents:@"colorbox.vs"];
    fragmentSource = [ManagerFile readFileContents:@"colorbox.fs"];
    rp = [[RenderPolygon alloc] initWithVertexSource:vertexSource fragmentSource:fragmentSource];
    [mShaderPrograms setObject:rp forKey:@"polygon"];
    [rp addAttribute:@"aVertices"];
    [rp addAttribute:@"aColor"];
}

@end
