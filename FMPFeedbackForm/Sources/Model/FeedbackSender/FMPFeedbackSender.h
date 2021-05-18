//
//  FMPFeedbackSender.h
//  FMPFeedbackSender
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Foundation;
#import "FMPFeedbackParameter.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^FMPSendFeedbackCompletion)(NSError *_Nullable error);

@protocol FMPFeedbackSender <NSObject>

/// Sends the data submitted by the form to a desired service.
/// @param parameters A dictionary containing all the data submitted by the form. See @c FMPFeedbackParameter enum for the list of possible keys.
/// @param completion A block that should be executed after data sending attempt, has nullable @c NSError as a parameter.
/// You should pass an error if something fails, otherwise execute it with @c nil.
- (void)sendFeedbackWithParameters:(NSDictionary<FMPFeedbackParameter, id> *)parameters
                        completion:(FMPSendFeedbackCompletion)completion;

@optional
/// The number of files that can be attached by the user.
/// @discussion If the user selects more files than allowed by this number — they will be ignored by the form without any visual notification.
/// @note A system profile text file is not accounted for in this number.
///       For example, if user allowed attachments are limited to 10 files — a total of 11 files (including the system profile file) may be submitted by the form.
@property (nonatomic, assign) NSUInteger maxAttachmentsCount;

/// The maximum size in megabytes of a single file attached by the user.
/// @discussion If the user selects files larger than the size allowed by this number — they will be ignored by the form without any visual notification.
@property (nonatomic, assign) NSUInteger maxAttachmentFileSize;

@end

NS_ASSUME_NONNULL_END
