//
//  FMPBorderedView.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPBorderedView.h"

@implementation FMPBorderedView

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
    self.wantsLayer = YES;
}

- (BOOL)wantsUpdateLayer
{
    return YES;
}

- (void)updateLayer
{
    self.layer.borderColor = self.borderColor.CGColor;
}

@end
