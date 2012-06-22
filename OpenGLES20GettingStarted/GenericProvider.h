#import "RenderProvider.h"
#import "RenderTypes.h"

@class PrimativeBuffer;

@interface GenericProvider : NSObject<RenderProvider> {
@private
    RenderPrimative mPolyPrimative;
    RenderPrimative mTexPrimative;
    PrimativeBuffer* mCopyBuffer;
	PrimativeBuffer* mPrimatives;
}

-(void) initialize;
-(void) run;
-(void) frame;

@end
