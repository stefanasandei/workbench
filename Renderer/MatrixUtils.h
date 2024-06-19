//
//  MatrixUtils.h
//  Workbench
//
//  Created by Asandei Stefan on 19.06.2024.
//

#import <Foundation/Foundation.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatrixUtils : NSObject

+ (matrix_float4x4)perspective:(float)degreesFOV 
                           :(float)aspectRatio
                           :(float)nearPlane
                           :(float)farPlane;

@end

NS_ASSUME_NONNULL_END
