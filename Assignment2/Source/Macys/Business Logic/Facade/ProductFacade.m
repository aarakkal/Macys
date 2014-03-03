//
//  ProductFacade.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "ProductFacade.h"
#import "ProductLogic.h"

@implementation ProductFacade

+ (ProductFacade *)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (NSString *)insertProduct {
    return [[ProductLogic sharedInstance] insertProduct];
}

- (NSArray *)fetchAllProducts {
    return [[ProductLogic sharedInstance] fetchAllProducts];
}

- (BOOL)deleteProduct:(ProductModel *)product {
    return [[ProductLogic sharedInstance] deleteProduct:product];
}

- (NSString *)updateProduct:(ProductModel *)productModel {
    return [[ProductLogic sharedInstance] updateProduct:productModel];
}

@end
