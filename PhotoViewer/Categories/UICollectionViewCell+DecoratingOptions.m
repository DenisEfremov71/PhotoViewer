//
//  UICollectionViewCell+DecoratingOptions.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-14.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "UICollectionViewCell+DecoratingOptions.h"

@implementation UICollectionViewCell (DecoratingOptions)

- (void)roundCornersOf:(float)radius {
    self.contentView.layer.cornerRadius = radius;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setBorderTo:(float)width {
    self.contentView.layer.borderWidth = width;
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)setShadowTo:(CGColorRef)color withOffset:(CGSize)offset radius:(float)radius andOpacity:(float)opacity {
    self.layer.shadowColor = color;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

@end
