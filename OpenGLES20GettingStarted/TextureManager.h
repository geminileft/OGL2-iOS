//
//  TextureManager.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "RenderTypes.h"

@interface TextureManager : NSObject {
@private
    NSMutableDictionary* mTextures;
    NSMutableDictionary* mTexturePrimatives;
}

+(TextureManager*) sharedManager;
+(int) closestPowerOf2:(int) n;
+(unsigned int) GLUtexImage2D:(CGImageRef) cgImage;
-(void) loadTextures;
-(unsigned int) resourceTexture:(NSString*) resourceName forPrimative:(RenderPrimative) primative;

@end
