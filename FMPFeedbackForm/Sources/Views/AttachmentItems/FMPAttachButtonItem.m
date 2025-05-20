//
//  FMPAttachButtonItem.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 10.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPAttachButtonItem.h"
#import "NSView+FMPExtensions.h"
#import "NSImage+FMPExtensions.h"
#import "NSColor+FMPExtensions.h"
#import "NSTextField+FMPExtensions.h"
#import "FMPLocalizedString.h"
#import "FMPMaskedImageView.h"
#import "FMPClickableView.h"

static CGFloat iconWidth = 16.0;
static CGFloat iconHeight = 16.0;
static CGFloat iconToCaptionSpacing = 2.0;

@interface FMPAttachButtonItem () <FMPClickableViewDelegate>
@property (nonatomic, strong) FMPClickableView *clickableView;
@property (nonatomic, strong) FMPMaskedImageView *attachImage;
@property (nonatomic, strong) NSTextField *caption;
@end

@implementation FMPAttachButtonItem

- (void)loadView
{
    self.clickableView = [FMPClickableView fmp_newAutoLayout];
    self.clickableView.delegate = self;
    self.view = self.clickableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.attachImage = [FMPMaskedImageView fmp_newAutoLayout];
    self.attachImage.imageMask = [NSImage fmp_imageNamed:@"attachIcon"];
    [self.view addSubview:self.attachImage];
    [NSLayoutConstraint activateConstraints:@[
        [self.attachImage.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [self.attachImage.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:2.0],
        [self.attachImage.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-3.0],
        [self.attachImage.widthAnchor constraintEqualToConstant:iconWidth],
        [self.attachImage.heightAnchor constraintEqualToConstant:iconHeight]
    ]];
    
    self.caption = [NSTextField fmp_labelWithString:FMPLocalizedString(@"Attach File...", @"Attach file button caption.")];
    self.caption.translatesAutoresizingMaskIntoConstraints = NO;
    self.caption.font = [NSFont systemFontOfSize:12];
    [self.view addSubview:self.caption];
    [NSLayoutConstraint activateConstraints:@[
        [self.caption.leftAnchor constraintEqualToAnchor:self.attachImage.rightAnchor constant:iconToCaptionSpacing],
        [self.caption.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
        [self.caption.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    self.attachImage.maskColor = NSColor.controlAccentColor;
    self.caption.textColor = NSColor.controlAccentColor;
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

// MARK: - FMPClickableViewDeleagate

- (void)clickableViewDidReceiveClick:(FMPClickableView *)clickableView
{
    [self.delegate attachButtonItemDidReceiveClick:self];
}

@end
