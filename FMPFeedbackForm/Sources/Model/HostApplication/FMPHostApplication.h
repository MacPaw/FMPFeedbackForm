//
//  FMPHostApplication.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 04.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FMPHostApplication : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly, nullable) NSString *bundleID;
@property (nonatomic, strong, readonly, nullable) NSImage *icon;

@end

NS_ASSUME_NONNULL_END
