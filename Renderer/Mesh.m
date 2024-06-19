//
//  Mesh.m
//  Workbench
//
//  Created by Asandei Stefan on 19.06.2024.
//

#import "Mesh.h"

#import <ModelIO/MDLMesh.h>

@implementation Mesh
{
    MTKMeshBufferAllocator* _allocator;
    MDLMesh* _mdlMesh;
    
    MDLVertexDescriptor* _vertexDescriptor;
    
    MTKMesh* _mesh;
}

- (nonnull instancetype)initWithDevice:(nonnull id<MTLDevice>)device {
    NSError *error;

    _allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        
    // todo: load a 3d model instead of this sphere
    _mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(1, 1, 1)
                                        segments:simd_make_uint2(24, 24)
                                    inwardNormals:false
                                     geometryType:MDLGeometryTypeTriangles
                                        allocator:_allocator];
    
    _vertexDescriptor = [[MDLVertexDescriptor alloc] init];
    
    _vertexDescriptor.attributes[0].name = MDLVertexAttributePosition;
    _vertexDescriptor.attributes[0].format = MDLVertexFormatFloat3;
    _vertexDescriptor.attributes[0].offset = 0;
    _vertexDescriptor.attributes[0].bufferIndex = 0;

    _vertexDescriptor.attributes[1].name = MDLVertexAttributeNormal;
    _vertexDescriptor.attributes[1].format = MDLVertexFormatFloat3;
    _vertexDescriptor.attributes[1].offset = 12;
    _vertexDescriptor.attributes[1].bufferIndex = 0;
    
    _vertexDescriptor.layouts[0].stride = 24;
    
    _mdlMesh.vertexDescriptor = _vertexDescriptor;
    
    _mesh = [[MTKMesh alloc] initWithMesh:_mdlMesh device:device error:&error];
    NSAssert(_mesh, @"Failed to create the mtk mesh: %@.", error);
    
    return self;
}

- (MTLVertexDescriptor*)getVertexDescriptor {
    return MTKMetalVertexDescriptorFromModelIO(_vertexDescriptor);
}

- (MTKMesh*)getMtkMesh {
    return _mesh;
}

@end
