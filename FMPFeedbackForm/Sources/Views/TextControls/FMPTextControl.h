//
//  FMPTextControl.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol FMPTextControlEditingDelegate;

@protocol FMPTextControl <NSObject>
@property (nonatomic, strong, readonly) NSView *view;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong, nullable) NSColor *borderColor;
@property (nonatomic, assign, setter=setEnabled:) BOOL isEnabled;
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy, readonly) NSString *trimmedStringValue;
@property (nonatomic, copy, nullable) NSString *controlPlaceholderString;
@property (nonatomic, weak, nullable) id<FMPTextControlEditingDelegate> editingDelegate;
@end

@protocol FMPTextControlEditingDelegate <NSObject>
@optional
- (void)textControlDidBeginEditing:(id<FMPTextControl>)textControl;
- (void)textControlDidChangeValue:(id<FMPTextControl>)textControl;
- (void)textControlDidEndEditing:(id<FMPTextControl>)textControl;
@end

NS_ASSUME_NONNULL_END
