//
//  JsonParserHelper.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "JsonParserHelper.h"

@implementation JsonParserHelper

+ (NSDictionary *)dataToDictionary:(NSData *)data {
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:NSJSONReadingAllowFragments
                          error:&error];
    if (error) {
        NSLog(@"Error in converting data to dictionary: %@", [error description]);
    }
    
    return dict;
}


@end
