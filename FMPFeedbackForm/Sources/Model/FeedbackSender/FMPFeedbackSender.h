//
//  FMPFeedbackSender.h
//  FMPFeedbackSender
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;
#import <FMPFeedbackForm/FMPFeedbackParameter.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FMPSendFeedbackCompletion)(NSError *_Nullable error);

@protocol FMPFeedbackSender <NSObject>

- (void)sendFeedbackWithParameters:(NSDictionary<FMPFeedbackParameter, id> *)parameters
                        completion:(FMPSendFeedbackCompletion)completion;

@optional
@property (nonatomic, assign) NSUInteger maxAttachmentsCount;
@property (nonatomic, assign) NSUInteger maxAttachmentFileSize;

@end

NS_ASSUME_NONNULL_END
