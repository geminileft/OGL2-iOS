//
//  RenderTarget.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "RenderTypes.h"

struct TEShaderData {
    PrimativeType type;
    RenderPrimative* primatives;
    uint primativeCount;
};

typedef struct TEShaderData TEShaderData;

@interface RenderTarget : NSObject {
@private
    unsigned int mFrameBuffer;
    float mFrameWidth;
    float mFrameHeight;
    float mProjMatrix[16];
    float mViewMatrix[16];
    NSMutableDictionary* mShaders;
    TEShaderData* mShaderData;
}

-(id) initWithFrameBuffer:(unsigned int) frameBuffer;
-(void) setWidth:(int) width height:(int) height;
-(unsigned int) getFrameBuffer;
-(float) getFrameWidth;
-(float) getFrameHeight;
-(void) addPrimative:(RenderPrimative) primative;
-(void) resetPrimatives;
-(void) activate;
-(float*) getProjMatrix;
-(float*) getViewMatrix;
-(TEShaderData*) getShaderData:(unsigned int) count;

@end

