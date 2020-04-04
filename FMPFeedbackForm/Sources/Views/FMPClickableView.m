//
//  FMPClickableView.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPClickableView.h"
#import "NSView+FMPExtensions.h"

@interface FMPClickableView ()
@property (nonatomic, strong, nullable) NSTrackingArea *trackingArea;
@end

@implementation FMPClickableView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
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
    self.isEnabled = YES;
}

- (void)updateTrackingAreas
{
    if (self.trackingArea)
    {
        [self removeTrackingArea:self.trackingArea];
    }
    
    NSTrackingAreaOptions options = NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow;
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame
                                                                options:options
                                                                  owner:self
                                                               userInfo:nil];
    if (trackingArea)
    {
        self.trackingArea = trackingArea;
        [self addTrackingArea:self.trackingArea];
    }
}

- (void)mouseDown:(NSEvent *)event
{
    if (![self fmp_hasMouseInsideWithEvent:event] || !self.isEnabled)
    {
        return;
    }
    
    [self updateAlphaWhilePressed:YES];
    
    BOOL shouldContinue = YES;
    while (shouldContinue)
    {
        NSEvent *event = [self.window nextEventMatchingMask:NSEventMaskLeftMouseDragged | NSEventMaskLeftMouseUp];
        switch (event.type)
        {
            case NSEventTypeLeftMouseDragged:
                [self updateAlphaWhilePressed:[self fmp_hasMouseInsideWithEvent:event]];
                break;
                
            case NSEventTypeLeftMouseUp:
                if ([self fmp_hasMouseInsideWithEvent:event] && self.delegate)
                {
                    [self.delegate clickableViewDidReceiveClick:self];
                }
                shouldContinue = NO;
                break;
                
            default:
                break;
        }
    }
    [self updateAlphaWhilePressed:NO];
}

- (void)updateAlphaWhilePressed:(BOOL)isPressed
{
    self.alphaValue = isPressed ? 0.5 : 1.0;
}

@end
