//
//  ProductPhotoImageView.h
//  Macys
//
//  Created by Sachith Rao on 13/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductPhotoImageViewDelegate <NSObject>
- (void)didTouchedPhotoImage;
@end

@interface ProductPhotoImageView : UIImageView {
    
}

@property (nonatomic,assign)id<ProductPhotoImageViewDelegate>delegate;

@end
