//
//  OGL2Renderer.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderConsumer.h"
#import "RenderProvider.h"

@class RenderTarget;

@interface OGL2Renderer : NSObject<RenderConsumer> {
@private
    EAGLContext* mContext;
    unsigned int mFrameBuffer;
    unsigned int mRenderBuffer;
    int mWidth;
    int mHeight;
    id<RenderProvider> mProvider;
    PrimativeBuffer* mBackBuffer;
    NSDictionary* mPrimBuffer;
    unsigned int mScreenFrameBuffer;
    RenderTarget* mScreenTarget;
}

-(id) initWithLayer:(CALayer*) layer;
-(void) polygonRender:(PrimativeBuffer*) buffer;
-(void) textureRender:(PrimativeBuffer*) buffer;
-(void) copyToBuffer;
@end