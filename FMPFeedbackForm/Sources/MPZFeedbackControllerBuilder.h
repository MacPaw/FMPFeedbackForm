//
//  FMPFeedbackControllerBuilder.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;
@class FMPFeedbackController;
@class FMPInterfaceSettings;

NS_ASSUME_NONNULL_BEGIN

@interface FMPFeedbackControllerBuilder : NSObject

- (instancetype)initWithAPIToken:(NSString *)token productName:(NSString *)productName NS_DESIGNATED_INITIALIZER;
- (FMPFeedbackController *)makeFeedbackController;
- (FMPFeedbackController *)makeFeedbackControllerWithSettings:(FMPInterfaceSettings *)settings;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
