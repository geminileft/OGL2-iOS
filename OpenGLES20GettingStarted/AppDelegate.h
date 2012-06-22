//
//  AppDelegate.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenericRenderer;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
@private
    UIWindow* mWindow;
    GenericRenderer* mRenderer;
}

@end
