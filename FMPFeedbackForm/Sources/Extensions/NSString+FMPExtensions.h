//
//  NSString+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 17.03.2020.
//  Copyright © 2020 MacPaw Way Ltd. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FMPExtensions)
@property (nonatomic, readonly) BOOL fmp_isValidEmail;
@end

NS_ASSUME_NONNULL_END
