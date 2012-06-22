#import "GenericProvider.h"
#import "PrimativeBuffer.h"

@implementation GenericProvider

-(void) initialize {
/*
    mTexPrimative = new RenderPrimative();
    TextureManager texMgr = TextureManager.sharedManager();
    mTexPrimative.mTextureName = texMgr.resourceTexture(R.drawable.mg, mTexPrimative);
    
    final float coordinates[] = {    		
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 0.0f
    };
    ByteBuffer byteBuf = ByteBuffer.allocateDirect(coordinates.length * 4);
    byteBuf.order(ByteOrder.nativeOrder());
    mTexPrimative.mTextureBuffer = byteBuf.asFloatBuffer();
    mTexPrimative.mTextureBuffer.put(coordinates);
    mTexPrimative.mTextureBuffer.position(0);
    
 */

    const int width = 160;
    const int height = 160;
    const float leftX = -(float)width / 2;
    const float rightX = leftX + width;
    const float bottomY = -(float)height / 2;
    const float topY = bottomY + height;
    
    const float vertices[] = {
        leftX, bottomY
        , leftX, topY
        , rightX, bottomY
        , rightX, topY
    };
    
    const size_t size = sizeof(float) * 8;
    mPolyPrimative.mVertexBuffer = malloc(size);
    memcpy(mPolyPrimative.mVertexBuffer, &vertices[0], size);
    mPolyPrimative.mTextureBuffer = NULL;
    mPolyPrimative.mR = 0.0f;
    mPolyPrimative.mG = 1.0f;
    mPolyPrimative.mB = 0.0f;
    mPolyPrimative.mA = 1.0f;
    mPolyPrimative.mX = 80.0f;
    mPolyPrimative.mY = 0.0f;
    
    mCopyBuffer = [[PrimativeBuffer alloc] init];
    mPrimatives = [[PrimativeBuffer alloc] init];
}

-(void) run {
    [self initialize];
    while (true) {
        mPrimatives->mTop = 0;
        [self frame];
        @synchronized(mCopyBuffer) {
            mCopyBuffer->mTop = 0;
            const int size = mPrimatives->mTop;
            const int buffSize = size * sizeof(RenderPrimative);
            if (mCopyBuffer->mRenderPrimatives)
                free(mCopyBuffer->mRenderPrimatives);
            mCopyBuffer->mRenderPrimatives = malloc(buffSize);
            memcpy(mCopyBuffer->mRenderPrimatives, mPrimatives->mRenderPrimatives, buffSize);
            mCopyBuffer->mTop = size;
        }
    }
}

-(void) frame {
    //mPrimatives->add(mTexPrimative);
    [mPrimatives add:mPolyPrimative];
}

-(void) copyToBuffer:(PrimativeBuffer*) buffer {
    @synchronized(mCopyBuffer) {
        const int size = mCopyBuffer->mTop;
        if (buffer->mRenderPrimatives) {
            free(buffer->mRenderPrimatives);
        }
        buffer->mRenderPrimatives = malloc(size * sizeof(RenderPrimative));
        memcpy(buffer->mRenderPrimatives, mCopyBuffer->mRenderPrimatives, size * sizeof(RenderPrimative));
        buffer->mTop = size;
    }
}

-(void) renderInitialized {
    NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
}

@end
