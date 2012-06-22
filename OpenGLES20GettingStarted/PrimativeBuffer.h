//
//  PrimativeBuffer.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenderTypes.h"

@interface PrimativeBuffer : NSObject {
@public
    RenderPrimative* mRenderPrimatives;
    int mTop;
}

-(void) add:(RenderPrimative) primative;
-(RenderPrimative) get:(int) index;

@end
