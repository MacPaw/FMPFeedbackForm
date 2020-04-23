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

/// Initializes an instance of Zendesk feedback sender object.
/// @param subdomain The "subdomain" in "https://subdomain.zendesk.com".
/// @param authToken Your Zendesk project API token, you may generate one in the admin panel. Please refer to Zendesk Support API doc for more information.
/// @param productName Your product name, used as a prefix it support ticket's subject, e.g. "[ProductName] Bug Report".
- (instancetype)initWithZendeskSubdomain:(NSString *)subdomain
                               authToken:(NSString *)authToken
                             productName:(NSString *)productName NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
