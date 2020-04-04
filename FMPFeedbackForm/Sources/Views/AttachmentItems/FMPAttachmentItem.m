//
//  FMPAttachmentItem.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPAttachmentItem.h"
#import "NSView+FMPExtensions.h"
#import "NSColor+FMPExtensions.h"
#import "NSTextField+FMPExtensions.h"
#import "FMPBorderedView.h"
#import "FMPClickableView.h"
#import "FMPMaskedImageView.h"
#import "NSImage+FMPExtensions.h"

static CGFloat itemHeight = 20.0;
static CGFloat innerHorizontalSpacing = 6.0;
static CGFloat fileNameToRemoveIconSpacing = 4.0;
static CGFloat removeIconWidth = 10.0;
static CGFloat removeIconHeight = 10.0;

@interface FMPAttachmentItem () <FMPClickableViewDelegate>
@property (nonatomic, strong) FMPBorderedView *containerView;
@property (nonatomic, strong) NSTextField *fileNameLabel;
@property (nonatomic, strong) FMPClickableView *clickableView;
@end

@implementation FMPAttachmentItem

- (void)loadView
{
    self.view = [NSView fmp_newAutoLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    [self setupContainerView];
    [self setupFileNameLabel];
    [self setupRemoveButton];
}

- (void)setupContainerView
{
    self.containerView = [FMPBorderedView fmp_newAutoLayout];
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.layer.borderWidth = 1.0;
    self.containerView.borderColor = [NSColor fmp_dynamicInverted50AlphaColor];
    [self.view addSubview:self.containerView];
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.containerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.containerView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
        [self.containerView.heightAnchor constraintEqualToConstant:itemHeight]
    ]];
}

- (void)setupFileNameLabel
{
    self.fileNameLabel = [NSTextField fmp_label];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileNameLabel.font = [NSFont systemFontOfSize:12];
    self.fileNameLabel.cell.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.containerView addSubview:self.fileNameLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.fileNameLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:innerHorizontalSpacing],
        [self.fileNameLabel.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor constant:-1]
    ]];
}

- (void)setupRemoveButton
{
    self.clickableView = [FMPClickableView fmp_newAutoLayout];
    self.clickableView.delegate = self;
    [self.containerView addSubview:self.clickableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.clickableView.leftAnchor constraintEqualToAnchor:self.fileNameLabel.rightAnchor constant:fileNameToRemoveIconSpacing],
        [self.clickableView.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-innerHorizontalSpacing],
        [self.clickableView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
        [self.clickableView.widthAnchor constraintEqualToConstant:removeIconWidth],
        [self.clickableView.heightAnchor constraintEqualToConstant:removeIconHeight]
    ]];
    
    FMPMaskedImageView *removeIconView = [FMPMaskedImageView fmp_newAutoLayout];
    removeIconView.imageMask = [NSImage fmp_imageNamed:@"removeIcon"];
    removeIconView.maskColor = [NSColor fmp_dynamicInverted50AlphaColor];
    [self.clickableView addSubview:removeIconView];
    [NSLayoutConstraint activateConstraints:@[
        [removeIconView.topAnchor constraintEqualToAnchor:self.clickableView.topAnchor],
        [removeIconView.rightAnchor constraintEqualToAnchor:self.clickableView.rightAnchor],
        [removeIconView.bottomAnchor constraintEqualToAnchor:self.clickableView.bottomAnchor],
        [removeIconView.leftAnchor constraintEqualToAnchor:self.clickableView.leftAnchor]
    ]];
}

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = fileURL;
    self.fileNameLabel.stringValue = fileURL.lastPathComponent;
}

- (BOOL)isEnabled
{
    return self.clickableView.isEnabled;
}

- (void)setEnabled:(BOOL)isEnabled
{
    self.clickableView.isEnabled = isEnabled;
    self.view.alphaValue = isEnabled ? 1.0 : 0.5;
}

// MARK: - FMPClickableViewDelegate

- (void)clickableViewDidReceiveClick:(FMPClickableView *)clickableView
{
    [self.delegate attachmentItemDidGetRemoved:self];
}

@end
