//
//  FMPSystemProfileViewController.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 02.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPSystemProfileViewController.h"
#import "FMPSystemProfileProvider.h"
#import "NSView+FMPExtensions.h"
#import "FMPLocalizedString.h"
#import "FMPTextViewScroller.h"
#import "FMPTextView.h"
#import "FMPTransparentSpinner.h"
#import "NSColor+FMPExtensions.h"

typedef NS_ENUM(NSUInteger, FMPSystemProfileTab)
{
    FMPSystemProfileTabSystem         = 0,
    FMPSystemProfileTabLog            = 1,
    FMPSystemProfileTabAppPreferences = 2
};

@interface FMPSystemProfileViewController ()

@property (nonatomic, strong) id<FMPSystemProfileProvider> systemProfileProvider;

@property (nonatomic, strong) NSSegmentedControl *tabsControl;
@property (nonatomic, strong) FMPTextView *textView;
@property (nonatomic, strong) FMPTransparentSpinner *spinner;
@property (nonatomic, strong) NSPopover *popover;

@end

@implementation FMPSystemProfileViewController

- (instancetype)initWithSystemProfileProvider:(id<FMPSystemProfileProvider>)systemProfileProvider
{
    self = [super init];
    if (self)
    {
        [self setupWithSystemProfileProvider:systemProfileProvider];
    }
    return self;
}

- (void)setupWithSystemProfileProvider:(id<FMPSystemProfileProvider>)systemProfileProvider
{
    self.systemProfileProvider = systemProfileProvider;
    [self setupTabsControl];
    [self setupTextView];
    [self setupSpinner];
}

- (void)loadView
{
    self.view = [NSView fmp_newAutoLayout];
}

- (void)viewDidAppear
{
    [super viewWillAppear];
    [self updateUIForCurrentTab];
}

// MARK: - Setup UI

- (void)setupTabsControl
{
    self.tabsControl = [NSSegmentedControl fmp_newAutoLayout];
    
    self.tabsControl.segmentCount = 3;
    [self.tabsControl setLabel:FMPLocalizedString(@"System", @"Tab title in system profile pop-up")
                    forSegment:FMPSystemProfileTabSystem];
    [self.tabsControl setLabel:FMPLocalizedString(@"Console", @"Tab title in system profile pop-up")
                    forSegment:FMPSystemProfileTabLog];
    [self.tabsControl setLabel:FMPLocalizedString(@"Preferences", @"Tab title in system profile pop-up")
                    forSegment:FMPSystemProfileTabAppPreferences];
    [self.tabsControl setSelectedSegment:FMPSystemProfileTabSystem];
    
    self.tabsControl.font = [NSFont systemFontOfSize:11];
    self.tabsControl.controlSize = NSControlSizeSmall;
    if (@available(macOS 10.13, *))
    {
        self.tabsControl.segmentDistribution = NSSegmentDistributionFillEqually;
    }
    
    self.tabsControl.target = self;
    self.tabsControl.action = @selector(updateUIForCurrentTab);
    
    [self.view addSubview:self.tabsControl];
    [NSLayoutConstraint activateConstraints:@[
        [self.tabsControl.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        [self.tabsControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)setupTextView
{
    self.textView = [FMPTextView new];
    self.textView.editable = NO;
    self.textView.font = [NSFont systemFontOfSize:12];
    
    FMPTextViewScroller *scroller = [[FMPTextViewScroller alloc] initWithTextView:self.textView];
    scroller.cornerRadius = 2;
    
    [self.view addSubview:scroller];
    [NSLayoutConstraint activateConstraints:@[
        [scroller.topAnchor constraintEqualToAnchor:self.tabsControl.bottomAnchor constant:15],
        [scroller.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20],
        [scroller.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20],
        [scroller.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20],
        [scroller.widthAnchor constraintEqualToConstant:545],
        [scroller.heightAnchor constraintEqualToConstant:255]
    ]];
}

- (void)setupSpinner
{
    self.spinner = [FMPTransparentSpinner fmp_newAutoLayout];
    [self.view addSubview:self.spinner];
    [NSLayoutConstraint activateConstraints:@[
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.textView.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.textView.centerYAnchor]
    ]];
    [self.spinner startAnimation:self];
}

// MARK: - Popover

- (NSPopover *)popover
{
    static NSPopover *popover = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popover = [NSPopover new];
        popover.contentViewController = self;
        [popover setBehavior:NSPopoverBehaviorSemitransient];
    });
    return popover;
}

- (void)showPopoverRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView
{
    if (!self.popover.shown)
    {
        [self.popover showRelativeToRect:positioningRect ofView:positioningView preferredEdge:NSMaxYEdge];
    }
    else
    {
        [self.popover close];
    }
}

// MARK: - Update UI

- (void)updateUIForCurrentTab
{
    __weak typeof(self) weakSelf = self;
    [self.systemProfileProvider gatherSystemProfileDataWithCompletion:^(NSString * _Nullable systemInfo,
                                                                        NSString * _Nullable log,
                                                                        NSString * _Nullable appPreferences) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) _self = weakSelf;
            NSString *info = nil;
            switch (_self.tabsControl.selectedSegment)
            {
                case FMPSystemProfileTabSystem:
                    info = systemInfo;
                    break;
                case FMPSystemProfileTabLog:
                    info = log;
                    break;
                case FMPSystemProfileTabAppPreferences:
                    info = appPreferences;
                    break;
            }
            
            BOOL tabHasInfo = info.length > 0;
            [_self.textView setString:tabHasInfo ? info : @""];
            [_self.spinner setHidden:tabHasInfo];
        });
    }];
    
    
}

@end
