//
//  UpdateProductViewController.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "UpdateProductViewController.h"
#import "ProductFacade.h"
#import "AppDelegate.h"

#define UPDATE_SUCCESS_TAG 1111

@interface UpdateProductViewController ()

@end

@implementation UpdateProductViewController

@synthesize productModel;
@synthesize bgActionSheet;

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
    self.title = NSLocalizedString(@"CREATE_PRODUCT_TITLE", nil);
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.pageScroll addGestureRecognizer:singleTap];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"UPDATE_BUTTON_TITLE", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.productImageView.delegate = self;
    
    //create the pickerView
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];

    colorsArray =  [[AppDelegate sharedAppDelegate] colorsArray];
    
    selectedColor = [colorsArray objectAtIndex:0];
    
    colorPickerIndex = [self getTheIndexOf:productModel.colors];

    [self loadProductDetails];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pageScroll setContentSize:CGSizeMake(320, screenHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
//the below code is to make the touch event for the scrollview;
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    [self resetViewToOriginalPosition];
}

- (void)resetViewToOriginalPosition {
    [self.productNameTextField resignFirstResponder];
    [self.productDescriptionTextField resignFirstResponder];
    [self.regularPriceTextField resignFirstResponder];
    [self.salePriceTextField resignFirstResponder];
    [self.storesTextField resignFirstResponder];
    
    [self.pageScroll setContentSize:CGSizeMake(320, screenHeight)];
    [self.pageScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)loadProductDetails {
    self.productNameTextField.text = productModel.name;
    self.productDescriptionTextField.text = productModel.desc;
    self.regularPriceTextField.text = productModel.regularPrice;
    self.salePriceTextField.text = productModel.salePrice;
    self.storesTextField.text = productModel.stores;
    [self.colorsButton setTitle:productModel.colors forState:UIControlStateNormal];
    
    UIImage *photoImage = [UIImage imageWithData:productModel.photo];
    self.productImageView.image = photoImage;
}

//Returns the index of the color in the pickerview.
- (NSInteger)getTheIndexOf:(NSString*)color {
    int index = 0;
    for (NSString *pickerColor in colorsArray) {
        if ([pickerColor isEqualToString:color]) {
            break;
        }
        index ++;
    }
    return index;
}

#pragma mark - Button Click Action

- (void)saveButtonAction:(id)sender {
    
    if(!self.productNameTextField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:NSLocalizedString(@"UPDATE_ALERT_MSG", nil)
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ProductModel *model = [[ProductModel alloc] init];
    model.prodId = productModel.prodId;
    model.name = self.productNameTextField.text;
    model.desc = self.productDescriptionTextField.text;
    model.regularPrice = self.regularPriceTextField.text;
    model.salePrice = self.salePriceTextField.text;
    model.stores = self.storesTextField.text;
    model.photo = UIImagePNGRepresentation(self.productImageView.image);
    model.colors = self.colorsButton.titleLabel.text;
    
    NSString *status = [[ProductFacade sharedInstance] updateProduct:model];
    NSArray *statusStringArray = [status componentsSeparatedByString:@":"];
    
    if([[statusStringArray objectAtIndex:0] isEqualToString:@"Success"]) {//Successfully inserted the product
        
        NSString *msgString = [NSString stringWithFormat:@"Updated the Product '%@' successfully", [statusStringArray objectAtIndex:1]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:msgString
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = UPDATE_SUCCESS_TAG;
        [alert show];

    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) message:status
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)pikcerViewCancelButtonClicked:(id)sender {
    [self.bgActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)pickerViewDoneButtonClicked:(id)sender {
    
    [self.colorsButton setTitle:selectedColor forState:UIControlStateNormal];
    [self.bgActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    colorPickerIndex = pickerIndex;
}

- (IBAction)colorsButtonClickAction:(id)sender {
    
    [pickerView selectRow:colorPickerIndex inComponent:0 animated:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SELECT_COLOR", nil)
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    self.bgActionSheet = actionSheet;
    
    UIButton *cancelButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8, 10, 70, 33);
    [cancelButton addTarget:self action:@selector(pikcerViewCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.7451 green:0.00 blue:0.0235 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName: @"SourceSansPro-Light" size: 25];
    
    [self.bgActionSheet addSubview: cancelButton];
    
    UIButton *doneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    doneButton.frame = CGRectMake(243, 10, 70, 33);
    [doneButton addTarget:self action:@selector(pickerViewDoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.adjustsImageWhenHighlighted = YES;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithRed:0.7451 green:0.00 blue:0.0235 alpha:1.0] forState:UIControlStateNormal];
    doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneButton.titleLabel.font = [UIFont fontWithName: @"SourceSansPro-Light" size: 25];
    
    [self.bgActionSheet addSubview: doneButton];
    
    [self.bgActionSheet addSubview:pickerView];
    
    [self.bgActionSheet showInView:self.view];
    [self.bgActionSheet setBounds:CGRectMake(0,0,320, 472)];

}

- (IBAction)changePhoto:(id)sender {
    
    [self resetViewToOriginalPosition];
    cameraUI = [[UIImagePickerController alloc] init];

    BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    
    if (isCameraAvailable) {
        //ask the user he want to use camera or saved photos
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL_TITLE", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"PHOTO_ALBUM_TITLE", nil),NSLocalizedString(@"CAMERA_TITLE", nil), nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
    else {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.delegate = self;
        [self.navigationController presentViewController:cameraUI animated:YES completion:nil];
    }

}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.pageScroll setContentSize:CGSizeMake(320, screenHeight+250)];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            
        case 0://Photo Album
        {
            cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
            
        case 1://Camera
        {
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
            
        case 2://Cancel
        {
            return;
        }
            break;

        default:
            break;
    }
    
    cameraUI.delegate = self;
    [self.navigationController presentViewController:cameraUI animated:YES completion:nil];

}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.productImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ProductPhotoImageViewDelegate methods

- (void)didTouchedPhotoImage {
    
    photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:[NSBundle mainBundle]];
    photoViewController.photo = self.productImageView.image;
    [self.navigationController pushViewController:photoViewController animated:YES];
}

#pragma mark - UIPickerView Datasource and Delegate Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return colorsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [colorsArray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    selectedColor = [colorsArray objectAtIndex:row];
    pickerIndex = row;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == UPDATE_SUCCESS_TAG) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductUpdatedSuccessfully" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
