//
//  TextureManager.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextureManager.h"
#import "RenderTypes.h"
#import "PrimativeBuffer.h"

@implementation TextureManager

static TextureManager* mSharedManager = nil;

-(void) dealloc {
    [mTextures release];
    [super dealloc];
}

-(id) init {
    self = [super init];
    if (self) {
        mTextures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+(TextureManager*) sharedManager {
    if (!mSharedManager) {
        mSharedManager = [[TextureManager alloc] init];
    }
    return mSharedManager;
}

+(unsigned int) GLUtexImage2D:(CGImageRef) cgImage {
    NSUInteger width;
    NSUInteger height;
    float i;
    CGContextRef context = nil;
    void* data = nil;;
    CGColorSpaceRef colorSpace;
    void* tempData;
    unsigned int* inPixel32;
    unsigned short* outPixel16;
    BOOL hasAlpha;
    CGImageAlphaInfo info;
    Texture2DPixelFormat pixelFormat;
    
    info = CGImageGetAlphaInfo(cgImage);
    hasAlpha = ((info == kCGImageAlphaPremultipliedLast)
                || (info == kCGImageAlphaPremultipliedFirst)
                || (info == kCGImageAlphaLast)
                || (info == kCGImageAlphaFirst));
    
    if(CGImageGetColorSpace(cgImage)) {
        if(hasAlpha)
            pixelFormat = kTexture2DPixelFormat_RGBA8888;
        else
            pixelFormat = kTexture2DPixelFormat_RGB565;
    } else //NOTE: No colorspace means a mask image
        pixelFormat = kTexture2DPixelFormat_A8;
    
    width = CGImageGetWidth(cgImage);
    height = CGImageGetHeight(cgImage);
    width = [TextureManager closestPowerOf2:width];
    height = [TextureManager closestPowerOf2:height];
    
    switch(pixelFormat) {
        case kTexture2DPixelFormat_RGBA8888:
            colorSpace = CGColorSpaceCreateDeviceRGB();
            data = malloc(height * width * 4);
            context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace,
                                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpace);
            break;
        case kTexture2DPixelFormat_RGB565:
            colorSpace = CGColorSpaceCreateDeviceRGB();
            data = malloc(height * width * 4);
            context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace,
                                            kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpace);
            break;
            
        case kTexture2DPixelFormat_A8:
            data = malloc(height * width);
            context = CGBitmapContextCreate(data, width, height, 8, width, NULL, kCGImageAlphaOnly);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
    }
    
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
    if(pixelFormat == kTexture2DPixelFormat_RGB565) {
        tempData = malloc(height * width * 2);
        inPixel32 = (unsigned int*)data;
        outPixel16 = (unsigned short*)tempData;
        for(i = 0; i < width * height; ++i, ++inPixel32)
            *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
        free(data);
        data = tempData;
        
    }
    glEnable(GL_TEXTURE_2D);
    uint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    switch(pixelFormat) {
            
        case kTexture2DPixelFormat_RGBA8888:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
            break;
        case kTexture2DPixelFormat_RGB565:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
            break;
        case kTexture2DPixelFormat_A8:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@""];
    }
    free(data);
    glDisable(GL_TEXTURE_2D);
    return texture;
}

+(int) closestPowerOf2:(int) n {
    const int MAX_TEXTURE_SIZE = 1024;
    int c = 1;
    while (c < n && c < MAX_TEXTURE_SIZE)
        c <<= 1;
    return c;
}

-(unsigned int) resourceTexture:(NSString*) resourceName {
    int textureId = 0;
    if ([mTextures objectForKey:resourceName] != nil) {
        textureId = [(NSNumber*)[mTextures objectForKey:resourceName] unsignedIntValue];
    }
    return textureId;
}

-(void) loadTextures {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:@"mg.png"];
    
    for (NSString* resourceName in array) {
        UIImage* image = [UIImage imageNamed:resourceName];
        unsigned int textureId = [TextureManager GLUtexImage2D:[image CGImage]];
        [mTextures setObject:[NSNumber numberWithUnsignedInt:textureId] forKey:resourceName];
    }
}

@end
