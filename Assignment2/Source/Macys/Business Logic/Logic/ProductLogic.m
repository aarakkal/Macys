//
//  ProductLogic.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "ProductLogic.h"
#import "ProductDataManager.h"
#import "JsonParserHelper.h"
#import "AppDelegate.h"

@implementation ProductLogic

+ (ProductLogic *)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (NSString *)insertProduct {
    
    NSData *data = [AppDelegate sharedAppDelegate].productData;
    
    if (data != nil) {
        
        NSDictionary *dict = [JsonParserHelper dataToDictionary:data];
        
        if (dict && ([dict isKindOfClass:[NSDictionary class]]
                     || [dict isKindOfClass:[NSArray class]])) {
        
            NSInteger productInsertedIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"productInsertedIndex"] integerValue];
            
            NSArray *productArray = [dict objectForKey:@"products"];
            
            if ([productArray count] > productInsertedIndex) { //insert the product data from the json
                NSDictionary *productDict = [productArray objectAtIndex: productInsertedIndex];
                ProductModel *model = [[ProductModel alloc] init];
                model.name = [productDict objectForKey:@"name"];
                model.desc = [productDict objectForKey:@"desc"];
                model.regularPrice = [productDict objectForKey:@"regularPrice"];
                model.salePrice = [productDict objectForKey:@"salePrice"];
                
                NSURL* imageUrl = [NSURL URLWithString:[productDict objectForKey:@"photo"]];
                NSData* data = [[NSData alloc] initWithContentsOfURL:imageUrl];
                
                model.photo = data;
                model.colors = [productDict objectForKey:@"color"];
                model.stores = [productDict objectForKey:@"store"];
                
                return [[ProductDataManager sharedInstance] insertOrUpdateProduct:model isUpdate:NO];
            }
            else { //all data are already inserted
                return @"All data in the json are inserted";
            }
        }
    }

    return @"Json data is nil";
}

- (NSString *)updateProduct:(ProductModel *)productModel {
    return [[ProductDataManager sharedInstance] insertOrUpdateProduct:productModel isUpdate:YES];
}

- (NSArray *)fetchAllProducts {
    return [[ProductDataManager sharedInstance] fetchAllProducts];
}

- (BOOL)deleteProduct:(ProductModel *)product {
    return [[ProductDataManager sharedInstance] deleteProduct:product];
}

- (NSArray *)getAllTheProductsColorsInJson:(NSData *)data {
    
    NSMutableArray *colorsArray = [[NSMutableArray alloc] init];
    
    if (data != nil) {
        
        NSDictionary *dict = [JsonParserHelper dataToDictionary:data];
        if (dict && ([dict isKindOfClass:[NSDictionary class]]
                     || [dict isKindOfClass:[NSArray class]])) {
            
            NSArray *productArray = [dict objectForKey:@"products"];
            
            NSString *color;
            for (NSDictionary *productDict in productArray) {
                color = [productDict valueForKey:@"color"];
                if (![colorsArray containsObject:color]) {
                    [colorsArray addObject:color];
                }
            }
        }
    }
    
    return colorsArray;
}

@end
