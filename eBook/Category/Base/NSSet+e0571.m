//
//  NSSet+e0571.m
//  CodansShareLibrary10
//
//  Created by yangxh yang on 11-12-27.
//  Copyright (c) 2011年 codans. All rights reserved.
//

#import "NSSet+e0571.h"

@implementation NSSet (e0571)

- (NSDictionary *)groupByUsingBlock:(id (^)(id))block
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (id obj in self) {
        id key = block(obj);
        NSMutableSet *set = [dictionary objectForKey: key ];
        
        if (set == nil) {
            set = [NSMutableSet setWithObject:obj];
            [dictionary setObject:set forKey: key ];
        } else {
            [set addObject:obj];
        }
    }
    
    return dictionary;
}

@end
