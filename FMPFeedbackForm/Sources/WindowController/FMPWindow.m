//
//  FMPWindow.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPWindow.h"

@implementation FMPWindow

- (instancetype)init
{
    NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable;
    self = [super initWithContentRect:NSZeroRect styleMask:styleMask backing:NSBackingStoreBuffered defer:YES];
    if (self)
    {
        self.autorecalculatesKeyViewLoop = YES;
    }
    return self;
}

@end
