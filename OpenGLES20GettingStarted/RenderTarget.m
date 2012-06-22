#include "RenderTarget.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "UtilMatrix.h"

@implementation RenderTarget

-(void) dealloc {
    [mShaders release];
    [super dealloc];
}

-(id) initWithFrameBuffer:(unsigned int) frameBuffer {
    self = [super init];
    if (self) {
        mFrameBuffer = frameBuffer;
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
@end
