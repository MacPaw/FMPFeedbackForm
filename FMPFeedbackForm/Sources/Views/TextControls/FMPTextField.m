//
//  FMPTextField.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextField.h"
#import "FMPTextFieldWrapper.h"
#import "NSColor+FMPExtensions.h"

@implementation FMPTextField

@synthesize view;
@synthesize borderColor = _borderColor;
@synthesize cornerRadius;
@synthesize trimmedStringValue;
@synthesize controlPlaceholderString;
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

- (void)setup
{
    self.cell.scrollable = YES;
    self.textColor = NSColor.fmp_dynamicInvertedColor;
    self.backgroundColor = NSColor.clearColor;
    self.bordered = NO;
}

- (NSRect)focusRingMaskBounds
{
    if ([self.focusDelegate respondsToSelector:@selector(focusRingMaskBoundsForTextField:)])
    {
        return [self.focusDelegate focusRingMaskBoundsForTextField:self];
    }
    
    return self.bounds;
}

- (void)drawFocusRingMask
{
    NSRectFill(self.focusRingMaskBounds);
}

- (NSView *)view
{
    return self;
}

- (NSString *)trimmedStringValue
{
    return [self.stringValue stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

- (NSString *)controlPlaceholderString
{
    return self.placeholderString;
}

 - (void)setControlPlaceholderString:(NSString *)controlPlaceholderString
{
    self.placeholderString = controlPlaceholderString;
}

- (void)textDidBeginEditing:(NSNotification *)notification
{
    [super textDidBeginEditing:notification];
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidBeginEditing:)])
    {
        [self.editingDelegate textControlDidBeginEditing:self];
    }
}

- (void)textDidChange:(NSNotification *)notification
{
    [super textDidChange:notification];
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidChangeValue:)])
    {
        [self.editingDelegate textControlDidChangeValue:self];
    }
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [super textDidEndEditing:notification];
    if ([self.editingDelegate respondsToSelector:@selector(textControlDidEndEditing:)])
    {
        [self.editingDelegate textControlDidEndEditing:self];
    }
}

@end
