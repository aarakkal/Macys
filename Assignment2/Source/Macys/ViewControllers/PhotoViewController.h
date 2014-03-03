//
//  PhotoViewController.h
//  Macys
//
//  Created by Sachith Rao on 13/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (nonatomic,retain)UIImage *photo;

@end
