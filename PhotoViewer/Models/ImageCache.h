//
//  ImageCache.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-14.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject <NSDiscardableContent>

@property UIImage *image;

- (BOOL)beginContentAccess;
- (void)endContentAccess;
- (void)discardContentIfPossible;
- (BOOL)isContentDiscarded;

@end

NS_ASSUME_NONNULL_END
