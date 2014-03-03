//
//  CountDisplayViewController.h
//  MacysAssignment1
//
//  Created by Sachith Rao on 18/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDisplayViewController : UIViewController {
    
}
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapCountLabel;
@property (nonatomic,retain)NSString *viewTitle;
@property (nonatomic,retain)NSString *tapCountString;
@end
