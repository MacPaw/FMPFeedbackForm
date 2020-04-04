//
//  FMPFeedbackController.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@class FMPInterfaceSettings;
@protocol FMPFeedbackSender;

NS_ASSUME_NONNULL_BEGIN

@interface FMPFeedbackController : NSWindowController

+ (instancetype)new NS_UNAVAILABLE;

/// Initializes an instance of feedback controller with default interface settings.
/// @param feedbackSender An object that conforms to @c FMPFeedbackSender protocol and handles data sending.
/// @discussion If you want to send feedback to Zendesk you may use an already implemented @c FMPZendeskFeedbackSender object.
- (instancetype)initWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender;

/// Initializes an instance of feedback controller with custom interface settings.
/// @param feedbackSender An object that conforms to @c FMPFeedbackSender protocol and handles data sending.
/// @param settings An object that contains texts and an optional icon to be displayed in form UI.
/// @discussion If you want to send feedback to Zendesk you may use an already implemented @c FMPZendeskFeedbackSender object.
- (instancetype)initWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender
                              settings:(FMPInterfaceSettings *)settings;

/// URLs of custom log files that will be added to the system profile report.
/// @discussion Won't work with directory URL, please specify separate text files.
@property (nonatomic, strong) NSArray<NSURL *> *logURLs;

/// An object that contains texts and an optional icon to be displayed in form UI.
@property (nonatomic, strong) FMPInterfaceSettings *settings;

/// A block that is executed after form submission.
/// @discussion The @c error parameter contains an error in case of a failed request. In case of success -  @c error is  @c nil.
@property (nonatomic, copy, nullable) void(^onDidSendFeedback)(NSError *_Nullable error);

/// A flag that determines form behaviour after successful submission.
/// @discussion If @c YES (default value) - after successful feedback submission the form window is closed and an alert with localized success message is displayed.
///             If @c NO - nothing happens.
@property (nonatomic, assign) BOOL showsGenericSuccessAlert;

/// A flag that determines form behaviour after failed submission.
/// @discussion If @c YES (default value) - after failed feedback submission an alert containing localized error description is presented as a sheet in the form window.
///             If @c NO - nothing happens.
@property (nonatomic, assign) BOOL showsGenericErrorSheet;

/// A string value of the name form field.
@property (nonatomic, copy, readonly) NSString *name;

/// A string value of the email form field.
@property (nonatomic, copy, readonly) NSString *email;

/// A string value of the subject form field.
@property (nonatomic, copy, readonly) NSString *subject;

/// A string value of the details form field.
@property (nonatomic, copy, readonly) NSString *details;

/// An array of URLs of files attached by user.
@property (nonatomic, strong, readonly) NSArray<NSURL *> *attachments;

@end

NS_ASSUME_NONNULL_END
