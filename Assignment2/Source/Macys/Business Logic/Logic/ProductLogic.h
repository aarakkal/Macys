//
//  ProductLogic.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"

@interface ProductLogic : NSObject {
    
}

+ (ProductLogic*)sharedInstance;
- (NSString *)insertProduct;
- (NSString *)updateProduct:(ProductModel *)productModel;
- (NSArray *)fetchAllProducts;
- (BOOL)deleteProduct:(ProductModel *)product;
- (NSArray *)getAllTheProductsColorsInJson:(NSData *)data;

@end
