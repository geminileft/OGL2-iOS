//
//  RenderPolygon.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderPolygon.h"
#import "PrimativeBuffer.h"

@implementation RenderPolygon


-(void) run:(RenderTarget*) target primatives:(PrimativeBuffer*) primatives {
    uint programId = [self activate:target];
    uint vertexHandle = glGetAttribLocation(programId, "aVertices");
    uint colorHandle = glGetUniformLocation(programId, "aColor");
    uint posHandle = glGetAttribLocation(programId, "aPosition");
    
    RenderPrimative p;
    
    for (int i = 0;i < primatives->mTop;++i) {
        p = [primatives get:i];
        
        glVertexAttribPointer(vertexHandle, 2, GL_FLOAT, GL_FALSE, 0, &p.mVertexBuffer[0]);
        glUniform4f(colorHandle, p.mR, p.mG, p.mB, p.mA);
        glVertexAttrib2f(posHandle, p.mX, p.mY);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    [self deactivate];
}

@end
