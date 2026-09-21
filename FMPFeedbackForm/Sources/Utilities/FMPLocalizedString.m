//
//  FMPLocalizedString.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw Way Ltd. All rights reserved.
//

#import "FMPLocalizedString.h"
#import "FMPBundleHelper.h"

NSString *FMPLocalizedString(NSString *key, NSString *comment)
{
    return [FMPBundleHelper.currentBundle localizedStringForKey:key value:key table:nil];
}
