//
//  FMPTextView.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 02.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextView.h"
#import "NSColor+FMPExtensions.h"
@import Carbon;

@implementation FMPTextView

@synthesize view;
@synthesize isEnabled = _isEnabled;
@synthesize borderColor = _borderColor;
@synthesize controlPlaceholderString;
@synthesize trimmedStringValue;
@synthesize cornerRadius;
@synthesize editingDelegate;

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self unsubscribeFromTextNotifications];
}

- (void)setup
{
    self.wantsLayer = YES;
    self.isEnabled = YES;
    self.richText = NO;
    self.backgroundColor = NSColor.fmp_textFieldBackgroundColor;
    self.textContainerInset = NSMakeSize(0, 5);
    self.layer.borderWidth = 1;
    
    [self subscribeToTextNotifications];
}

- (void)setEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    [self setEditable:isEnabled];
    NSColor *textColor = NSColor.fmp_dynamicInvertedColor;
    self.textColor = isEnabled ? textColor : [textColor colorWithAlphaComponent:0.5];
    self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    if (self.shouldDrawPlaceholder)
    {
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc]
                                                                  initWithString:self.controlPlaceholderString];
        [placeholderAttributedString setAttributes:@{
            NSFontAttributeName: [NSFont systemFontOfSize:13],
            NSForegroundColorAttributeName: NSColor.placeholderTextColor
        } range:NSMakeRange(0, placeholderAttributedString.length)];
        [placeholderAttributedString drawAtPoint:NSMakePoint(4,4)];
    }
    
    self.layer.borderColor = self.borderColor.CGColor;
}

- (BOOL)isOpaque
{
    return NO;
}

- (BOOL)shouldDrawPlaceholder
{
    return self.controlPlaceholderString && self.string.length == 0;
}

// MARK: - Handle Tab key press

- (void)keyDown:(NSEvent *)event
{
    if (event.keyCode == kVK_Tab)
    {
        NSUInteger modifiers = [event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask;
        if (modifiers == 0)
        {
            [self.window selectNextKeyView:nil];
        }
        else if (modifiers == NSEventModifierFlagShift)
        {
            [self.window selectPreviousKeyView:nil];
        }
    }
    else
    {
        [super keyDown:event];
    }
}

// MARK: - Text notifications

- (void)subscribeToTextNotifications
{
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textDidBeginEditing)
                                               name:NSTextDidBeginEditingNotification
                                             object:self];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textDidChange)
                                               name:NSTextDidChangeNotification
                                             object:self];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textDidEndEditing)
                                               name:NSTextDidEndEditingNotification
                                             object:self];
}

- (void)textDidBeginEditing
{
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidBeginEditing:)])
    {
        [self.editingDelegate textControlDidBeginEditing:self];
    }
}

- (void)textDidChange
{
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidChangeValue:)])
    {
        [self.editingDelegate textControlDidChangeValue:self];
    }
}

- (void)textDidEndEditing
{
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidEndEditing:)])
    {
        [self.editingDelegate textControlDidEndEditing:self];
    }
}

- (void)unsubscribeFromTextNotifications
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

// MARK: - FMPTextControl

- (NSView *)view
{
    return self;
}

- (NSString *)stringValue
{
    return self.string;
}

- (void)setStringValue:(NSString *)value
{
    [self setString:value];
}

- (NSString *)trimmedStringValue
{
    return [self.string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(NSColor *)borderColor
{
    _borderColor = borderColor;
    self.needsDisplay = YES;
}

@end
