//
//  RenderPolygon.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderPolygon.h"

@implementation RenderPolygon


-(void) run:(RenderTarget*) target primatives:(RenderPrimative*) primatives count:(unsigned int) primativeCount {
    uint programId = [self activate:target];
    uint vertexHandle = glGetAttribLocation(programId, "aVertices");
    uint colorHandle = glGetUniformLocation(programId, "aColor");
    uint posHandle = glGetAttribLocation(programId, "aPosition");
    
    RenderPrimative p;
    
    for (int i = 0;i < primativeCount;++i) {
        p = primatives[i];
        
        glVertexAttribPointer(vertexHandle, 2, GL_FLOAT, GL_FALSE, 0, &p.mVertexBuffer[0]);
        glUniform4f(colorHandle, p.mR, p.mG, p.mB, p.mA);
        glVertexAttrib2f(posHandle, p.mX, p.mY);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    [self deactivate];
}

@end
