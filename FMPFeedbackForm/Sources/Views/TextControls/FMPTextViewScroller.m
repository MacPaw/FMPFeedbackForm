//
//  FMPTextViewScroller.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 20.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextViewScroller.h"
#import "FMPTextView.h"
#import "FMPClipView.h"
#import "NSColor+FMPExtensions.h"

@interface FMPTextViewScroller ()
@property (nonatomic, strong) FMPTextView *textView;
@end

@implementation FMPTextViewScroller

@synthesize view;
@synthesize borderColor = _borderColor;
@synthesize cornerRadius;
@synthesize isEnabled;
@synthesize controlPlaceholderString;
@synthesize trimmedStringValue;
@synthesize stringValue;
@synthesize editingDelegate;

- (instancetype)initWithTextView:(FMPTextView *)textView
{
    self = [super init];
    if (self)
    {
        [self setupWithTextView:textView];
    }
    return self;
}

- (void)setupWithTextView:(FMPTextView *)textView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    self.autohidesScrollers = YES;
    
    self.contentView = [FMPClipView new];
    self.contentView.wantsLayer = YES;
    self.contentView.layer.borderWidth = 1;
    self.borderColor = NSColor.fmp_textFieldBorderColor;
    
    self.textView = textView;
    [self.textView.textContainer setWidthTracksTextView:YES];
    [self.textView setVerticallyResizable:YES];
    [self.textView setAutoresizingMask:NSViewWidthSizable];
    
    [self setDocumentView:self.textView];
    [self setHasVerticalScroller:YES];
    [self setVerticalScrollElasticity:NSScrollElasticityNone];
}

- (BOOL)isOpaque
{
    return NO;
}

- (BOOL)wantsUpdateLayer
{
    return YES;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
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

- (void)updateLayer
{
    self.contentView.layer.borderColor = self.borderColor.CGColor;
}

// MARK: - Fallthrough to text view properties

- (NSView *)view
{
    return self.textView;
}

- (void)setEnabled:(BOOL)isEnabled
{
    [self.textView setEnabled:isEnabled];
}

- (BOOL)isEnabled
{
    return self.textView.isEnabled;
}

- (void)setControlPlaceholderString:(NSString *)placeholderString
{
    self.textView.controlPlaceholderString = placeholderString;
}

- (NSString *)controlPlaceholderString
{
    return self.textView.controlPlaceholderString;
}

- (NSString *)trimmedStringValue
{
    return self.textView.trimmedStringValue;
}

- (NSFont *)font
{
    return self.textView.font;
}

- (void)setFont:(NSFont *)font
{
    self.textView.font = font;
}

- (NSString *)stringValue
{
    return self.textView.stringValue;
}

- (void)setStringValue:(NSString *)stringValue
{
    self.textView.stringValue = stringValue;
}

- (id<FMPTextControlEditingDelegate>)editingDelegate
{
    return self.textView.editingDelegate;
}

- (void)setEditingDelegate:(id<FMPTextControlEditingDelegate>)editingDelegate
{
    self.textView.editingDelegate = editingDelegate;
}

@end
