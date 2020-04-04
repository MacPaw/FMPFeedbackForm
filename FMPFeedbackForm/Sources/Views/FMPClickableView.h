//
//  FMPClickableView.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@class FMPClickableView;

@protocol FMPClickableViewDelegate
- (void)clickableViewDidReceiveClick:(FMPClickableView *)clickableView;
@end

@interface FMPClickableView : NSView
@property (nonatomic, weak) id<FMPClickableViewDelegate> delegate;
@property (nonatomic, assign, setter=setEnabled:) BOOL isEnabled;
@end

NS_ASSUME_NONNULL_END
