//
//  NSError+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 16.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSError+FMPExtensions.h"

static NSString *const FMPDefaultErrorDomain = @"com.macpaw.FMPFeedbackForm.default-error-domain";

@implementation NSError (FMPExtensions)

+ (instancetype)fmp_errorWithCode:(NSInteger)code description:(NSString *)description
{
    return [NSError errorWithDomain:FMPDefaultErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

@end
