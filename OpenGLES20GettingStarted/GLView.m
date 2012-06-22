#import "GLView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)dealloc
{
    [super dealloc];
}

@end