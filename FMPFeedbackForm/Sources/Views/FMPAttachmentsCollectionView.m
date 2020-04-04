//
//  FMPAttachmentsCollectionView.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 12.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPAttachmentsCollectionView.h"

@implementation FMPAttachmentsCollectionView

- (NSSize)intrinsicContentSize
{
    return self.collectionViewLayout.collectionViewContentSize;
}

- (void)reloadData
{
    [super reloadData];
    [self invalidateIntrinsicContentSize];
}

@end
