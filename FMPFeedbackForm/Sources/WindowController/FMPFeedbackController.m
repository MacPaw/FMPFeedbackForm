//
//  FMPFeedbackForm.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPFeedbackController.h"
#import "FMPInterfaceSettings.h"
#import "FMPFeedbackSender.h"
#import "FMPMainViewController.h"
#import "FMPWindow.h"
#import "FMPDefaultFileSelectionManager.h"
#import "FMPDefaultSystemProfileProvider.h"
#import "NSError+FMPExtensions.h"
#import "NSObject+FMPExtensions.h"
#import "FMPLocalizedString.h"
#import "FMPHostApplication.h"

@interface FMPFeedbackController () <FMPMainViewControllerDelegate>
@property (nonatomic, strong) id<FMPFeedbackSender> feedbackSender;
@property (nonatomic, strong) id<FMPSystemProfileProvider> systemProfileProvider;
@end

@implementation FMPFeedbackController

- (instancetype)initWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender;
{
    return [[FMPFeedbackController alloc] initWithFeedbackSender:feedbackSender settings:FMPInterfaceSettings.defaultSettings];
}

- (instancetype)initWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender settings:(FMPInterfaceSettings *)settings
{
    self = [super initWithWindow:[FMPWindow new]];
    if (self)
    {
        [self setupWithFeedbackSender:feedbackSender settings:settings];
    }
    return self;
}

- (void)setupWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender settings:(FMPInterfaceSettings *)settings
{
    self.showsGenericSuccessAlert = YES;
    self.showsGenericErrorSheet = YES;
    
    self.feedbackSender = feedbackSender;
    
    FMPDefaultFileSelectionManager *fileSelectionMaganer = [[FMPDefaultFileSelectionManager alloc] initWithWindow:self.window];
    self.systemProfileProvider = [FMPDefaultSystemProfileProvider new];
    
    FMPMainViewController *mainViewController = [FMPMainViewController makeWithFeedbackSender:feedbackSender
                                                                         fileSelectionManager:fileSelectionMaganer
                                                                        systemProfileProvider:self.systemProfileProvider
                                                                                     settings:settings];
    self.window.title = settings.windowTitle;
    mainViewController.delegate = self;
    self.contentViewController = mainViewController;
}

- (FMPMainViewController *)mainViewController
{
    return [FMPMainViewController fmp_dynamicCastObject:self.contentViewController];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    [self.window center];
}

// MARK: - Log URLs

- (void)setLogURLs:(NSArray<NSURL *> *)logURLs
{
    self.systemProfileProvider.logURLs = logURLs;
}

- (NSArray<NSURL *> *)logURLs
{
    return self.systemProfileProvider.logURLs;
}

// MARK: - User defaults domain

- (void)setUserDefaultsDomain:(NSString *)userDefaultsDomain
{
    self.systemProfileProvider.userDefaultsDomain = userDefaultsDomain;
}

- (NSString *)userDefaultsDomain
{
    return self.systemProfileProvider.userDefaultsDomain;
}

// MARK: - Settings

- (void)setSettings:(FMPInterfaceSettings *)settings
{
    self.mainViewController.settings = settings;
}

- (FMPInterfaceSettings *)settings
{
    return self.mainViewController.settings;
}

// MARK: - Form field values

- (NSString *)name
{
    return self.mainViewController.nameFieldValue;
}

- (NSString *)email
{
    return self.mainViewController.emailFieldValue;
}

- (NSString *)subject
{
    return self.mainViewController.subjectFieldValue;
}

- (NSString *)details
{
    return self.mainViewController.detailsFieldValue;
}

- (NSArray<NSURL *> *)attachments
{
    return self.mainViewController.attachments;
}

// MARK: - FMPMainViewControllerDelegate

- (void)mainViewController:(FMPMainViewController *)mainViewController didSendFeedbackWithError:(nullable NSError *)error
{
    [self performActionsIfNeededOnFeedbackSentWithError:error];
    if (self.onDidSendFeedback)
    {
        self.onDidSendFeedback(error);
    }
}

- (void)performActionsIfNeededOnFeedbackSentWithError:(nullable NSError *)error
{
    // Error not nil, show error sheet
    if (error && self.showsGenericErrorSheet)
    {
        // Display a separate error for bad Internet connection, all other errors get a generic error text with error code in brackets.
        NSString *errorTitle;
        NSString *errorText;
        if (error.code == FMPErrorCodeBadInternet)
        {
            errorTitle = FMPLocalizedString(@"Connect to the internet to send feedback", @"Internet connection error title.");
            errorText = FMPLocalizedString(@"Check your network connection or Firewall settings and try again.", @"Internet connection error text.");
        }
        else
        {
            errorTitle = FMPLocalizedString(@"An error occurred while sending report.", @"Generic error title.");
            errorText = [NSString stringWithFormat:FMPLocalizedString(@"Please make sure you've filled the form correctly and try again (error code: %@).", @"Generic error text."), @(error.code)];
        }
        NSAlert *errorAlert = [self alertWithTitle:errorTitle text:errorText];
        [errorAlert beginSheetModalForWindow:self.window completionHandler:nil];
    }
    // Feedback sent, close form window and show success alert
    else if (!error && self.showsGenericSuccessAlert)
    {
        NSAlert *successAlert = [self alertWithTitle:FMPLocalizedString(@"Feedback successfully sent!", @"Successful feedback send message title.")
                                                text:FMPLocalizedString(@"Every user report gets carefully analyzed, however, not all requests will be answered directly.\nThank you for helping us make our products better!", @"Successful feedback send message text.")];
        [self.window performClose:self];
        [successAlert runModal];
    }
}

- (NSAlert *)alertWithTitle:(NSString *)title text:(NSString *)text
{
    NSAlert *alert = [NSAlert new];
    alert.icon = self.settings.icon ?: FMPHostApplication.sharedInstance.icon;
    alert.messageText = title;
    alert.informativeText = text;
    [alert addButtonWithTitle:FMPLocalizedString(@"OK", @"Alert window button title.")];
    return alert;
}

@end
