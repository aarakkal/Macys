//
//  MainViewController.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "MainViewController.h"
#import "ShowProductViewController.h"
#import "ProductFacade.h"
#import "MBProgressHUD.h"

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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.8196 green:0.0902 blue:0.0706 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)inserProductDetails {
    
    NSString *status = [[ProductFacade sharedInstance] insertProduct];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSArray *statusStringArray = [status componentsSeparatedByString:@":"];
    if([[statusStringArray objectAtIndex:0] isEqualToString:@"Success"]) {//Successfully inserted the product
        NSInteger productInsertedIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"productInsertedIndex"] integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:productInsertedIndex+1] forKey:@"productInsertedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *msgString = [NSString stringWithFormat:@"Product '%@' is created", [statusStringArray objectAtIndex:1]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {//Handle failure/duplicate scenario
        if([[statusStringArray objectAtIndex:0] isEqualToString:@"Duplicate"]) {
            NSString *msgString = [NSString stringWithFormat:@"%@ is already existing.Do you want to insert next product ?",[statusStringArray objectAtIndex:1] ];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:msgString delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
        }
        else { //Handle error scenario
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)insertProduct {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(inserProductDetails) withObject:nil afterDelay:0.1];
}

#pragma mark - Button Click Events

- (IBAction)createProduct:(id)sender {
    [self insertProduct];
}

- (IBAction)showProduct:(id)sender {
    NSArray * productDataArray = [[[ProductFacade sharedInstance] fetchAllProducts] mutableCopy];
    
    if (!productDataArray.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"SHOW_PRODUCT_MSG", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        ShowProductViewController *showProductViewController = [[ShowProductViewController alloc] initWithNibName:@"ShowProductViewController" bundle:[NSBundle mainBundle]];
        showProductViewController.productDataArray = [productDataArray mutableCopy];
        [self.navigationController pushViewController:showProductViewController animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://NO
        {
            
        }
            break;
            
        case 1://YES
        {
            NSInteger productInsertedIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"productInsertedIndex"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:productInsertedIndex+1] forKey:@"productInsertedIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self insertProduct];
        }
            break;

        default:
            break;
    }
}

@end
