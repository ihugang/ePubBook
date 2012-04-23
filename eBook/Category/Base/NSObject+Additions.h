//
//  NSObject+Additions.h
//  NewsPhoto
//
//  Created by loufq on 11-4-23.
//  Copyright 2011 e0571.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject(Additions)

+ (NSDictionary *)describeProperties;

+ (id)objectWithMapDict:(NSDictionary *)map valueDict:(NSDictionary *)values;

@end