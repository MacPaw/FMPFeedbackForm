//
//  NSImage+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (FMPExtensions)

+ (instancetype)fmp_imageNamed:(NSString *)imageName;
- (NSImage *)fmp_maskedImageWithColor:(NSColor *)color;

@end

NS_ASSUME_NONNULL_END
