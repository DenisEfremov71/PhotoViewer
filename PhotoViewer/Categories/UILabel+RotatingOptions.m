//
//  UILabel+RotatingOptions.m
//  PhotoViewer
//
//  Created by Denis Efremov on 2019-12-14.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

#import "UILabel+RotatingOptions.h"

@implementation UILabel (RotatingOptions)

- (void)rotateAt:(short)angle {
    self.transform = CGAffineTransformMakeRotation( ( angle * M_PI ) / 180 );
}

@end
