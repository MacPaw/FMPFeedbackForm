//
//  FMPTextField.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.02.2020.
//  Copyright © 2020 MacPaw Way Ltd. All rights reserved.
//

@import Cocoa;
#import "FMPTextControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FMPTextFieldFocusDelegate;

@interface FMPTextField : NSTextField <FMPTextControl>
@property (nonatomic, weak) id<FMPTextFieldFocusDelegate> focusDelegate;
@end

@protocol FMPTextFieldFocusDelegate <NSObject>
- (NSRect)focusRingMaskBoundsForTextField:(FMPTextField *)textField;
@end

NS_ASSUME_NONNULL_END
