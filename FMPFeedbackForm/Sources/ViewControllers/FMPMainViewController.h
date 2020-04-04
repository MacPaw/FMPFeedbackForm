//
//  FMPMainViewController.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 22.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@protocol FMPFileSelectionManager;
#import <FMPFeedbackForm/FMPInterfaceSettings.h>
#import <FMPFeedbackForm/FMPFeedbackSender.h>
#import <FMPFeedbackForm/FMPSystemProfileProvider.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FMPMainViewControllerDelegate;

@interface FMPMainViewController : NSViewController

+ (instancetype)makeWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender
                  fileSelectionManager:(id<FMPFileSelectionManager>)fileSelectionMaganer
                 systemProfileProvider:(id<FMPSystemProfileProvider>)systemProfileProvider
                              settings:(FMPInterfaceSettings *)settings;

@property (nonatomic, strong) FMPInterfaceSettings *settings;
@property (nonatomic, weak) id<FMPMainViewControllerDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *nameFieldValue;
@property (nonatomic, copy, readonly) NSString *emailFieldValue;
@property (nonatomic, copy, readonly) NSString *subjectFieldValue;
@property (nonatomic, copy, readonly) NSString *detailsFieldValue;
@property (nonatomic, strong, readonly) NSArray<NSURL *> *attachments;

@end

@protocol FMPMainViewControllerDelegate
- (void)mainViewController:(FMPMainViewController *)mainViewController
  didSendFeedbackWithError:(nullable NSError *)error;
@end

NS_ASSUME_NONNULL_END
