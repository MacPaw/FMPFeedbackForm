//
//  FMPAttachmentsViewController.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 22.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPAttachmentsViewController.h"
#import "FMPAttachButtonItem.h"
#import "FMPAttachmentItem.h"
#import "NSView+FMPExtensions.h"
#import "FMPLeftFlowLayout.h"
#import "FMPAttachmentsCollectionView.h"
#import "FMPFileSelectionManager.h"

static NSString *const kAttachmentItemID = @"attachmentItem";
static NSString *const kAttachButtonItemID = @"attachButtonItem";

@interface FMPAttachmentsViewController () <NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout, FMPAttachButtonItemDelegate, FMPAttachmentItemDelegate>
@property (nonatomic, strong) id<FMPFileSelectionManager> fileSelectionManager;
@property (nonatomic, strong) NSMutableArray<NSURL *> *attachments;
@property (nonatomic, strong) FMPAttachmentsCollectionView *collectionView;
@property (nonatomic, strong) FMPAttachmentItem *helperAttachmentItem;
@property (nonatomic, strong) FMPAttachButtonItem *helperAttachButtonItem;
@end

@implementation FMPAttachmentsViewController

- (instancetype)initWithFileSelectionManager:(id<FMPFileSelectionManager>)fileSelectionManager
{
    self = [super init];
    if (self)
    {
        self.fileSelectionManager = fileSelectionManager;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.attachments = [NSMutableArray new];
    self.isEnabled = YES;
    [self setupCollectionView];
    [self setupHelperItems];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    // TODO: Fix this for OSX 10.11.
    // This is somewhat of a hack. On start the collection view outputs nothing, this fixes it on OSX 10.12 and 10.13,
    // but on 10.11 the collection view is still empty. Figure out the source of the problem and lower the min version.
    [self.collectionView reloadData];
}

- (void)loadView
{
    self.view = [NSView fmp_newAutoLayout];
}

- (void)setupCollectionView
{
    FMPLeftFlowLayout *layout = [FMPLeftFlowLayout new];
    layout.minimumLineSpacing = 4.0;
    layout.minimumInteritemSpacing = 6.0;
    
    self.collectionView = [FMPAttachmentsCollectionView fmp_newAutoLayout];
    self.collectionView.backgroundColors = @[NSColor.clearColor];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:FMPAttachmentItem.class forItemWithIdentifier:kAttachmentItemID];
    [self.collectionView registerClass:FMPAttachButtonItem.class forItemWithIdentifier:kAttachButtonItemID];
    
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [self.collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.collectionView.heightAnchor constraintGreaterThanOrEqualToConstant:20]
    ]];
}

- (void)setupHelperItems
{
    self.helperAttachmentItem = [FMPAttachmentItem new];
    (void)self.helperAttachmentItem.view;
    self.helperAttachButtonItem = [FMPAttachButtonItem new];
    (void)self.helperAttachButtonItem.view;
}

- (void)setEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    [self.collectionView reloadData];
}

- (BOOL)isAttachmentsLimitReached
{
    if (self.maxAttachmentsCount.unsignedIntegerValue == 0)
    {
        return NO;
    }
    
    return self.attachments.count >= self.maxAttachmentsCount.unsignedIntegerValue;
}

// MARK: - NSCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView
{
    // 1st section for attachments list, 2nd section for attach button
    return self.isAttachmentsLimitReached ? 1 : 2;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? self.attachments.count : 1;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FMPAttachmentItem *item = [collectionView makeItemWithIdentifier:kAttachmentItemID forIndexPath:indexPath];
        item.delegate = self;
        item.fileURL = self.attachments[indexPath.item];
        item.isEnabled = self.isEnabled;
        return item;
    }
    else
    {
        FMPAttachButtonItem *item = [collectionView makeItemWithIdentifier:kAttachButtonItemID forIndexPath:indexPath];
        item.delegate = self;
        item.isEnabled = self.isEnabled;
        return item;
    }
}

// MARK: - NSCollectionViewDelegate

- (NSSize)collectionView:(NSCollectionView *)collectionView
                  layout:(NSCollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.helperAttachmentItem.fileURL = self.attachments[indexPath.item];
        NSSize fittingSize = self.helperAttachmentItem.view.fittingSize;
        NSSize viewSize = self.view.frame.size;
        return NSMakeSize(MIN(viewSize.width, fittingSize.width), fittingSize.height);
    }
    else
    {
        return self.helperAttachButtonItem.view.fittingSize;
    }
}

// MARK: - FMPAttachButtonItemDelegate

- (void)attachButtonItemDidReceiveClick:(FMPAttachButtonItem *)attachButtonItem
{
    [self.fileSelectionManager selectFilesWithCallback:^(NSArray<NSURL *> * _Nonnull fileURLs) {
        NSFileManager *fileManager = NSFileManager.defaultManager;
        NSUInteger maxAllowedBytes = self.maxAttachmentFileSize.unsignedIntegerValue == 0 ? NSUIntegerMax : self.maxAttachmentFileSize.unsignedIntegerValue * 1024 * 1024;
        for (NSURL *fileURL in fileURLs)
        {
            if (self.isAttachmentsLimitReached)
            {
                break;
            }
            
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:fileURL.path error:nil];
            if (attributes.fileType != NSFileTypeRegular || attributes.fileSize >= maxAllowedBytes)
            {
                continue;
            }
            
            if (![self.attachments containsObject:fileURL])
            {
                [self.attachments addObject:fileURL];
            }
        }
        [self.collectionView reloadData];
    }];
}

// MARK: - FMPAttachmentItemDelegate

- (void)attachmentItemDidGetRemoved:(FMPAttachmentItem *)attachmentItem
{
    [self.attachments removeObject:attachmentItem.fileURL];
    [self.collectionView reloadData];
}

@end
