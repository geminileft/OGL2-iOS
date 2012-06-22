//
//  RenderProgram.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RenderTypes.h"

@class RenderTarget;
@class PrimativeBuffer;

@interface RenderProgram : NSObject {
@private
    unsigned int mProgramId;
    NSMutableArray* mAttributes;
}

-(unsigned int) loadShader:(unsigned int) shaderType source:(NSString*) source;
-(id) initWithVertexSource:(NSString*) vertexSource fragmentSource:(NSString*) fragmentSource;
-(void) addAttribute:(NSString*) attribute;
-(unsigned int) activate:(RenderTarget*) target;
-(void) deactivate;
-(void) run:(RenderTarget*) target primatives:(PrimativeBuffer*) primatives;
-(unsigned int) getProgramId;

@end
