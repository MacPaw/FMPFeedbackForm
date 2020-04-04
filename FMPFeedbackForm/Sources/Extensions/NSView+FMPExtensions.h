//
//  NSView+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 28.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface NSView (FMPExtensions)

+ (instancetype)fmp_newAutoLayout;
- (BOOL)fmp_hasMouseInsideWithEvent:(NSEvent *)event;

@end

NS_ASSUME_NONNULL_END
