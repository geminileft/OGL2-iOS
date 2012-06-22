//
//  AppDelegate.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GLView.h"
#import "GenericRenderer.h"
#import "GenericProvider.h"

@implementation AppDelegate

- (void)dealloc
{
    [mWindow release];
    [mRenderer release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    mWindow = [[UIWindow alloc] initWithFrame:frame];
    UIViewController* vc = [[UIViewController alloc] init];
    mRenderer = [[GenericRenderer alloc] init];
    GenericProvider* provider = [[GenericProvider alloc] init];
    [mRenderer setRenderProvider:provider];
    vc.view = mRenderer.view;
    mWindow.rootViewController = vc;
    [mWindow makeKeyAndVisible];
    
    [vc release];
    [provider release];
    return YES;
}

@end
