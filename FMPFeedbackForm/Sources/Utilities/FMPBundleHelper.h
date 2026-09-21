//
//  FMPBundleHelper.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw Way Ltd. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FMPBundleHelper : NSObject
@property (nonatomic, strong, class, readonly) NSBundle *currentBundle;
@end

NS_ASSUME_NONNULL_END
