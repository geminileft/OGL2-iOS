

@class PrimativeBuffer;

@protocol RenderProvider <NSObject>
@required
-(void) copyToBuffer:(PrimativeBuffer*) buffer;
-(void) renderInitialized:(EAGLContext*) context;

@end
