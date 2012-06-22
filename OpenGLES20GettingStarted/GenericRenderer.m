//
//  GenericRenderer.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenericRenderer.h"
#import "GLView.h"
#import "OGL11Renderer.h"
#import "OGL2Renderer.h"

@implementation GenericRenderer

-(id) init {
    self = [super init];
    if (self) {
        CGRect frame = [[UIScreen mainScreen] bounds];        
        mView = [[GLView alloc] initWithFrame:frame];
        //mConsumer = [[OGL11Renderer alloc] initWithLayer:mView.layer];
        mConsumer = [[OGL2Renderer alloc] initWithLayer:mView.layer];
    }
    
    return self;
}

-(GLView*) view {
    return mView;
}

-(void) setRenderProvider:(id<RenderProvider>) provider {
    [mConsumer setRenderProvider:provider];
}

@end
