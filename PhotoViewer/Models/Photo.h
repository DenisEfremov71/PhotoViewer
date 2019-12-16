//
//  Photo.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject

@property long albumId;
@property long photoId;
@property NSString *title;
@property NSString *url;
@property NSString *thumbnailUrl;

@end

NS_ASSUME_NONNULL_END
