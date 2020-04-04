//
//  FMPDefaultFileSelectionManager.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 12.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
#import <FMPFeedbackForm/FMPFileSelectionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMPDefaultFileSelectionManager : NSObject <FMPFileSelectionManager>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithWindow:(NSWindow *)window NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
