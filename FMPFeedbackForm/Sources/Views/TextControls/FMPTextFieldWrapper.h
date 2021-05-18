//
//  FMPTextFieldWrapper.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 26.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@class FMPTextField;
#import "FMPTextControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPTextFieldWrapper : NSView <FMPTextControl>

- (instancetype)initWithTextField:(FMPTextField *)textField;

@end

NS_ASSUME_NONNULL_END
