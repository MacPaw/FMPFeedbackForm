//
//  NSColor+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (FMPExtensions)

+ (instancetype)fmp_dynamicInvertedColor;
+ (instancetype)fmp_dynamicInverted25AlphaColor;
+ (instancetype)fmp_dynamicInverted50AlphaColor;
+ (instancetype)fmp_errorColor;
+ (instancetype)fmp_textFieldBackgroundColor;
+ (instancetype)fmp_textFieldBorderColor;
+ (instancetype)fmp_colorWithSRGBHex:(uint32_t)hex;

@end

NS_ASSUME_NONNULL_END
