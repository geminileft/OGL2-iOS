#import "GenericProvider.h"
#import "PrimativeBuffer.h"
#import "TextureManager.h"

@implementation GenericProvider

-(void) initialize {
    mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1 sharegroup:mSaveContext.sharegroup];
    if (!mContext) {
        NSLog(@"Failed to create ES context");
    }
    else if (![EAGLContext setCurrentContext:mContext]) {
        NSLog(@"Failed to set ES context current");
    }
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [mSaveContext release];
    const float coordinates[] = {    		
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 0.0f
    };
    
    size_t size;
    size = 8 * sizeof(float);
    mTexPrimative.mTextureBuffer = malloc(size);
    //TextureManager* texMgr = [TextureManager sharedManager];
    //mTexPrimative.mTextureName = [texMgr resourceTexture:@"mg.png" forPrimative:mTexPrimative];
    UIImage* image = [UIImage imageNamed:@"mg.png"];
    mTexPrimative.mTextureName = [TextureManager GLUtexImage2D:[image CGImage]];
    memcpy(mTexPrimative.mTextureBuffer, &coordinates[0], size);

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
    

    mTexPrimative.mVertexBuffer = malloc(size);
    memcpy(mTexPrimative.mVertexBuffer, &vertices[0], size);
    
    mTexPrimative.mX = -80.0f;
    mTexPrimative.mY = 0.0f;

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
    [mPrimatives add:mTexPrimative];
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

-(void) renderInitialized:(EAGLContext*) context {
    NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
    mSaveContext = [context retain];
}

@end
