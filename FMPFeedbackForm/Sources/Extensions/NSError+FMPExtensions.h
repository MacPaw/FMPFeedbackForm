//
//  NSError+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 16.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FMPErrorCode) {
    FMPErrorCodeInvalidType        = 101,
    FMPErrorCodeInvalidEmail       = 102,
    FMPErrorCodeInvalidSubject     = 103,
    FMPErrorCodeInvalidDetails     = 104,
    FMPErrorCodeInvalidJSON        = 105,
    FMPErrorCodeFailedReadFile     = 106,
    FMPErrorCodeFailedSendRequest  = 107,
    FMPErrorCodeBadResponse        = 108,
    FMPErrorCodeBadInternet        = 109
};

@interface NSError (FMPExtensions)
+ (instancetype)fmp_errorWithCode:(NSInteger)code description:(NSString *)description;
@end

NS_ASSUME_NONNULL_END
