//
//  FMPBundleHelper.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPBundleHelper.h"

// We need this check and declaration for Tuist because it does not generate SWIFTPM_MODULE_BUNDLE for objc SPM.
#if SWIFT_PACKAGE && !(defined(SWIFTPM_MODULE_BUNDLE))

NSBundle* SWIFTPM_MODULE_BUNDLE() {
    NSString *bundleName = @"FMPFeedbackForm_FMPFeedbackForm";

    NSArray<NSURL*> *candidates = @[
        NSBundle.mainBundle.resourceURL,
        [NSBundle bundleForClass:[FMPBundleHelper class]].resourceURL,
        NSBundle.mainBundle.bundleURL
    ];

    for (NSURL* candiate in candidates) {
        NSURL *bundlePath = [candiate URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", bundleName]];

        NSBundle *bundle = [NSBundle bundleWithURL:bundlePath];
        if (bundle != nil) {
            return bundle;
        }
    }

    @throw [[NSException alloc] initWithName:@"SwiftPMResourcesAccessor" reason:[NSString stringWithFormat:@"unable to find bundle named %@", bundleName] userInfo:nil];
}

#define SWIFTPM_MODULE_BUNDLE SWIFTPM_MODULE_BUNDLE()

#endif

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
