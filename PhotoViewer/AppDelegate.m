//
//  AppDelegate.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-13.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.cachedImages = [[NSCache alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    [self.cachedImages setName:@"photoCache"];
    [self fetchPhotos];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// MARK: - Methods

- (void)fetchPhotos {
    NSLog(@"Fetching all photos from JSONPlaceholder...");
    
    NSString *urlString = @"https://jsonplaceholder.typicode.com/photos";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        NSArray *photosJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        // Assumption: error handling doesn't need to be implemented for this assignment
        if (err) {
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        for (NSDictionary *photoDict in photosJSON) {
            NSNumber *photoId = photoDict[@"id"];
            NSNumber *albumId = photoDict[@"albumId"];
            Photo *photo = Photo.new;
            photo.photoId = [photoId integerValue];
            photo.albumId = [albumId integerValue];
            photo.title = photoDict[@"title"];
            photo.thumbnailUrl = photoDict[@"thumbnailUrl"];
            photo.url = photoDict[@"url"];
            [self.photos addObject:photo];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ViewController* mainController = (ViewController*) self.window.rootViewController;
            [mainController updateCollectionView];
        });
        
    }] resume];
}

@end
