//
//  LoadJsonData.m
//  Macys
//
//  Created by Sachith Rao on 12/02/14.
//  Copyright (c) 2014 TEKSystems. All rights reserved.
//

#import "LoadJsonData.h"

@implementation LoadJsonData

+ (NSData *)dataFromFile:(NSString *)fileName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *fileContent = [NSData dataWithContentsOfFile:path];
    
    return fileContent;
}

@end
