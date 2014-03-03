//
//  AppDelegate.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property(nonatomic,retain)NSData *productData;
@property(nonatomic,retain)NSArray *colorsArray;
@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;

@end
