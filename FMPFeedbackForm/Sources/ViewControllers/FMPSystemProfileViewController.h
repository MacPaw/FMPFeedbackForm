//
//  FMPSystemProfileViewController.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 02.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@protocol FMPSystemProfileProvider;

NS_ASSUME_NONNULL_BEGIN

@interface FMPSystemProfileViewController : NSViewController

- (instancetype)initWithSystemProfileProvider:(id<FMPSystemProfileProvider>)systemProfileProvider;

- (void)showPopoverRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView;

@end

NS_ASSUME_NONNULL_END
