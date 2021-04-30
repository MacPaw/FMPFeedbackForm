//
//  NSColor+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSColor+FMPExtensions.h"
#import "FMPBundleHelper.h"

@implementation NSColor (FMPExtensions)

+ (NSColor *)fmp_dynamicInvertedColor
{
    return [NSColor fmp_colorNamed:@"dynamicInvertedColor"
                     fallbackColor:NSColor.blackColor];
}

+ (NSColor *)fmp_dynamicInverted25AlphaColor
{
    return [NSColor fmp_colorNamed:@"dynamicInverted25AlphaColor"
                     fallbackColor:[NSColor.blackColor colorWithAlphaComponent:0.25]];
}

+ (NSColor *)fmp_dynamicInverted50AlphaColor
{
    return [NSColor fmp_colorNamed:@"dynamicInverted50AlphaColor"
                     fallbackColor:[NSColor.blackColor colorWithAlphaComponent:0.5]];
}

+ (instancetype)fmp_errorColor
{
    return [NSColor fmp_colorNamed:@"errorColor"
                     fallbackColor:[NSColor fmp_colorWithSRGBHex:0xE0383E]];
}

+ (instancetype)fmp_textFieldBackgroundColor
{
    return [NSColor fmp_colorNamed:@"textFieldBackgroundColor"
                     fallbackColor:NSColor.whiteColor];
}

+ (instancetype)fmp_textFieldBorderColor
{
    return [NSColor fmp_colorNamed:@"textFieldBorderColor"
                     fallbackColor:[NSColor fmp_colorWithSRGBHex:0xC5C5C5]];
}

+ (NSColor *)fmp_colorWithSRGBHex:(uint32_t)hex
{
    hex = OSSwapHostToBigInt32(hex);
    hex >>= 8;
    hex |= OSSwapHostToBigInt32(0x000000ff);
    
    uint8_t *components = (uint8_t *)&hex;

    CGFloat maxComponentValue = 255.0;
    CGFloat floatComponents[4];
    for (int i = 0; i < 4; i++)
    {
        floatComponents[i] = components[i] / maxComponentValue;
    }
    return [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace]
                             components:floatComponents
                                  count:4];
}

+ (instancetype)fmp_colorNamed:(NSString *)colorName fallbackColor:(NSColor *)fallbackColor;
{
    if (@available(macOS 10.13, *))
    {
        return [NSColor colorNamed:colorName bundle:FMPBundleHelper.currentBundle];
    }
    else
    {
        return fallbackColor;
    }
}

@end
