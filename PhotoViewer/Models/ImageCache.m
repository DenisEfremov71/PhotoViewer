//
//  ImageCache.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-14.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

- (BOOL)beginContentAccess {
    return true;
}

- (void)endContentAccess {
}

- (void)discardContentIfPossible {
}

- (BOOL)isContentDiscarded {
    return false;
}

@end
