//
//  OGL11Renderer.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OGL11Renderer.h"
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
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
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
            glTranslatef(-mWidth / 2, -mHeight / 2, -zDepth);
        }
        
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(run)];
        [aDisplayLink setFrameInterval:1];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

-(void) run {
    glClear(GL_COLOR_BUFFER_BIT);
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
