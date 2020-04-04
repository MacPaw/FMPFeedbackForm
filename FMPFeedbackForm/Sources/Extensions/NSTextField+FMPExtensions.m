//
//  NSTextField+FMPExtensions.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 29.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "NSTextField+FMPExtensions.h"
#import "FMPTextFieldCell.h"

@implementation NSTextField (FMPExtensions)

+ (instancetype)fmp_label
{
    NSTextField *label = [self new];
    label.cell = [FMPTextFieldCell new];
    label.bezeled = NO;
    label.bordered = NO;
    label.editable = NO;
    label.selectable = NO;
    label.backgroundColor = [NSColor clearColor];
    return label;
}

+ (instancetype)fmp_multilineLabel
{
    NSTextField *label = [self fmp_label];
    label.usesSingleLineMode = NO;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.cell.wraps = YES;
    label.cell.scrollable = NO;
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow
                                    forOrientation:NSLayoutConstraintOrientationHorizontal];
    return label;
}

+ (instancetype)fmp_labelWithString:(NSString *)string
{
    NSTextField *label = [self fmp_label];
    label.stringValue = string;
    return label;
}

+ (instancetype)fmp_multilineLabelWithString:(NSString *)string
{
    NSTextField *label = [self fmp_multilineLabel];
    label.stringValue = string;
    return label;
}

@end
