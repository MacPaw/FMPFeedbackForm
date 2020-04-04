//
//  FMPTextFieldCell.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 30.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPTextFieldCell.h"

@implementation FMPTextFieldCell

- (NSRect)drawingRectForBounds:(NSRect)rect
{
    NSRect insetRect = NSMakeRect(rect.origin.x + self.edgeInsets.left,
                                  rect.origin.y + self.edgeInsets.top,
                                  rect.size.width - self.edgeInsets.left - self.edgeInsets.right,
                                  rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
    return [super drawingRectForBounds:insetRect];
}

@end
