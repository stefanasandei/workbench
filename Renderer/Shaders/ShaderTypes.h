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
    VertexInputIndexViewportSize = 1
} VertexInputIndex;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} Vertex;

#endif /* ShaderTypes_h */
