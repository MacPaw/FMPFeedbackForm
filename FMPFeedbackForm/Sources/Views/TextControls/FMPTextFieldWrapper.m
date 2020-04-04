//
//  FMPTextFieldWrapper.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 26.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextFieldWrapper.h"
#import "FMPTextField.h"
#import "NSColor+FMPExtensions.h"

@interface FMPTextFieldWrapper () <FMPTextFieldFocusDelegate>
@property (nonatomic, strong) FMPTextField *textField;
@end

@implementation FMPTextFieldWrapper

@synthesize borderColor = _borderColor;
@synthesize controlPlaceholderString;
@synthesize cornerRadius = _cornerRadius;
@synthesize editingDelegate;
@synthesize isEnabled;
@synthesize stringValue;
@synthesize trimmedStringValue;
@synthesize view;

- (instancetype)initWithTextField:(FMPTextField *)textField
{
    self = [super init];
    if (self)
    {
        [self setupWithTextField:textField];
    }
    return self;
}

- (void)setupWithTextField:(FMPTextField *)textField
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.borderColor = NSColor.fmp_textFieldBorderColor;
    
    self.textField = textField;
    self.textField.focusDelegate = self;
    [self addSubview:self.textField];
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-1],
        [self.textField.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:3],
        [self.textField.rightAnchor constraintEqualToAnchor:self.rightAnchor]
    ]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Don't use backing layer so it won't clip textView's focus ring outside the wrapper.
    // Draw all the customization here instead.
    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds
                                                                xRadius:self.cornerRadius
                                                                yRadius:self.cornerRadius];
    
    [NSGraphicsContext saveGraphicsState];
    {
        [NSColor.fmp_textFieldBackgroundColor setFill];
        [roundedPath fill];
        
        if (self.borderColor)
        {
            NSBezierPath *borderPath = roundedPath.bezierPathByReversingPath;
            CGFloat borderRadius = self.cornerRadius > 0.0 ? self.cornerRadius - 1 : 1;
            NSRect borderBounds = NSInsetRect(self.bounds, 1, 1);
            [borderPath appendBezierPath:[NSBezierPath bezierPathWithRoundedRect:borderBounds
                                                                         xRadius:borderRadius
                                                                         yRadius:borderRadius]];
            [self.borderColor setFill];
            [borderPath fill];
        }
    }
    [NSGraphicsContext restoreGraphicsState];
}

// MARK: - FMPTextFieldFocusDelegate

- (NSRect)focusRingMaskBoundsForTextField:(FMPTextField *)textField
{
    return [self convertRect:self.bounds toView:textField];
}

// MARK: - FMPTextControl

- (void)setBorderColor:(NSColor *)borderColor
{
    _borderColor = borderColor;
    self.needsDisplay = YES;
}

- (void)setControlPlaceholderString:(NSString *)controlPlaceholderString
{
    self.textField.controlPlaceholderString = controlPlaceholderString;
}

- (NSString *)controlPlaceholderString
{
    return self.textField.controlPlaceholderString;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.needsDisplay = YES;
}

- (void)setEditingDelegate:(id<FMPTextControlEditingDelegate>)editingDelegate
{
    self.textField.editingDelegate = editingDelegate;
}

- (id<FMPTextControlEditingDelegate>)editingDelegate
{
    return self.textField.editingDelegate;
}

- (void)setEnabled:(BOOL)isEnabled
{
    [self.textField setEnabled:isEnabled];
}

- (BOOL)isEnabled
{
    return self.textField.isEnabled;
}

- (void)setStringValue:(NSString *)stringValue
{
    self.textField.stringValue = stringValue;
}

- (NSString *)stringValue
{
    return self.textField.stringValue;
}

- (NSString *)trimmedStringValue
{
    return self.textField.trimmedStringValue;
}

- (NSView *)view
{
    return self.textField;
}

@end
