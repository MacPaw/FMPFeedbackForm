//
//  FMPTransparentSpinner.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 03.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTransparentSpinner.h"

static NSString *const kEffectiveAppearanceKeyPath = @"effectiveAppearance";

@implementation FMPTransparentSpinner

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.style = NSProgressIndicatorStyleSpinning;
    
    self.appearance = NSApplication.sharedApplication.effectiveAppearance;
    [NSApplication.sharedApplication addObserver:self forKeyPath:kEffectiveAppearanceKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kEffectiveAppearanceKeyPath])
    {
        self.appearance = change[NSKeyValueChangeNewKey];
    }
}

- (void)dealloc
{
    if (@available(macOS 10.14, *))
    {
        [NSApplication.sharedApplication removeObserver:self forKeyPath:kEffectiveAppearanceKeyPath];
    }
}

@end
