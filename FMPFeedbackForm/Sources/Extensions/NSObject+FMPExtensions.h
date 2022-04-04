//
//  NSObject+FMPExtensions.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FMPExtensions)
+ (nullable instancetype)fmp_dynamicCastObject:(id)object;
@end

NS_ASSUME_NONNULL_END
