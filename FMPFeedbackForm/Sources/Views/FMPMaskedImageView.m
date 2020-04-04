//
//  FMPMaskedImageView.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 10.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPMaskedImageView.h"
#import "NSImage+FMPExtensions.h"

@implementation FMPMaskedImageView

- (NSSize)intrinsicContentSize
{
    return self.imageMask.size;
}

- (void)setImageMask:(NSImage *)imageMask
{
    _imageMask = imageMask;
    [self setNeedsDisplay:YES];
}

- (void)setMaskColor:(NSColor *)maskColor
{
    _maskColor = maskColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSImage *image = [self.imageMask fmp_maskedImageWithColor:self.maskColor];
    if (image == nil)
    {
        [super drawRect:dirtyRect];
        return;
    }
    [NSGraphicsContext saveGraphicsState];
    [image drawInRect:[self bounds]];
    [NSGraphicsContext restoreGraphicsState];
}

@end
