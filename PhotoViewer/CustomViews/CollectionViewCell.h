//
//  CollectionViewCell.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

NS_ASSUME_NONNULL_END
