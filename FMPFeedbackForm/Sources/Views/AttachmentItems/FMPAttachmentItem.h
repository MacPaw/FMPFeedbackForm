//
//  FMPAttachmentItem.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@class FMPAttachmentItem;

@protocol FMPAttachmentItemDelegate <NSObject>
- (void)attachmentItemDidGetRemoved:(FMPAttachmentItem *)attachmentItem;
@end

@interface FMPAttachmentItem : NSCollectionViewItem
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, weak) id<FMPAttachmentItemDelegate> delegate;
@property (nonatomic, assign, setter=setEnabled:) BOOL isEnabled;
@end

NS_ASSUME_NONNULL_END
