//
//  UICollectionViewCell+DecoratingOptions.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-14.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (DecoratingOptions)

- (void)roundCornersOf:(float)radius;
- (void)setBorderTo:(float)width;
- (void)setShadowTo:(CGColorRef)color withOffset:(CGSize)offset radius:(float)radius andOpacity:(float)opacity;

@end

NS_ASSUME_NONNULL_END
