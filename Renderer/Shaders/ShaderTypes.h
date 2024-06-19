//
//  ShaderTypes.h
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum {
    VertexInputIndexVertices = 0,
    VertexInputIndexSceneData = 1
} VertexInputIndex;

typedef struct {
    vector_uint2 viewportSize;
    
    matrix_float4x4 view;
    matrix_float4x4 projection;
} SceneData;

#endif /* ShaderTypes_h */
