//
//  PrimativeBuffer.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimativeBuffer.h"

#define MAX_SIZE 1000

@implementation PrimativeBuffer

-(id) init {
    self  = [super init];
    if (self) {
        mTop = 0;
        mRenderPrimatives = malloc(MAX_SIZE * sizeof(RenderPrimative));
    }
    return self;
}

-(void) add:(RenderPrimative) primative {
    if (mTop < MAX_SIZE) {
        mRenderPrimatives[mTop] = primative;
        ++mTop;
    }
}

-(RenderPrimative) get:(int) index {
    RenderPrimative primative;
    if (index >= 0 && index < mTop)
        primative = mRenderPrimatives[index];
    return primative;
}

@end
