//
//  FlowLayoutWithAnimations.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-15.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "FlowLayoutWithAnimations.h"

@interface FlowLayoutWithAnimations ()

@property (nonatomic) CGSize previousSize;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end

@implementation FlowLayoutWithAnimations

- (void)commonInit
{
    self.itemSize = CGSizeMake(100, 100);
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    //NSLog(@"%@ initial attr for %@", self, itemIndexPath);
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    //NSLog(@"%@ final attr for %@", self, itemIndexPath);
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        
        CATransform3D flyUpTransform = CATransform3DIdentity;
        flyUpTransform.m34 = 1.0 / -20000;
        flyUpTransform = CATransform3DTranslate(flyUpTransform, 0, 0, 19500);
        attr.transform3D = flyUpTransform;
        attr.center = self.collectionView.center;
        
        attr.alpha = 0.2;
        attr.zIndex = 1;
        
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    else{
        attr.alpha = 1.0;
    }
    
    //NSLog(@"final %@", attr);
    return attr;
}

- (void)prepareLayout
{
    //NSLog(@"%@ preparing layout", self);
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.previousSize = self.collectionView.bounds.size;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    //NSLog(@"%@ prepare for updated", self);
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    
    self.indexPathsToAnimate = indexPaths;
}

- (void)finalizeCollectionViewUpdates
{
    //NSLog(@"%@ finalize updates", self);
    [super finalizeCollectionViewUpdates];
    self.indexPathsToAnimate = nil;
}

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
    //NSLog(@"%@ prepare animated bounds change", self);
    [super prepareForAnimatedBoundsChange:oldBounds];
}

- (void)finalizeAnimatedBoundsChange {
    //NSLog(@"%@ finalize animated bounds change", self);
    [super finalizeAnimatedBoundsChange];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        //NSLog(@"%@ should invalidate layout", self);
        return YES;
        
    }
    return NO;
}

@end
