//
//  ProductDataManager.h
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "ProductModel.h"

@interface ProductDataManager : NSObject {
    NSManagedObjectContext *context;
}

+ (ProductDataManager*)sharedInstance;
- (NSString *)insertOrUpdateProduct:(ProductModel *)productModel isUpdate:(BOOL)isUpdate;
- (NSArray *)fetchAllProducts;
- (BOOL)deleteProduct:(ProductModel *)product;

@end
