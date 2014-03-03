//
//  MainViewController.h
//  MacysAssignment1
//
//  Created by Sachith Rao on 18/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDisplayViewController.h"

@interface MainViewController : UIViewController<UISearchBarDelegate> {
    
    UINavigationController *navController;
    CountDisplayViewController *countDisplayViewController;
    NSInteger tapCount;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScroll;

- (IBAction)buttonAction:(id)sender;
@end
