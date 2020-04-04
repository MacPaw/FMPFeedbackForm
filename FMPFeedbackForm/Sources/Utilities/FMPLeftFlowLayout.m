//
//  FMPLeftFlowLayout.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 11.02.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPLeftFlowLayout.h"

@interface FMPLeftFlowLayout ()
@property (nonatomic, assign) NSSize cachedCollectionViewContentSize;
@end

@implementation FMPLeftFlowLayout

- (NSSize)collectionViewContentSize
{
    return self.cachedCollectionViewContentSize;
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    self.cachedCollectionViewContentSize = [self calculateCollectionViewContentSize];
}

- (NSSize)calculateCollectionViewContentSize
{
    NSSize size = [super collectionViewContentSize];
    NSRect rect = NSMakeRect(0, 0, size.width, CGFLOAT_MAX);
    NSArray<NSCollectionViewLayoutAttributes *> *attributes = [self layoutAttributesForElementsInRect:rect];
    
    NSRect resultRect = NSZeroRect;
    for (NSCollectionViewLayoutAttributes *attr in attributes)
    {
        resultRect = NSUnionRect(resultRect, attr.frame);
    }
    return resultRect.size;
}

- (NSArray<NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect
{
    // Minor hack to correctly layout all the elements via super
    rect = NSMakeRect(0, 0, rect.size.width, CGFLOAT_MAX);
    
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allAttributes = [NSMutableArray new];
    for (NSCollectionViewLayoutAttributes* attributes in originalAttributes) {
        [allAttributes addObject:[attributes copy]];
    }
    
    if (allAttributes.count == 0)
    {
        return allAttributes;
    }
    
    CGFloat xCursor = self.sectionInset.left;
    CGFloat yCursor = self.sectionInset.top;
    NSCollectionViewLayoutAttributes *previousAttributes = nil;
    
    for (NSCollectionViewLayoutAttributes *attributes in allAttributes)
    {
        // Check if item fits on the current line
        if (xCursor + attributes.size.width > rect.size.width)
        {
            // Move cursor to new line
            xCursor = self.sectionInset.left;
            yCursor += previousAttributes.size.height + self.minimumLineSpacing;
        }
        
        // Set item position
        CGRect frame = attributes.frame;
        frame.origin = CGPointMake(xCursor, yCursor);
        attributes.frame = frame;
        
        xCursor += attributes.size.width + self.minimumInteritemSpacing;
        previousAttributes = attributes;
    }
    
    return allAttributes;
}

@end
