//
//  ShowProductViewController.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowProductViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UITableView *productsListTableView;
@property (nonatomic, retain) NSMutableArray *productDataArray;

@end
