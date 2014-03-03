//
//  ProductPhotoImageView.m
//  Macys
//
//  Created by Sachith Rao on 13/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "ProductPhotoImageView.h"

@implementation ProductPhotoImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [delegate didTouchedPhotoImage];
}

@end
