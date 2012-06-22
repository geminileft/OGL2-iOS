//
//  GenericRenderer.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderConsumer.h"

@class GLView;

@interface GenericRenderer : NSObject {
@private
    GLView* mView;
    id<RenderConsumer> mConsumer;
}

@property (nonatomic, readonly) GLView* view;

-(void) run;

@end
