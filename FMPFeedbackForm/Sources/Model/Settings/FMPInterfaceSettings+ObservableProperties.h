//
//  FMPInterfaceSettings+ObservableProperties.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw Way Ltd. All rights reserved.
//

#import "FMPFeedbackForm.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPInterfaceSettings (ObservableProperties)

@property (nonatomic, strong, class, readonly) NSSet<NSString *> *observableProperties;

@end

NS_ASSUME_NONNULL_END
