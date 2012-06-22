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

@implementation GenericRenderer

@synthesize view = mView;

-(id) init {
    self = [super init];
    if (self) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        //[mWindow setBackgroundColor:[UIColor redColor]];
        
        mView = [[GLView alloc] initWithFrame:frame];
        mConsumer = [[OGL11Renderer alloc] initWithLayer:mView.layer];
        
    }
    
    return self;
}

@end
