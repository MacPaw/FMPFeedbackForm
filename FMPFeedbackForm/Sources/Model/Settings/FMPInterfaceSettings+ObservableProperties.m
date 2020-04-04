//
//  FMPInterfaceSettings+ObservableProperties.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPInterfaceSettings+ObservableProperties.h"

@implementation FMPInterfaceSettings (ObservableProperties)

+ (NSSet<NSString *> *)observableProperties
{
    return [NSSet setWithObjects:@"icon",
            @"iconSize",
            @"title",
            @"subtitle",
            @"subjectOptions",
            @"namePlaceholder",
            @"emailPlaceholder",
            @"detailsPlaceholder",
            @"defaultName",
            @"defaultEmail",
            nil];
}

@end
