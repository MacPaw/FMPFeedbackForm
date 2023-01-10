//
//  FMPInterfaceSettings.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPInterfaceSettings.h"
#import "FMPLocalizedString.h"

@implementation FMPInterfaceSettings

+ (FMPInterfaceSettings *)defaultSettings
{
    FMPInterfaceSettings *settings = [FMPInterfaceSettings new];
    
    settings.iconSize = NSMakeSize(64.0, 64.0);
    settings.title = FMPLocalizedString(@"Provide Feedback", @"Feedback form title.");
    settings.subtitle = FMPLocalizedString(@"Please provide a detailed description of your problem, suggestion, bug-report or question so that we have a clear picture of your request and react to it with maximum effectiveness.", @"Feedback form description.");
    settings.subjectOptions = @[FMPLocalizedString(@"Feedback", @"Feedback subject option."),
                                FMPLocalizedString(@"Support Request", @"Feedback subject option."),
                                FMPLocalizedString(@"Bug Report", @"Feedback subject option.")];
    settings.namePlaceholder = FMPLocalizedString(@"John Appleseed", @"Customer name field placeholder. Any generic name and surname specific to the language, nothing too funny though.");
    settings.emailPlaceholder = @"someone@somewhere.com";
    settings.detailsPlaceholder = FMPLocalizedString(@"Write your message here...", @"Feedback details field placeholder.");
    settings.windowTitle = @"";
    return settings;
}

@end
