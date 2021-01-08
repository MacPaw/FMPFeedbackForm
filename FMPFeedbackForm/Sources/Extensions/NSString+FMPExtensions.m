//
//  NSString+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 17.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSString+FMPExtensions.h"

@implementation NSString (FMPExtensions)

- (BOOL)fmp_isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
