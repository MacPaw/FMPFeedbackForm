//
//  FMPMainViewController.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 22.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPMainViewController.h"
#import "FMPTextView.h"
#import "FMPTextField.h"
#import "FMPTextFieldWrapper.h"
#import "FMPTextViewScroller.h"
#import "FMPTextControlValidationContainer.h"
#import "FMPAttachmentsViewController.h"
#import "FMPSystemProfileViewController.h"
#import "FMPSystemProfileProvider.h"
#import "FMPClickableView.h"
#import "FMPMaskedImageView.h"
#import "FMPInterfaceSettings+ObservableProperties.h"
#import "NSView+FMPExtensions.h"
#import "NSImage+FMPExtensions.h"
#import "NSString+FMPExtensions.h"
#import "NSColor+FMPExtensions.h"
#import "NSObject+FMPExtensions.h"
#import "NSTextField+FMPExtensions.h"
#import "FMPLocalizedString.h"

static CGFloat textFieldHeight = 24.0;
static CGFloat minTextFieldWidth = 295.0;
static CGFloat minTextViewHeight = 110.0;
static CGFloat textControlCornerRadius = 2.0;
static CGFloat textControlFontSize = 13.0;

@interface FMPMainViewController () <FMPClickableViewDelegate>

@property (nonatomic, strong) id<FMPFeedbackSender> feedbackSender;
@property (nonatomic, strong) id<FMPFileSelectionManager> fileSelectionManager;
@property (nonatomic, strong) id<FMPSystemProfileProvider> systemProfileProvider;

@property (nonatomic, strong) NSView *mainContainer;
@property (nonatomic, strong) NSView *iconContainer;
@property (nonatomic, strong) NSImageView *iconView;
@property (nonatomic, strong) NSView *formContainer;
@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSTextField *subtitleLabel;
@property (nonatomic, strong) NSPopUpButton *subjectButton;
@property (nonatomic, strong) FMPTextFieldWrapper *nameFieldWrapper;
@property (nonatomic, strong) FMPTextControlValidationContainer *emailFieldContainer;
@property (nonatomic, strong) FMPTextControlValidationContainer *detailsFieldContainer;
@property (nonatomic, strong) FMPAttachmentsViewController *attachmentsViewController;
@property (nonatomic, strong) NSButton *systemProfileCheckbox;
@property (nonatomic, strong) FMPClickableView *systemInfoClickableView;
@property (nonatomic, strong) FMPSystemProfileViewController *systemProfileViewController;
@property (nonatomic, strong) NSButton *sendButton;
@property (nonatomic, strong) NSString *sendButtonDefaultTitle;
@property (nonatomic, strong) NSString *sendButtonSendingTitle;
@property (nonatomic, strong) NSProgressIndicator *progressSpinner;

@property (nonatomic, strong) NSLayoutConstraint *iconWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *iconHeightConstraint;

@property (nonatomic, strong) NSLayoutConstraint *formContainerToSuperviewLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *formContainerToIconContainerLeftConstraint;

@property (nonatomic, assign) BOOL isSendingForm;

@end

@implementation FMPMainViewController

+ (instancetype)makeWithFeedbackSender:(id<FMPFeedbackSender>)feedbackSender
                  fileSelectionManager:(id<FMPFileSelectionManager>)fileSelectionMaganer
                 systemProfileProvider:(id<FMPSystemProfileProvider>)systemProfileProvider
                              settings:(FMPInterfaceSettings *)settings
{
    FMPMainViewController *viewController = [FMPMainViewController new];
    viewController.feedbackSender = feedbackSender;
    viewController.fileSelectionManager = fileSelectionMaganer;
    viewController.settings = settings;
    viewController.systemProfileProvider = systemProfileProvider;
    return viewController;
}

- (void)loadView
{
    self.view = [NSView fmp_newAutoLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMainContainer];
    [self setupIconContainer];
    [self setupFormContainer];
    [self updateUIWithSettings];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    [self focusFirstEmptyField];
}

// MARK: - Settings observation

- (void)setSettings:(FMPInterfaceSettings *)settings
{
    if (_settings)
    {
        [self stopSettingsObservation];
    }
    _settings = settings;
    [self updateUIWithSettings];
    [self startSettingsObservation];
}

- (void)startSettingsObservation
{
    for (NSString *property in FMPInterfaceSettings.observableProperties)
    {
        [self.settings addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)stopSettingsObservation
{
    for (NSString *property in FMPInterfaceSettings.observableProperties)
    {
        [self.settings removeObserver:self forKeyPath:property context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqualTo:self.settings])
    {
        [self updateUIWithSettings];
    }
}

// MARK: - Public field values

- (NSString *)nameFieldValue
{
    return self.nameFieldWrapper.stringValue;
}

- (NSString *)emailFieldValue
{
    return self.emailFieldContainer.textControl.stringValue;
}

- (NSString *)subjectFieldValue
{
    return self.subjectButton.selectedItem.title;
}

- (NSString *)detailsFieldValue
{
    return self.detailsFieldContainer.textControl.stringValue;
}

- (NSArray<NSURL *> *)attachments
{
    return self.attachmentsViewController.attachments;
}

// MARK: - Setup UI

- (void)setupMainContainer
{
    self.mainContainer = [NSView fmp_newAutoLayout];
    [self.view addSubview:self.mainContainer];
    [NSLayoutConstraint activateConstraints:@[
        [self.mainContainer.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:15],
        [self.mainContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20],
        [self.mainContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20],
        [self.mainContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20]
    ]];
}

- (void)setupIconContainer
{
    self.iconContainer = [NSView fmp_newAutoLayout];
    [self.mainContainer addSubview:self.iconContainer];
    [NSLayoutConstraint activateConstraints:@[
        [self.iconContainer.topAnchor constraintEqualToAnchor:self.mainContainer.topAnchor constant:3],
        [self.iconContainer.leftAnchor constraintEqualToAnchor:self.mainContainer.leftAnchor constant:3],
        [self.iconContainer.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor]
    ]];
 
    self.iconView = [NSImageView fmp_newAutoLayout];
    [self.iconView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [self.iconView setImageAlignment:NSImageAlignCenter];
    [self.iconContainer addSubview:self.iconView];
    self.iconWidthConstraint = [self.iconView.widthAnchor constraintEqualToConstant:64];
    self.iconHeightConstraint = [self.iconView.heightAnchor constraintEqualToConstant:64];
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.topAnchor constraintEqualToAnchor:self.iconContainer.topAnchor],
        [self.iconView.leftAnchor constraintEqualToAnchor:self.iconContainer.leftAnchor],
        [self.iconView.bottomAnchor constraintLessThanOrEqualToAnchor:self.iconContainer.bottomAnchor],
        [self.iconView.rightAnchor constraintEqualToAnchor:self.iconContainer.rightAnchor],
        self.iconWidthConstraint,
        self.iconHeightConstraint
    ]];
}

- (void)setupFormContainer
{
    self.formContainer = [NSView fmp_newAutoLayout];
    [self.mainContainer addSubview:self.formContainer];
    self.formContainerToSuperviewLeftConstraint = [self.formContainer.leftAnchor constraintEqualToAnchor:self.mainContainer.leftAnchor];
    self.formContainerToIconContainerLeftConstraint = [self.formContainer.leftAnchor constraintEqualToAnchor:self.iconContainer.rightAnchor constant:18];
    [NSLayoutConstraint activateConstraints:@[
        [self.formContainer.topAnchor constraintEqualToAnchor:self.mainContainer.topAnchor],
        self.formContainerToSuperviewLeftConstraint,
        [self.formContainer.bottomAnchor constraintEqualToAnchor:self.mainContainer.bottomAnchor],
        [self.formContainer.rightAnchor constraintEqualToAnchor:self.mainContainer.rightAnchor]
    ]];
    
    [self setupTitle];
    [self setupSubtitle];
    [self setupSubjectButton];
    [self setupNameField];
    [self setupEmailField];
    [self setupDetailsField];
    [self setupAttachmentsViewController];
    [self setupSystemProfileViewController];
    [self setupSendButton];
    [self setupProgressSpinner];
    [self setupKeyViewLoop];
}

- (void)setupTitle
{
    self.titleLabel = [NSTextField fmp_multilineLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [NSFont systemFontOfSize:14 weight:NSFontWeightBold];
    self.titleLabel.textColor = NSColor.fmp_dynamicInvertedColor;
    [self.formContainer addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.formContainer.topAnchor],
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [self.titleLabel.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor]
    ]];
}

- (void)setupSubtitle
{
    self.subtitleLabel = [NSTextField fmp_multilineLabel];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [NSFont systemFontOfSize:11];
    self.subtitleLabel.textColor = NSColor.fmp_dynamicInvertedColor;
    self.subtitleLabel.alphaValue = 0.9;
    [self.formContainer addSubview:self.subtitleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [self.subtitleLabel.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [self.subtitleLabel.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor]
    ]];
}

- (void)setupSubjectButton
{
    self.subjectButton = [NSPopUpButton fmp_newAutoLayout];
    self.subjectButton.font = [NSFont systemFontOfSize:13.0];
    [self.formContainer addSubview:self.subjectButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.subjectButton.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:14]
    ]];
    [NSLayoutConstraint activateConstraints:@[
        [self.subjectButton.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor constant:1],
        [self.subjectButton.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor constant:-1]
    ]];
}

- (void)setupNameField
{
    FMPTextField *nameField = [FMPTextField fmp_newAutoLayout];
    nameField.font = [NSFont systemFontOfSize:textControlFontSize];
    self.nameFieldWrapper = [[FMPTextFieldWrapper alloc] initWithTextField:nameField];
    self.nameFieldWrapper.cornerRadius = textControlCornerRadius;
    [self.formContainer addSubview:self.nameFieldWrapper];
    [NSLayoutConstraint activateConstraints:@[
        [self.nameFieldWrapper.topAnchor constraintEqualToAnchor:self.subjectButton.bottomAnchor constant:10],
        [self.nameFieldWrapper.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [self.nameFieldWrapper.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor],
        [self.nameFieldWrapper.widthAnchor constraintGreaterThanOrEqualToConstant:minTextFieldWidth],
        [self.nameFieldWrapper.heightAnchor constraintEqualToConstant:textFieldHeight]
    ]];
}

- (void)setupEmailField
{
    FMPTextField *textField = [FMPTextField fmp_newAutoLayout];
    textField.font = [NSFont systemFontOfSize:textControlFontSize];
    
    FMPTextFieldWrapper *wrapper = [[FMPTextFieldWrapper alloc] initWithTextField:textField];
    wrapper.cornerRadius = textControlCornerRadius;
    [NSLayoutConstraint activateConstraints:@[
        [wrapper.heightAnchor constraintEqualToConstant:textFieldHeight]
    ]];
    
    self.emailFieldContainer = [[FMPTextControlValidationContainer alloc] initWithTextControl:wrapper];
    
    self.emailFieldContainer.validationBlock = ^BOOL(NSString * _Nonnull value,
                                                     NSString * _Nullable __autoreleasing * _Nullable errorString) {
        if (value.length == 0)
        {
            return NO;
        }
        else if (!value.fmp_isValidEmail)
        {
            *errorString = FMPLocalizedString(@"Incorrect email", @"Invalid email error text.");
            return NO;
        }
        
        return YES;
    };
    
    [self.formContainer addSubview:self.emailFieldContainer];
    [NSLayoutConstraint activateConstraints:@[
        [self.emailFieldContainer.topAnchor constraintEqualToAnchor:self.nameFieldWrapper.bottomAnchor constant:10],
        [self.emailFieldContainer.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [self.emailFieldContainer.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor],
        [self.emailFieldContainer.widthAnchor constraintGreaterThanOrEqualToConstant:minTextFieldWidth],
        [self.emailFieldContainer.heightAnchor constraintGreaterThanOrEqualToConstant:textFieldHeight]
    ]];
}

- (void)setupDetailsField
{
    FMPTextView *textView = [FMPTextView new];
    textView.font = [NSFont systemFontOfSize:textControlFontSize];
    FMPTextViewScroller *textViewScroller = [[FMPTextViewScroller alloc] initWithTextView:textView];
    textViewScroller.focusRingType = NSFocusRingTypeExterior;
    self.detailsFieldContainer = [[FMPTextControlValidationContainer alloc] initWithTextControl:textViewScroller];
    self.detailsFieldContainer.textControl.cornerRadius = textControlCornerRadius;
    
    self.detailsFieldContainer.validationBlock = ^BOOL(NSString * _Nonnull value,
                                                       NSString * _Nullable __autoreleasing * _Nullable errorString) {
        return value.length > 0;
    };
    
    [self.formContainer addSubview:self.detailsFieldContainer];
    [NSLayoutConstraint activateConstraints:@[
        [self.detailsFieldContainer.topAnchor constraintEqualToAnchor:self.emailFieldContainer.bottomAnchor constant:10],
        [self.detailsFieldContainer.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [self.detailsFieldContainer.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor],
        [self.detailsFieldContainer.widthAnchor constraintGreaterThanOrEqualToConstant:minTextFieldWidth],
        [self.detailsFieldContainer.heightAnchor constraintGreaterThanOrEqualToConstant:minTextViewHeight]
    ]];
}

- (void)setupAttachmentsViewController
{
    self.attachmentsViewController = [[FMPAttachmentsViewController alloc] initWithFileSelectionManager:self.fileSelectionManager];
    self.attachmentsViewController.maxAttachmentsCount = @(self.feedbackSender.maxAttachmentsCount);
    self.attachmentsViewController.maxAttachmentFileSize = @(self.feedbackSender.maxAttachmentFileSize);
    
    [self addChildViewController:self.attachmentsViewController];
    NSView *attachmentsView = self.attachmentsViewController.view;
    [self.formContainer addSubview:attachmentsView];
    [NSLayoutConstraint activateConstraints:@[
        [attachmentsView.topAnchor constraintEqualToAnchor:self.detailsFieldContainer.bottomAnchor constant:6],
        [attachmentsView.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor],
        [attachmentsView.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor]
    ]];
}

- (void)setupSystemProfileViewController
{
    self.systemProfileViewController = [[FMPSystemProfileViewController alloc]
                                        initWithSystemProfileProvider:self.systemProfileProvider];
    
    self.systemProfileCheckbox = [NSButton fmp_newAutoLayout];
    self.systemProfileCheckbox.buttonType = NSButtonTypeSwitch;
    NSAttributedString *title = [[NSAttributedString alloc]
                                 initWithString:FMPLocalizedString(@"Send anonymous system profile",
                                                                   @"System profile checkbox title.")
                                 attributes:@{ NSForegroundColorAttributeName: NSColor.fmp_dynamicInvertedColor }];
    self.systemProfileCheckbox.attributedTitle = title;
    [self.formContainer addSubview:self.systemProfileCheckbox];
    [NSLayoutConstraint activateConstraints:@[
        [self.systemProfileCheckbox.topAnchor constraintEqualToAnchor:self.attachmentsViewController.view.bottomAnchor constant:15],
        [self.systemProfileCheckbox.leftAnchor constraintEqualToAnchor:self.formContainer.leftAnchor]
    ]];
    
    self.systemInfoClickableView = [FMPClickableView fmp_newAutoLayout];
    self.systemInfoClickableView.delegate = self;
    [self.formContainer addSubview:self.systemInfoClickableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.systemInfoClickableView.leftAnchor constraintEqualToAnchor:self.systemProfileCheckbox.rightAnchor constant:2],
        [self.systemInfoClickableView.centerYAnchor constraintEqualToAnchor:self.systemProfileCheckbox.centerYAnchor],
        [self.systemInfoClickableView.widthAnchor constraintEqualToConstant:16],
        [self.systemInfoClickableView.heightAnchor constraintEqualToConstant:16]
    ]];
    
    FMPMaskedImageView *infoIcon = [FMPMaskedImageView fmp_newAutoLayout];
    infoIcon.imageMask = [NSImage fmp_imageNamed:@"infoIcon"];
    infoIcon.maskColor = [NSColor fmp_dynamicInverted25AlphaColor];
    [self.systemInfoClickableView addSubview:infoIcon];
    [NSLayoutConstraint activateConstraints:@[
        [infoIcon.topAnchor constraintEqualToAnchor:self.systemInfoClickableView.topAnchor],
        [infoIcon.rightAnchor constraintEqualToAnchor:self.systemInfoClickableView.rightAnchor],
        [infoIcon.bottomAnchor constraintEqualToAnchor:self.systemInfoClickableView.bottomAnchor],
        [infoIcon.leftAnchor constraintEqualToAnchor:self.systemInfoClickableView.leftAnchor]
    ]];
}

- (void)setupSendButton
{
    self.sendButton = [NSButton fmp_newAutoLayout];
    self.sendButton.target = self;
    self.sendButton.action = @selector(sendButtonClicked);
    self.sendButtonDefaultTitle = FMPLocalizedString(@"Send Feedback", @"Send feedback button caption.");
    self.sendButtonSendingTitle = FMPLocalizedString(@"Sending...", @"Send feedback button caption.");
    [self.sendButton setTitle:self.sendButtonDefaultTitle];
    [self.sendButton setBezelStyle:NSBezelStyleRounded];
    [self.formContainer addSubview:self.sendButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.sendButton.topAnchor constraintEqualToAnchor:self.systemProfileCheckbox.bottomAnchor constant:15]
    ]];
    [NSLayoutConstraint activateConstraints:@[
        [self.sendButton.bottomAnchor constraintEqualToAnchor:self.formContainer.bottomAnchor constant:-1],
        [self.sendButton.rightAnchor constraintEqualToAnchor:self.formContainer.rightAnchor constant:-1]
    ]];
}

- (void)setupProgressSpinner
{
    self.progressSpinner = [NSProgressIndicator fmp_newAutoLayout];
    self.progressSpinner.style = NSProgressIndicatorStyleSpinning;
    [self.progressSpinner startAnimation:self];
    [self.progressSpinner setHidden:YES];
    [self.formContainer addSubview:self.progressSpinner];
    [NSLayoutConstraint activateConstraints:@[
        [self.progressSpinner.rightAnchor constraintEqualToAnchor:self.sendButton.leftAnchor constant:-10],
        [self.progressSpinner.centerYAnchor constraintEqualToAnchor:self.sendButton.centerYAnchor],
        [self.progressSpinner.heightAnchor constraintEqualToConstant:16],
        [self.progressSpinner.widthAnchor constraintEqualToConstant:16]
    ]];
}

- (void)setupKeyViewLoop
{
    [self.subjectButton setNextKeyView:self.nameFieldWrapper];
    [self.nameFieldWrapper setNextKeyView:self.emailFieldContainer.textControl.view];
    [self.emailFieldContainer.textControl.view setNextKeyView:self.detailsFieldContainer.textControl.view];
    [self.detailsFieldContainer.textControl.view setNextKeyView:self.systemProfileCheckbox];
    [self.systemProfileCheckbox setNextKeyView:self.sendButton];
    [self.sendButton setNextKeyView:self.subjectButton];
}

// MARK: - Update UI

- (void)updateUIWithSettings
{
    [self updateProductIconWithImage:self.settings.icon size:self.settings.iconSize];
    
    self.titleLabel.stringValue = self.settings.title ?: @"";
    self.subtitleLabel.stringValue = self.settings.subtitle ?: @"";
    
    [self.subjectButton removeAllItems];
    [self.subjectButton addItemsWithTitles:self.settings.subjectOptions ?: @[]];
    
    [self.nameFieldWrapper setControlPlaceholderString:self.settings.namePlaceholder ?: @""];
    [self.nameFieldWrapper setStringValue:self.settings.defaultName ?: @""];
    
    [self.emailFieldContainer.textControl setControlPlaceholderString:self.settings.emailPlaceholder ?: @""];
    [self.emailFieldContainer.textControl setStringValue:self.settings.defaultEmail ?: @""];
    
    self.detailsFieldContainer.textControl.controlPlaceholderString = self.settings.detailsPlaceholder ?: @"";
}

- (void)updateProductIconWithImage:(NSImage *)image size:(NSSize)size
{
    if (image)
    {
        self.iconWidthConstraint.constant = size.width;
        self.iconHeightConstraint.constant = size.height;
        
        self.iconView.image = image;
        [self.iconContainer setHidden:NO];
        [self.formContainerToSuperviewLeftConstraint setActive:NO];
        [self.formContainerToIconContainerLeftConstraint setActive:YES];
    }
    else
    {
        [self.iconContainer setHidden:YES];
        [self.formContainerToIconContainerLeftConstraint setActive:NO];
        [self.formContainerToSuperviewLeftConstraint setActive:YES];
    }
}

- (void)focusFirstEmptyField
{
    if (self.nameFieldWrapper.trimmedStringValue.length == 0)
    {
        [self.view.window makeFirstResponder:self.nameFieldWrapper.view];
    }
    else if (self.emailFieldContainer.textControl.trimmedStringValue.length == 0)
    {
        [self.view.window makeFirstResponder:self.emailFieldContainer.textControl.view];
    }
    else
    {
        [self.view.window makeFirstResponder:self.detailsFieldContainer.textControl.view];
    }
}

// MARK: - FMPClickableViewDelegate

- (void)clickableViewDidReceiveClick:(FMPClickableView *)clickableView
{
    if ([clickableView isEqualTo:self.systemInfoClickableView])
    {
        [self.systemProfileViewController showPopoverRelativeToRect:self.systemInfoClickableView.bounds
                                                             ofView:self.systemInfoClickableView];
    }
}

// MARK: - Send button action

- (void)sendButtonClicked
{
    [self.view.window makeFirstResponder:nil];
    
    if (![self checkCanSendForm])
    {
        return;
    }
    
    self.isSendingForm = YES;
    
    __weak typeof(self) weakSelf = self;
    void (^sendForm)(NSDictionary *) = ^(NSDictionary *parameters)
    {
        [weakSelf.feedbackSender sendFeedbackWithParameters:parameters completion:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) _self = weakSelf;
                if (_self.delegate)
                {
                    [_self.delegate mainViewController:_self didSendFeedbackWithError:error];
                }
                _self.isSendingForm = NO;
            });
        }];
    };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
        FMPFeedbackParameterName : self.nameFieldWrapper.trimmedStringValue,
        FMPFeedbackParameterEmail : self.emailFieldContainer.textControl.trimmedStringValue,
        FMPFeedbackParameterDetails : self.detailsFieldContainer.textControl.trimmedStringValue,
        FMPFeedbackParameterSubject : self.subjectButton.selectedItem.title,
        FMPFeedbackParameterAttachments : [self.attachmentsViewController.attachments copy]
    }];
    
    if (self.systemProfileCheckbox.state == NSControlStateValueOn)
    {
        // Write system profile to a text file and add it to parameters list
        [self.systemProfileProvider writeSystemProfileToFileWithCompletion:^(NSURL * _Nullable fileURL) {
            if (fileURL)
            {
                [parameters setObject:fileURL forKey:FMPFeedbackParameterSystemProfile];
            }
            sendForm(parameters);
        }];
    }
    else
    {
        sendForm(parameters);
    }
}

- (BOOL)checkCanSendForm
{
    [self.emailFieldContainer validate];
    [self.detailsFieldContainer validate];
    return !self.isSendingForm && self.emailFieldContainer.isValid && self.detailsFieldContainer.isValid;
}

- (void)setIsSendingForm:(BOOL)isSendingForm
{
    if (!NSThread.isMainThread)
    {
        NSLog(@"Error: isSendingForm should be updated on main thread only.");
        return;
    }
    
    _isSendingForm = isSendingForm;
    
    [self.subjectButton setEnabled:!isSendingForm];
    [self.nameFieldWrapper setEnabled:!isSendingForm];
    [self.emailFieldContainer.textControl setEnabled:!isSendingForm];
    [self.detailsFieldContainer.textControl setEnabled:!isSendingForm];
    [self.attachmentsViewController setEnabled:!isSendingForm];
    [self.systemProfileCheckbox setEnabled:!isSendingForm];
    [self.systemInfoClickableView setEnabled:!isSendingForm];
    [self.progressSpinner setHidden:!isSendingForm];
    [self.sendButton setEnabled:!isSendingForm];
    [self.sendButton setTitle:isSendingForm ? self.sendButtonSendingTitle : self.sendButtonDefaultTitle];
}

@end
