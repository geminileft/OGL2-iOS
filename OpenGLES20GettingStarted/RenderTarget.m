#include "RenderTarget.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "UtilMatrix.h"

@implementation RenderTarget

-(id) initWithFrameBuffer:(unsigned int) frameBuffer {
    self = [super init];
    if (self) {
        mFrameBuffer = frameBuffer;
        mShaderData = nil;
    }
    return self;
}

-(void) setWidth:(int) width height:(int) height {
    mFrameWidth = width;
    mFrameHeight = height;
    
    float angle;
    float zDepth;
    float ratio;
    
    zDepth = (float)mFrameHeight / 2;
    ratio = (float)mFrameWidth/(float)mFrameHeight;
    
    if (false) {
        angle = -90.0f;
        [UtilMatrix setFrustum:&mProjMatrix[0] l:-1 r:1 b:-ratio t:ratio n:1.0f f:1000.0f];
    } else {
        angle = 0.0f;
        [UtilMatrix setFrustum:&mProjMatrix[0] l:-ratio r:ratio b:-1 t:1 n:1.0f f:1000.0f];
    }
    [UtilMatrix setTranslate:&mViewMatrix[0] x:0.0f y:0.0f z:-zDepth];
}

-(unsigned int) getFrameBuffer {
    return mFrameBuffer;
}

-(float) getFrameWidth {
    return mFrameWidth;
}

-(float) getFrameHeight {
    return mFrameHeight;
}

-(void) resetPrimatives {
    NSLog(@"fill in");
    //mShaders.clear();
}

-(void) activate {
    glViewport(0, 0, mFrameWidth, mFrameHeight);
    glBindFramebuffer(GL_FRAMEBUFFER, mFrameBuffer);
}

-(float*) getProjMatrix {
    return mProjMatrix;
}

-(float*) getViewMatrix {
    return mViewMatrix;
}

-(void) addPrimative:(RenderPrimative) primative {
    NSLog(@"finish");
    /*
    TEShaderType type;
    std::vector<TERenderPrimative> primatives;
    
    if (primative.textureBuffer == NULL) {
        if (!primative.colorData)
            type = ShaderBasic;
        else
            type = ShaderPolygon;
    } else {
        if (primative.extraData != NULL) {
            type = primative.extraType;
        } else {
            type = ShaderTexture;
        }
    }
    if (mShaders.count(type) > 0)
        primatives = mShaders[type];
    primatives.push_back(primative);
    mShaders[type] = primatives;
    */
}

-(TEShaderData*) getShaderData:(unsigned int) count {
    NSLog(@"fill in");
/*
    TEShaderData data;
    std::vector<TERenderPrimative> prims;
    std::vector<TERenderPrimative>::iterator primIterator;
    
    if (mShaderData != NULL)
        free(mShaderData);
    count = mShaders.size();
    
    uint shaderCount = 0;
    uint renderables = 0;
    if (count > 0) {
        mShaderData = (TEShaderData*)malloc(sizeof(TEShaderData) * count);
        std::map<TEShaderType, std::vector<TERenderPrimative> >::iterator iterator;
        for (iterator = mShaders.begin(); iterator != mShaders.end(); iterator++) {
            data.type = (*iterator).first;
            prims = (*iterator).second;
            data.primativeCount = prims.size();
            data.primatives = (TERenderPrimative*)malloc(data.primativeCount * sizeof(TERenderPrimative));
            renderables = 0;
            for (primIterator = prims.begin(); primIterator != prims.end(); primIterator++) {
                data.primatives[renderables] = (*primIterator);
                ++renderables;
            }
            memcpy(&mShaderData[shaderCount], &data, sizeof(TEShaderData));
            ++shaderCount;
        }
    }
    return mShaderData;
*/
    return nil;
}

@end
