//
//  NSImage+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSImage+FMPExtensions.h"
#import "FMPBundleHelper.h"

@implementation NSImage (FMPExtensions)

+ (instancetype)fmp_imageNamed:(NSString *)imageName
{
#if SWIFT_PACKAGE
    return [SWIFTPM_MODULE_BUNDLE imageForResource:imageName];
#else
    return [FMPBundleHelper.currentBundle imageForResource:imageName];
#endif
}

- (NSImage *)fmp_maskedImageWithColor:(NSColor *)color
{
    NSRect imageRect = NSZeroRect;
    imageRect.size = self.size;
    CGImageRef maskImage = [self CGImageForProposedRect:&imageRect
                                                context:nil
                                                  hints:@{NSImageHintInterpolation : @(NSImageInterpolationHigh)}];
    if (maskImage == NULL)
    {
        return nil;
    }
    
    NSImage *maskedImage = [[NSImage alloc] initWithSize:imageRect.size];
    [maskedImage lockFocus];
    {
        CGContextClipToMask(NSGraphicsContext.currentContext.CGContext, imageRect, maskImage);
        [color setFill];
        NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceOver);
    }
    [maskedImage unlockFocus];
    
    return maskedImage;
}

@end
