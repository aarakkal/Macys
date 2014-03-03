//
//  MainViewController.m
//  MacysAssignment1
//
//  Created by Sachith Rao on 18/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "MainViewController.h"

#define SHOP_TAG 101
#define REGISTRY_TAG 102
#define STORES_TAG 103
#define BAG_TAG 104
#define OFFERS_TAG 105
#define ACCOUNT_TAG 106

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *navBarImage = [UIImage imageNamed:@"header.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.pageScroll addGestureRecognizer:singleTap];
    
    tapCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TapCount"] integerValue];
    
    self.searchBar.tintColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
//the below code is to make the touch event for the scrollview;
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITouch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITouch events

- (IBAction)buttonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    NSString *viewTitle = @"";
    
    switch (button.tag) {
            
        case SHOP_TAG: {
            
            viewTitle = NSLocalizedString(@"SHOP_TITLE", nil);
        }
            break;
            
        case REGISTRY_TAG: {
            viewTitle = NSLocalizedString(@"REGISTRY_TITLE", nil);
            
        }
            break;

        case STORES_TAG: {
            viewTitle = NSLocalizedString(@"STORES_TITLE", nil);
            
        }
            break;

        case BAG_TAG: {
            viewTitle = NSLocalizedString(@"BAG_TITLE", nil);
            
        }
            break;

        case OFFERS_TAG: {
            viewTitle = NSLocalizedString(@"OFFERS_TITLE", nil);
            
        }
            break;

        case ACCOUNT_TAG: {
            viewTitle = NSLocalizedString(@"ACCOUNT_TITLE", nil);
            
        }
            break;

            
        default:
            break;
    }
    
    tapCount ++;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:tapCount] forKey:@"TapCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    countDisplayViewController = [[CountDisplayViewController alloc] initWithNibName:@"CountDisplayViewController" bundle:nil];
    countDisplayViewController.viewTitle = [NSString stringWithFormat:@"%@ Page",viewTitle];
    countDisplayViewController.tapCountString = [NSString stringWithFormat:@"Tap #: %d",tapCount];
    navController = [[UINavigationController alloc] initWithRootViewController:countDisplayViewController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];

}
@end
