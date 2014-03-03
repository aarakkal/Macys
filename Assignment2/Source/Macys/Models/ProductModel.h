//
//  ProductModel.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, retain) NSString * prodId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * regularPrice;
@property (nonatomic, retain) NSString * salePrice;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * colors;
@property (nonatomic, retain) NSString * stores;

@end
