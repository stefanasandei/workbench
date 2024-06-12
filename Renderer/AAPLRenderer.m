//
//  GraphicsContext.m
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

@import simd;
@import MetalKit;

#import "AAPLRenderer.h"

@implementation AAPLRenderer
{
    id<MTLDevice> _device;
    
    id<MTLCommandQueue> _commandQueue;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    NSAssert(self, @"Failed to create AAPLRenderer");
    
    _device = MTLCreateSystemDefaultDevice();

    _commandQueue = [_device newCommandQueue];
    
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
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.8, 0.0, 0.0, 1.0);
    
    id<MTLRenderCommandEncoder> renderEncoder =
    [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    
}

@end
