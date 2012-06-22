//
//  RenderConsumer.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RenderProvider;

@protocol RenderConsumer

@required
-(void) run;
-(void) setRenderProvider:(RenderProvider*) provider;

@end
