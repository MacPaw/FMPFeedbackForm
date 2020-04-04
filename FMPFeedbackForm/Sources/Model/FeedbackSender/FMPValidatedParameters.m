//
//  FMPValidatedParameters.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 19.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPValidatedParameters.h"

@interface FMPValidatedParameters ()
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *details;
@end

@implementation FMPValidatedParameters

- (instancetype)initWithEmail:(NSString *)email
                      subject:(NSString *)subject
                      details:(NSString *)details
{
    self = [super init];
    if (self)
    {
        self.email = email;
        self.subject = subject;
        self.details = details;
    }
    return self;
}

@end
