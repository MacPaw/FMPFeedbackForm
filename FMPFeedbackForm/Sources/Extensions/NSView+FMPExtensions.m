//
//  NSView+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 28.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSView+FMPExtensions.h"

@implementation NSView (FMPExtensions)

+ (instancetype)fmp_newAutoLayout
{
    NSView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (BOOL)fmp_hasMouseInsideWithEvent:(NSEvent *)event
{
    if (!event)
    {
        return NO;
    }
    NSPoint mouseLocation = [self convertPoint:event.locationInWindow fromView:nil];
    return [self mouse:mouseLocation inRect:self.bounds];
}

@end
