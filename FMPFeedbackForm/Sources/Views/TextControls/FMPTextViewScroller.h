//
//  FMPTextViewScroller.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 20.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@class FMPTextView;
#import <FMPFeedbackForm/FMPTextControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMPTextViewScroller : NSScrollView <FMPTextControl>

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithTextView:(FMPTextView *)textView;
@property (nonatomic, strong, readonly) FMPTextView *textView;

@end

NS_ASSUME_NONNULL_END
