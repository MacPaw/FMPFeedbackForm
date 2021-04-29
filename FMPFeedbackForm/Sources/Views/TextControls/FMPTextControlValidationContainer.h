//
//  FMPTextControlValidationContainer.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextField.h"
#import "FMPTextControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^FMPValidationBlock)(NSString *value, NSString *_Nullable * _Nullable errorString);

@interface FMPTextControlValidationContainer : NSView

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithTextControl:(id<FMPTextControl>)textControl;
@property (nonatomic, strong, readonly) id<FMPTextControl> textControl;
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, copy, nullable) FMPValidationBlock validationBlock;
- (void)validate;

@end

NS_ASSUME_NONNULL_END
