//
//  OGL11Renderer.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OGL11Renderer.h"
#import "RenderTypes.h"
#import "PrimativeBuffer.h"
#import "TextureManager.h"

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


@implementation OGL11Renderer

-(id) initWithLayer:(CALayer *)layer {
    self = [super init];
    if (self) {                
        mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (!mContext) {
            NSLog(@"Failed to create ES context");
        }
        else if (![EAGLContext setCurrentContext:mContext]) {
            NSLog(@"Failed to set ES context current");
        }
        
        glGenRenderbuffers(1, &mRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mRenderBuffer);
        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)layer];
        
        glGenFramebuffers(1, &mFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mFrameBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mRenderBuffer);
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        }
        glBindFramebuffer(GL_FRAMEBUFFER, mFrameBuffer);
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mHeight);
        
        glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_DITHER);
        glDisable(GL_LIGHTING);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glClearColor(0.2f, 0.3f, 0.4f, 1.0f);
        glClearColor(1.0f, 0.0f, 1.0f, 1.0f);
        //always drawing textures...enable once
        glEnable(GL_TEXTURE_2D);
        
        //required for vertex/textures
        glEnableClientState(GL_VERTEX_ARRAY);
        
        glViewport(0, 0, mWidth, mHeight);
        
        bool useOrtho = false;
        const int scaleFactor = 1;
        const int zDepth = mHeight / (2 / scaleFactor);
        const float ratio = (float)mWidth / mHeight;
        glMatrixMode(GL_PROJECTION);
        if (useOrtho) {
            glOrthof(0.0f, mWidth, 0.0f, mHeight, 0.0f, 1.0f);
        } else {
            glFrustumf(-ratio, ratio, -1, 1, 1, zDepth);
        }
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        if (!useOrtho) {
            glTranslatef(0.0f, 0.0f, -zDepth);
        }
        
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(run)];
        [aDisplayLink setFrameInterval:1];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        mBackBuffer = [[PrimativeBuffer alloc] init];
        mPrimBuffer = [[NSMutableDictionary alloc] init];
		[mPrimBuffer setValue:[[PrimativeBuffer alloc] init] forKey:@"polygon"];
		[mPrimBuffer setValue:[[PrimativeBuffer alloc] init] forKey:@"texture"];
    }
    
    return self;
}

-(void) run {
    //TextureManager* texMgr = [TextureManager sharedManager];
    //[texMgr loadTextures];
    [self copyToBuffer];
    
    glClear(GL_COLOR_BUFFER_BIT);
    [self textureRender:[mPrimBuffer objectForKey:@"texture"]];
    //[self polygonRender:[mPrimBuffer objectForKey:@"polygon"]];

    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void) polygonRender:(PrimativeBuffer*) buffer {
    const int size = buffer->mTop;
    for (int i = 0;i < size;++i) {
        RenderPrimative primative = [buffer get:i];
        glVertexPointer(2, GL_FLOAT, 0, primative.mVertexBuffer);
        glColor4f(primative.mR, primative.mG, primative.mB, primative.mA);
        
        glPushMatrix();
        glTranslatef(primative.mX, primative.mY, 0.0f);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glPopMatrix();
    }
}

-(void) textureRender:(PrimativeBuffer*) buffer {
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    const int size = buffer->mTop;
    for (int i = 0;i < size;++i) {
        RenderPrimative primative = [buffer get:i];
        glVertexPointer(2, GL_FLOAT, 0, primative.mVertexBuffer);
        glTexCoordPointer(2, GL_FLOAT, 0, primative.mTextureBuffer);
        glBindTexture(GL_TEXTURE_2D, primative.mTextureName);
        
        glPushMatrix();
        glTranslatef(primative.mX, primative.mY, 0.0f);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glPopMatrix();
    }
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}


/*
-(void) polygonRender {
    const int width = 160;
    const int height = 160;
    const float leftX = -(float)width / 2;
    const float rightX = leftX + width;
    const float bottomY = -(float)height / 2;
    const float topY = bottomY + height;
    
    const float vertices[] = {
        leftX, bottomY
        , leftX, topY
        , rightX, bottomY
        , rightX, topY
    };
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, &vertices[0]);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, 0.0f);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();
}
*/

-(void) setRenderProvider:(id<RenderProvider>) provider {
    mProvider = [provider retain];
    [mProvider renderInitialized:mContext];
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
    }
}

@end
