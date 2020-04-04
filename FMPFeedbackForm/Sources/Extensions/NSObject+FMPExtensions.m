//
//  NSObject+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSObject+FMPExtensions.h"

@implementation NSObject (FMPExtensions)

+ (instancetype)fmp_dynamicCastObject:(id)object
{
    return [object isKindOfClass:self] ? object : nil;
}

@end
