//
//  SimpleShader.metal
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

#include "ShaderTypes.h"

#include <metal_stdlib>
using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]],
                                constant Vertex *vertices [[buffer(VertexInputIndexVertices)]],
                                constant SceneData *sceneData [[buffer(VertexInputIndexSceneData)]]) {
    RasterizerData out;
    
    float3 pos = vertices[vertexID].position.xyz;
    
    out.position = sceneData->projection * sceneData->view * float4(pos, 1.0);
    out.color = vertices[vertexID].color;
    
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    return in.color;
}
