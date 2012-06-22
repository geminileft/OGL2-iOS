//
//  RenderTypes.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef OpenGLES20GettingStarted_RenderTypes_h
#define OpenGLES20GettingStarted_RenderTypes_h

struct RenderPrimative {
    
	float* mVertexBuffer;
	float* mTextureBuffer;
	
	float mR;
	float mG;
	float mB;
	float mA;
	
	float mX;
	float mY;
	
	int mTextureName;
};

typedef struct RenderPrimative RenderPrimative;

enum PrimativeType {
    ShaderPolygon
    , ShaderTexture
};

typedef enum PrimativeType PrimativeType;

enum Texture2DPixelFormat {
    kTexture2DPixelFormat_Automatic = 0,
    kTexture2DPixelFormat_RGBA8888,
    kTexture2DPixelFormat_RGB565,
    kTexture2DPixelFormat_A8,
};

typedef enum Texture2DPixelFormat Texture2DPixelFormat;

#endif
