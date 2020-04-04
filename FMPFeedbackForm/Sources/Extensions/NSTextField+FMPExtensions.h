//
//  NSTextField+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface NSTextField (FMPExtensions)
+ (instancetype)fmp_label;
+ (instancetype)fmp_labelWithString:(NSString *)string;
+ (instancetype)fmp_multilineLabel;
+ (instancetype)fmp_multilineLabelWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
