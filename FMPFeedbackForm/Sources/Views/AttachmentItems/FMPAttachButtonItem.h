//
//  FMPAttachButtonItem.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 10.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@class FMPAttachButtonItem;

@protocol FMPAttachButtonItemDelegate <NSObject>
- (void)attachButtonItemDidReceiveClick:(FMPAttachButtonItem *)attachButtonItem;
@end

@interface FMPAttachButtonItem : NSCollectionViewItem
@property (nonatomic, weak) id<FMPAttachButtonItemDelegate> delegate;
@property (nonatomic, assign, setter=setEnabled:) BOOL isEnabled;
@end

NS_ASSUME_NONNULL_END
