//
//  OGL11Renderer.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenderConsumer.h"
#import "RenderProvider.h"

@interface OGL11Renderer : NSObject<RenderConsumer> {
@private
    EAGLContext* mContext;
    unsigned int mFrameBuffer;
    unsigned int mRenderBuffer;
    int mWidth;
    int mHeight;
    id<RenderProvider> mProvider;
    PrimativeBuffer* mBackBuffer;
	NSDictionary* mPrimBuffer;
}

-(id) initWithLayer:(CALayer*) layer;
-(void) polygonRender:(PrimativeBuffer*) buffer;
-(void) textureRender:(PrimativeBuffer*) buffer;
-(void) copyToBuffer;

@end
