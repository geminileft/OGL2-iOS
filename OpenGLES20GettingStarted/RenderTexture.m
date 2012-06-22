//
//  RenderTexture.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderTexture.h"

@implementation RenderTexture

-(void) run:(RenderTarget*) target primatives:(RenderPrimative*) primatives count:(unsigned int) primativeCount {
    uint simpleProgram = [self activate:target];
    uint positionHandle = glGetAttribLocation(simpleProgram, "aVertices");
    uint textureHandle = glGetAttribLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = glGetAttribLocation(simpleProgram, "aPosition");
    uint alphaHandle = glGetUniformLocation(simpleProgram, "uAlpha");

    RenderPrimative p;
    
    for (int i = 0;i < primativeCount;++i) {
        p = primatives[i];
        glBindTexture(GL_TEXTURE_2D, p.mTextureName);
        glVertexAttrib2f(coordsHandle, p.mX, p.mY);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, p.mTextureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, p.mVertexBuffer);
        glUniform1f(alphaHandle, 1.0);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    
    [self deactivate];
}
@end
