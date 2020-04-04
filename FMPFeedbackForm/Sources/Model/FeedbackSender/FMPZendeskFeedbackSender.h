//
//  FMPZendeskFeedbackSender.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;
#import <FMPFeedbackForm/FMPFeedbackSender.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMPZendeskFeedbackSender : NSObject <FMPFeedbackSender>

- (instancetype)initWithZendeskSubdomain:(NSString *)subdomain
                               authToken:(NSString *)authToken
                             productName:(NSString *)productName NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
