//
//  UtilMatrix.m
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UtilMatrix.h"

@implementation UtilMatrix

+(void) setFrustum:(float*) matrix l:(float) left r:(float) right b:(float) bottom t:(float) top n:(float) near f:(float) far {
    matrix[0] = (2.0f * near) / (right - left);
    matrix[4] = 0;
    matrix[8] = (right + left) / (right - left);
    matrix[12] = 0;
    
    matrix[1] = 0;
    matrix[5] = (2.0f * near) / (top - bottom);
    matrix[9] = (top + bottom) / (top - bottom);
    matrix[13] = 0;
    
    matrix[2] = 0;
    matrix[6] = 0;
    matrix[10] = - ((far + near) / (far - near));
    matrix[14] = - ((2.0f * far * near) / (far - near));
    
    matrix[3] = 0;
    matrix[7] = 0;
    matrix[11] = -1.0f;
    matrix[15] = 0;    
}

+(void) setIdentity:(float*) matrix {
    matrix[0] = 1;
    matrix[1] = 0;
    matrix[2] = 0;
    matrix[3] = 0;
    
    matrix[4] = 0;
    matrix[5] = 1;
    matrix[6] = 0;
    matrix[7] = 0;
    
    matrix[8] = 0;
    matrix[9] = 0;
    matrix[10] = 1;
    matrix[11] = 0;
    
    matrix[12] = 0;
    matrix[13] = 0;
    matrix[14] = 0;
    matrix[15] = 1;
}

+(void) setTranslate:(float*) matrix x:(float) x y:(float) y z:(float) z {
    matrix[0] = 1;
    matrix[1] = 0;
    matrix[2] = 0;
    matrix[3] = 0;
    
    matrix[4] = 0;
    matrix[5] = 1;
    matrix[6] = 0;
    matrix[7] = 0;
    
    matrix[8] = 0;
    matrix[9] = 0;
    matrix[10] = 1;
    matrix[11] = 0;
    
    matrix[12] = x;    
    matrix[13] = y;    
    matrix[14] = z;    
    matrix[15] = 1;    
}

@end
