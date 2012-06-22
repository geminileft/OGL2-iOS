//
//  RenderProgram.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderProgram.h"

@implementation RenderProgram

#include "RenderProgram.h"
#include "UtilMatrix.h"
#include "RenderTarget.h"

-(id) initWithVertexSource:(NSString*) vertexSource fragmentSource:(NSString*) fragmentSource {
    self = [super init];
    if (self) {
        mProgramId = glCreateProgram();
        //NSAssert(program != 0, @"Failed to create program");
        uint vertexShader = [self loadShader:GL_VERTEX_SHADER source:vertexSource];
        glAttachShader(mProgramId, vertexShader);
        uint fragmentShader = [self loadShader:GL_FRAGMENT_SHADER source:fragmentSource];
        glAttachShader(mProgramId, fragmentShader);
        glLinkProgram(mProgramId);
        int linkStatus[1];
        glGetProgramiv(mProgramId, GL_LINK_STATUS, linkStatus);
        if (linkStatus[0] != GL_TRUE) {
            NSLog(@"Error");
            glDeleteProgram(mProgramId);
            mProgramId = 0;
        }
        mAttributes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(unsigned int) loadShader:(unsigned int) shaderType source:(NSString*) source {
    uint shader = glCreateShader(shaderType);
    if (shader == 0) {
        NSLog(@"Big problem!");
    }
    const char* str = [source UTF8String];
    glShaderSource(shader, 1, &str, NULL);
    glCompileShader(shader);
    return shader;
}

-(void) addAttribute:(NSString*) attribute {
    [mAttributes addObject:attribute];;
}

-(unsigned int) activate:(RenderTarget*) target {
    glUseProgram(mProgramId);
    
    if ([mAttributes count] > 0) {
        for (NSString* attrib in mAttributes) {
            uint handle = glGetAttribLocation(mProgramId, [attrib UTF8String]);
            glEnableVertexAttribArray(handle);
        }
    }
    
    [target activate];
    uint mProjHandle = glGetUniformLocation(mProgramId, "uProjectionMatrix");
    uint mViewHandle = glGetUniformLocation(mProgramId, "uViewMatrix");
    glUniformMatrix4fv(mProjHandle, 1, GL_FALSE, [target getProjMatrix]);
    glUniformMatrix4fv(mViewHandle, 1, GL_FALSE, [target getViewMatrix]);
    return mProgramId;
}

-(void) deactivate {
    if ([mAttributes count] > 0) {
        for (NSString* attrib in mAttributes) {
            uint handle = glGetAttribLocation(mProgramId, [attrib UTF8String]);
            glDisableVertexAttribArray(handle);
        }
    }
}

-(unsigned int) getProgramId {
    return mProgramId;
}

-(void) run:(RenderTarget*) target primatives:(RenderPrimative*) primatives count:(unsigned int) primativeCount {}

@end
