//
//  GraphicsContext.m
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

@import simd;
@import MetalKit;

#import "AAPLRenderer.h"

#import "Shaders/ShaderTypes.h"
#import "MatrixUtils.h"
#import "Tweaks.h"

#define LEN(a) (sizeof(a) / sizeof(a[0]))

@interface AAPLRenderer()

- (void)setupSceneData;

@end

@implementation AAPLRenderer
{
    id<MTLDevice> _device;
    
    id<MTLRenderPipelineState> _pipelineState;
    
    id<MTLCommandQueue> _commandQueue;
    
    SceneData _sceneData;
    Tweaks _tweaks;
}

#pragma mark Public methods

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    NSAssert(self, @"Failed to create the renderer.");
    
    NSError *error;
    
    _device = MTLCreateSystemDefaultDevice();

    id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
    
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    NSAssert(_pipelineState, @"Failed to create the pipeline state: %@.", error);

    _commandQueue = [_device newCommandQueue];
    
    _sceneData.viewportSize.x = mtkView.drawableSize.width;
    _sceneData.viewportSize.y = mtkView.drawableSize.height;
    
    [self setupSceneData];
    
    mtkView.device = _device;
    mtkView.framebufferOnly = false;
    mtkView.delegate = self;
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    Vertex vertices[] = {
        { {0.5, 0.5, 1+_tweaks.z}, {1, 0, 0, 1}},
        { {0.5, -0.5, 1+_tweaks.z}, {0, 1, 0, 1}},
        { {-0.5, 0.5, 1+_tweaks.z}, {0, 0, _tweaks.blue, 1}},
        
        { {0.5, -0.5, 1+_tweaks.z}, {1, 0, 0, 1}},
        { {-0.5, -0.5, 1+_tweaks.z}, {0, 1, 0, 1}},
        { {-0.5, 0.5, 1+_tweaks.z}, {0, 0, _tweaks.blue, 1}},
    };
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _sceneData.viewportSize.x, _sceneData.viewportSize.y, 0.0, 1.0}];
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setVertexBytes:vertices length:sizeof(vertices) atIndex:VertexInputIndexVertices];
    [renderEncoder setVertexBytes:&_sceneData length:sizeof(_sceneData) atIndex:VertexInputIndexSceneData];
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:LEN(vertices)];
    
    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    _sceneData.viewportSize.x = size.width;
    _sceneData.viewportSize.y = size.height;
    
    [self setupSceneData];
}

- (void)setTweaks:(Tweaks)tweaks {
    _tweaks = tweaks;
}

#pragma endmark

#pragma mark Private methods

- (void)setupSceneData {
    _sceneData.view = matrix_identity_float4x4;
    
    float aspect = (float)_sceneData.viewportSize.x / (float)_sceneData.viewportSize.y;
    _sceneData.projection = [MatrixUtils perspective:45.0f :aspect :0.1f :1000.0f];
}

#pragma endmark

@end
