//
//  Mesh.h
//  Workbench
//
//  Created by Asandei Stefan on 19.06.2024.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mesh : NSObject

- (nonnull instancetype)initWithDevice:(nonnull id<MTLDevice>)device;

- (MTLVertexDescriptor*)getVertexDescriptor;
- (MTKMesh*)getMtkMesh;

@end

NS_ASSUME_NONNULL_END
