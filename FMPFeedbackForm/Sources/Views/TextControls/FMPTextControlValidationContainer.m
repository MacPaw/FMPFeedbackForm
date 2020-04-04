//
//  FMPTextControlValidationContainer.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextControlValidationContainer.h"
#import "NSColor+FMPExtensions.h"
#import "NSObject+FMPExtensions.h"
#import "NSTextField+FMPExtensions.h"

@interface FMPTextControlValidationContainer () <FMPTextControlEditingDelegate>
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, strong) NSTextField *errorLabel;
@property (nonatomic, strong) id<FMPTextControl> textControl;
@property (nonatomic, strong) NSLayoutConstraint *textControlToErrorLabelBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textControlToSuperviewBottomConstraint;
@end

@implementation FMPTextControlValidationContainer

- (instancetype)initWithTextControl:(id<FMPTextControl>)textControl
{
    self = [super init];
    if (self)
    {
        [self setupWithTextControl:textControl];
    }
    return self;
}

- (void)setupWithTextControl:(id<FMPTextControl>)textControl;
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textControl = textControl;
    self.textControl.editingDelegate = self;
    NSView *textControlView = [NSView fmp_dynamicCastObject:self.textControl];
    textControlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:textControlView];
    [NSLayoutConstraint activateConstraints:@[
        [textControlView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [textControlView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [textControlView.rightAnchor constraintEqualToAnchor:self.rightAnchor]
    ]];
    
    self.errorLabel = [NSTextField fmp_label];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.font = [NSFont systemFontOfSize:11];
    self.errorLabel.textColor = NSColor.fmp_errorColor;
    [self.errorLabel setHidden:YES];
    [self addSubview:self.errorLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.errorLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.errorLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.errorLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor]
    ]];
    
    self.textControlToErrorLabelBottomConstraint = [textControlView.bottomAnchor constraintEqualToAnchor:self.errorLabel.topAnchor constant:-5];
    self.textControlToSuperviewBottomConstraint = [textControlView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    [self.textControlToSuperviewBottomConstraint setActive:YES];
    
    self.isValid = YES;
}

- (void)validate
{
    NSString *errorString = nil;
    if (self.validationBlock)
    {
        self.isValid = self.validationBlock(self.textControl.trimmedStringValue, &errorString);
    }
    
    self.isValid ? [self showDefaultState] : [self showInvalidStateWithString:errorString];
}

- (void)showInvalidStateWithString:(NSString *)errorString
{
    self.textControl.borderColor = NSColor.fmp_errorColor;
    
    if (errorString.length > 0)
    {
        [self.errorLabel setStringValue:errorString];
        [self.errorLabel setHidden:NO];
        [self.textControlToSuperviewBottomConstraint setActive:NO];
        [self.textControlToErrorLabelBottomConstraint setActive:YES];
    }
}

- (void)showDefaultState
{
    self.textControl.borderColor = NSColor.fmp_textFieldBorderColor;
    
    [self.errorLabel setHidden:YES];
    [self.textControlToErrorLabelBottomConstraint setActive:NO];
    [self.textControlToSuperviewBottomConstraint setActive:YES];
}

// MARK: - FMPTextControlEditingDelegate

- (void)textControlDidChangeValue:(id<FMPTextControl>)textControl
{
    [self showDefaultState];
}

- (void)textControlDidEndEditing:(id<FMPTextControl>)textControl
{
    [self validate];
}

@end
