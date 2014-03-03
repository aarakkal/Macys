//
//  ShowProductViewController.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "ShowProductViewController.h"
#import "ProductFacade.h"
#import "ProductModel.h"
#import "UpdateProductViewController.h"

#define BUTTON_TAG 222

@interface ShowProductViewController ()

@end

@implementation ShowProductViewController

@synthesize productDataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"SHOW_PRODUCT_TITLE", nil);
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadProductsListPage)
                                                 name:@"ProductUpdatedSuccessfully"
                                               object:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadProductsListPage
{
    self.productDataArray = (NSMutableArray *)[[ProductFacade sharedInstance] fetchAllProducts];
    [self.productsListTableView reloadData];
}

#pragma mark - UITableView Datasource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProdcutListCell";
    UITableViewCell *cell = (UITableViewCell *)[self.productsListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ProductModel *model = [self.productDataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdateProductViewController *updateProductViewController = [[UpdateProductViewController alloc] initWithNibName:@"UpdateProductViewController" bundle:[NSBundle mainBundle]];
    updateProductViewController.ProductModel = [self.productDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:updateProductViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ProductModel *model = [self.productDataArray objectAtIndex:indexPath.row];
        
        BOOL isSuccess = [[ProductFacade sharedInstance] deleteProduct:model];
        
        if (isSuccess) {
            [self.productDataArray removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"PRODUCT_DELETE_MSG", nil)
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = BUTTON_TAG;
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"PRODUCT_DELETE_ERROR_MSG", nil)
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == BUTTON_TAG) {
        if (!self.productDataArray.count) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
