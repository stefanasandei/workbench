//
//  GraphicsContext.h
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

#import "Tweaks.h"

NS_ASSUME_NONNULL_BEGIN

@interface AAPLRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

- (void)setTweaks:(Tweaks)tweaks;

@end

NS_ASSUME_NONNULL_END
