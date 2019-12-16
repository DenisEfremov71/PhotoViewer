//
//  ViewController.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "UILabel+RotatingOptions.h"
#import "UICollectionViewCell+DecoratingOptions.h"

@interface ViewController ()

@property AppDelegate *appDelegate;

@end

@implementation ViewController

// MARK: - ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

// MARK: - Methods

- (void)updateCollectionView {
    [self.collectionView reloadData];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES, image);
        } else {
            completionBlock(NO, nil);
        }
        
    }] resume];
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_appDelegate.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [[CollectionViewCell alloc] init];
    cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    Photo *photo = [_appDelegate.photos objectAtIndex:indexPath.row];
    cell.title.text = photo.title;
    [cell.title rotateAt:-45];
    [cell roundCornersOf:10.0f];
    [cell setBorderTo:5.0f];
    [cell setShadowTo:[UIColor lightGrayColor].CGColor withOffset:CGSizeMake(3.0f, 3.0f) radius:3.0f andOpacity:1.0f];
    
    NSString* key = photo.thumbnailUrl;
    
    // check if the image is in the cache first, if not - download it
    if ([self.appDelegate.cachedImages objectForKey:key] != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photo.image = [[self.appDelegate.cachedImages objectForKey:key] image];
        });
    } else {
        [self downloadImageWithURL:[NSURL URLWithString:photo.thumbnailUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.photo.image = image;
                });
                ImageCache *cachedImage = [[ImageCache alloc] init];
                cachedImage.image = image;
                [self.appDelegate.cachedImages setObject:cachedImage forKey:key];
                NSLog(@"Finished loading image: %@", key);
            }
        }];
    }
    
    return cell;
}

// MARK: - IBActions

- (IBAction)removeEntries:(id)sender {
    unsigned long index;
    NSString* key = @"";
    NSMutableIndexSet *indicesForPhotosToRemove = [NSMutableIndexSet new];
    NSMutableArray<NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
    
    for (Photo *photo in self.appDelegate.photos) {
        if ([[photo.title lowercaseString] containsString:@"b"] || [[photo.title lowercaseString] containsString:@"d"]) {
            index = [self.appDelegate.photos indexOfObject:photo];
            [indicesForPhotosToRemove addIndex:index];
            key = photo.thumbnailUrl;
            if ([self.appDelegate.cachedImages objectForKey:key] != nil) {
                [self.appDelegate.cachedImages removeObjectForKey:key];
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [indexPaths addObject:indexPath];
        }
    }
    
    [self.appDelegate.photos removeObjectsAtIndexes:indicesForPhotosToRemove];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

- (IBAction)reorderPhotos:(id)sender {
    
    NSMutableArray<NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self.appDelegate.photos count]];
    for (Photo *photo in self.appDelegate.photos)
    {
        NSUInteger randomPos = arc4random()%([tmpArray count]+1);
        [tmpArray insertObject:photo atIndex:randomPos];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < self.appDelegate.photos.count; i++) {
            NSInteger j = [tmpArray indexOfObject:self.appDelegate.photos[i]];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:j inSection:0];
            [indexPaths addObject:toIndexPath];
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            self.appDelegate.photos = tmpArray;
            [self.collectionView reloadData];
        }];
    });
    
}

@end
