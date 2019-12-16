//
//  AppDelegate.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "Photo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSCache<NSString*,ImageCache*> *cachedImages;
@property NSMutableArray<Photo *> *photos;

@end

