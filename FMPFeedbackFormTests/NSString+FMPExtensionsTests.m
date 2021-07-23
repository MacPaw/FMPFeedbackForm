//
//  NSString+FMPExtensionsTests.m
//  FMPFeedbackFormTests
//
//  Created by Serhii Butenko on 26.03.2021.
//  Copyright © 2021 MacPaw. All rights reserved.
//

@import XCTest;
@import FMPFeedbackForm;

@interface NSString_FMPExtensionsTests : XCTestCase

@end

@implementation NSString_FMPExtensionsTests

- (void)testValidEmails
{
    NSArray<NSString *> *emails = @[@"cocoa@macpaw.engineering",
                                    @"cocoa@macpaw.com",
                                    @"john..doe@gmail.com",
                                    @"john.doe@macpaw.com.ua",
                                    @"x@x.com"];
    
    for (NSString *email in emails)
    {
        XCTAssertTrue([email fmp_isValidEmail], @"%@ should be a valid email", email);
    }
}

- (void)testInvalidEmails
{
    NSArray<NSString *> *emails = @[@"@outlook.com",
                                    @"john doe@gmail.com",
                                    @"just a word",
                                    @"john.doe@.gmail.com",
                                    @"стус@поети.укр"];
    
    for (NSString *email in emails)
    {
        XCTAssertFalse([email fmp_isValidEmail], @"%@ should be an invalid email", email);
    }
}

@end
