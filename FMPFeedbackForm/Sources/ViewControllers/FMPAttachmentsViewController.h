//
//  FMPAttachmentsViewController.h
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 22.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

@import Cocoa;
@protocol FMPFileSelectionManager;

NS_ASSUME_NONNULL_BEGIN

@interface FMPAttachmentsViewController : NSViewController

- (instancetype)initWithFileSelectionManager:(id<FMPFileSelectionManager>)fileSelectionManager;

@property (nonatomic, strong, readonly) NSMutableArray<NSURL *> *attachments;
@property (nonatomic, strong, nullable) NSNumber *maxAttachmentsCount;
@property (nonatomic, strong, nullable) NSNumber *maxAttachmentFileSize;
@property (nonatomic, assign, setter=setEnabled:) BOOL isEnabled;

@end

NS_ASSUME_NONNULL_END
