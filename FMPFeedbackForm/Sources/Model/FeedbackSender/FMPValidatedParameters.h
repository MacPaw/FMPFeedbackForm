//
//  FMPValidatedParameters.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FMPValidatedParameters : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithEmail:(NSString *)email
                      subject:(NSString *)subject
                      details:(NSString *)details NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *subject;
@property (nonatomic, copy, readonly) NSString *details;

@end

NS_ASSUME_NONNULL_END
