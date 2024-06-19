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
#import "Mesh.h"

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
    Mesh* _mesh;
}

#pragma mark Public methods

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    NSAssert(self, @"Failed to create the renderer.");
    
    NSError *error;
    
    _device = MTLCreateSystemDefaultDevice();
    
    _mesh = [[Mesh alloc] initWithDevice:_device];

    id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
    
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    pipelineStateDescriptor.vertexDescriptor = _mesh.getVertexDescriptor;
    
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
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    MTKMesh* mesh = _mesh.getMtkMesh;
    
    for(int i=0; i<mesh.vertexBuffers.count; i++) {
        [renderEncoder setVertexBuffer:mesh.vertexBuffers[i].buffer
                               offset:mesh.vertexBuffers[i].offset
                              atIndex:i];
    }
    
    [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _sceneData.viewportSize.x, _sceneData.viewportSize.y, 0.0, 1.0}];
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setVertexBytes:&_sceneData length:sizeof(_sceneData) atIndex:VertexInputIndexSceneData];
    
    for(int i=0; i<mesh.submeshes.count; i++) {
        MTKMeshBuffer* indexBuffer = mesh.submeshes[i].indexBuffer;
        [renderEncoder drawIndexedPrimitives:mesh.submeshes[i].primitiveType indexCount:mesh.submeshes[i].indexCount indexType:mesh.submeshes[i].indexType indexBuffer:indexBuffer.buffer indexBufferOffset:indexBuffer.offset];
    }
    
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
