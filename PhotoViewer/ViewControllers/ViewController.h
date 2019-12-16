//
//  ViewController.h
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)updateCollectionView;

@end

