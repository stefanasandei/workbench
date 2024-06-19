//
//  SimpleShader.metal
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

#include "ShaderTypes.h"

#include <metal_stdlib>
using namespace metal;

typedef struct {
    vector_float3 position [[attribute(0)]];
    vector_float3 normal [[attribute(1)]];
} Vertex;

struct RasterizerData {
    float4 position [[position]];
    float3 normal;
};

vertex RasterizerData vertexShader(Vertex in [[stage_in]],
                                constant SceneData *sceneData [[buffer(VertexInputIndexSceneData)]]) {
    RasterizerData out;
    
    float4 translation = float4(1.0, 1.0, 4.0, 1.0);
        
    out.position = sceneData->projection * sceneData->view * translation * float4(in.position, 1.0);
    out.normal = in.normal;
    
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    float3 light_dir = normalize(float3(1.0, 1.0, 1.0));
    float3 normal = normalize(in.normal);
    
    float3 albedo = float3(0.8, 0.0, 0.6);
    
    float3 intensity = saturate(dot(normal, light_dir));
    
    return float4(intensity * albedo, 1.0);
}
