//
//  MatrixUtils.m
//  Workbench
//
//  Created by Asandei Stefan on 19.06.2024.
//

#import "MatrixUtils.h"

#define DEGREES_TO_RADIANS(degrees) (M_PI*degrees/180)

@implementation MatrixUtils

+ (matrix_float4x4)perspective:(float)degreesFOV
                           :(float)aspectRatio
                           :(float)nearPlane
                           :(float)farPlane {
    float fov = DEGREES_TO_RADIANS(degreesFOV);
    
    float t = tan(fov / 2);
    
    float x = 1 / (aspectRatio * t);
    float y = 1 / t;
    float z = farPlane / (farPlane - nearPlane);
    float w = -(farPlane * nearPlane) / (farPlane - nearPlane);
    
    matrix_float4x4 result = matrix_identity_float4x4;
    result.columns[0] = vector4(x, 0.0f, 0.0f, 0.0f);
    result.columns[1] = vector4(0.0f, y, 0.0f, 0.0f);
    result.columns[2] = vector4(0.0f, 0.0f, z, 1.0f);
    result.columns[3] = vector4(0.0f, 0.0f, w, 0.0f);
    
    return result;
}

@end
