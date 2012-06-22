//
//  ManagerFile.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagerFile.h"

@implementation ManagerFile

+(NSString*) readFileContents:(NSString*) filename {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* resourcePath = [bundle resourcePath];
    NSString* fullpath = [resourcePath stringByAppendingPathComponent:filename];
    NSString* contents = [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
    return contents;
}

@end
