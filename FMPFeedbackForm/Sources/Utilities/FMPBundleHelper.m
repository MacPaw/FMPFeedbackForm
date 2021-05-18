//
//  FMPBundleHelper.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPBundleHelper.h"

@implementation FMPBundleHelper

+ (NSBundle *)currentBundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if SWIFT_PACKAGE
        bundle = SWIFTPM_MODULE_BUNDLE;
#else
        bundle = [NSBundle bundleForClass:[self class]];
#endif
    });
    
    return bundle;
}

@end
