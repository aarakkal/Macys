//
//  UpdateProductViewController.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "ProductPhotoImageView.h"
#import "PhotoViewController.h"

@interface UpdateProductViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ProductPhotoImageViewDelegate> {
    
    CGFloat screenHeight;
    UIImagePickerController *cameraUI;
    UIPickerView *pickerView;
    PhotoViewController *photoViewController;
    NSArray *colorsArray;
    NSString *selectedColor;
    NSInteger colorPickerIndex;
    NSInteger pickerIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *regularPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *salePriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *colorsButton;
@property (weak, nonatomic) IBOutlet UITextField *storesTextField;
@property (weak, nonatomic) IBOutlet ProductPhotoImageView *productImageView;
@property (nonatomic,retain) ProductModel *productModel;
@property (strong, nonatomic) UIActionSheet *bgActionSheet;

- (IBAction)colorsButtonClickAction:(id)sender;
- (IBAction)changePhoto:(id)sender;

@end
