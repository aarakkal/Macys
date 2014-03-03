//
//  ProductDataManager.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "ProductDataManager.h"
#import "Product.h"

@implementation ProductDataManager

+ (ProductDataManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (id)init {
    context = [[CoreDataHelper sharedInstance] managedObjectContext];
    return self;
}

- (NSString *)insertOrUpdateProduct:(ProductModel *)productModel isUpdate:(BOOL)isUpdate {
    
    NSNumber *pId;
    
    //To update the record no need to fetch the MAX id.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchResults = Nil;
    
    NSPredicate *predicate;
    if (isUpdate) {
        predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (prodId != %@)",productModel.name, productModel.prodId];
        [request setPredicate:predicate];
        
        fetchResults = [context executeFetchRequest:request error:&error];
        if ([fetchResults count] > 0) {
            return [NSString stringWithFormat:@"Product with name %@ already exists",productModel.name];
        }
        else {
            predicate = [NSPredicate predicateWithFormat:@"prodId = %@",productModel.prodId];
            [request setPredicate:predicate];
            fetchResults = [context executeFetchRequest:request error:&error];
            if ([fetchResults count] > 0) {
                [fetchResults setValue:productModel.name forKey:@"name"];
                [fetchResults setValue:productModel.desc forKey:@"desc"];
                [fetchResults setValue:productModel.regularPrice forKey:@"regularPrice"];
                [fetchResults setValue:productModel.salePrice forKey:@"salePrice"];
                [fetchResults setValue:productModel.photo forKey:@"photo"];
                [fetchResults setValue:productModel.colors forKey:@"colors"];
                [fetchResults setValue:productModel.stores forKey:@"stores"];
            }
        }
    }
    else {
        
        //Check if the product already existing in the DB
        predicate = [NSPredicate predicateWithFormat:@"name = %@",productModel.name];
        [request setPredicate:predicate];
        
        fetchResults = [context executeFetchRequest:request error:&error];
        if ([fetchResults count] > 0) {
            return [NSString stringWithFormat:@"Duplicate:%@",productModel.name];
        }
        
        //reset the request as we uses the same for duplicate check
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        //sort to get the maximum id of the Product
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"prodId" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        fetchResults = [context executeFetchRequest:request error:&error];
        if (!fetchResults) {
            return [NSString stringWithFormat:@"Error in fetching the product"];
        }
        
        //get the next id to insert
        if ([fetchResults count] == 0) {
            pId = [NSNumber numberWithInt:1];
        } else {
            Product *product = [fetchResults objectAtIndex:0];
            pId = [NSNumber numberWithInt:[product.prodId intValue]+1];
        }
        
        //insert the data to the table
        Product *product  = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Product"
                       inManagedObjectContext:context];
        product.prodId = pId;
        product.name = productModel.name;
        product.desc = productModel.desc;
        product.regularPrice = productModel.regularPrice;
        product.salePrice = productModel.salePrice;
        product.photo = productModel.photo;
        product.colors = productModel.colors;
        product.stores = productModel.stores;
    }
    
    if (![context save:&error]) {
        return [NSString stringWithFormat:@"Error in inserting the product"];
    }
    
    return [NSString stringWithFormat:@"Success:%@",productModel.name];
}

- (NSArray *)fetchAllProducts {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchResults  = [context executeFetchRequest:request error:&error];
    if (!fetchResults) {
        NSLog(@"Error in fetching products ");
    }
    
    return fetchResults;
}

- (BOOL)deleteProduct:(ProductModel *)product {
    
    NSManagedObject *eventToDelete = (NSManagedObject *)product;
    [context deleteObject:eventToDelete];
    NSError *error = nil;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

@end
