//
//  UtilMatrix.h
//  OpenGLES20GettingStarted
//
//  Created by socalcodecamp on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilMatrix : NSObject

+(void) setFrustum:(float*) matrix l:(float) left r:(float) right b:(float) bottom t:(float) top n:(float) near f:(float) far;
+(void) setIdentity:(float*) matrix;
+(void) setTranslate:(float*) matrix x:(float) x y:(float) y z:(float) z;
+(void) multiply:(float*) matrix a:(float*) a b:(float*) b;
@end
