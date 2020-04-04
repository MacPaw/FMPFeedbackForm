//
//  FMPMaskedImageView.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 10.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface FMPMaskedImageView : NSView

@property (nonatomic, strong, nullable) NSImage *imageMask;
@property (nonatomic, strong, nullable) NSColor *maskColor;

@end

NS_ASSUME_NONNULL_END
