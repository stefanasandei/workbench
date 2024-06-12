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
#import "Tweaks.h"

@implementation AAPLRenderer
{
    id<MTLDevice> _device;
    
    id<MTLRenderPipelineState> _pipelineState;
    
    id<MTLCommandQueue> _commandQueue;
    
    vector_uint2 _viewportSize;
    Tweaks _tweaks;
}

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
    
    _viewportSize.x = mtkView.drawableSize.width;
    _viewportSize.y = mtkView.drawableSize.height;
    
    mtkView.device = _device;
    mtkView.framebufferOnly = false;
    mtkView.delegate = self;
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    Vertex vertices[] = {
        { {500, -500}, {1, 0, 0, 1}},
        { {-500, -500}, {0, 1, 0, 1}},
        { {0, 500}, {0, 0, _tweaks.blue, 1}},
    };
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, 0.0, 1.0}];
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setVertexBytes:vertices length:sizeof(vertices) atIndex:VertexInputIndexVertices];
    [renderEncoder setVertexBytes:&_viewportSize length:sizeof(_viewportSize) atIndex:VertexInputIndexViewportSize];
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    
    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)setTweaks:(Tweaks)tweaks {
    _tweaks = tweaks;
}

@end
