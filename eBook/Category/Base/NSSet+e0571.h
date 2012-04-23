//
//  NSSet+e0571.h
//  CodansShareLibrary10
//
//  Created by yangxh yang on 11-12-27.
//  Copyright (c) 2011年 codans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (e0571)

/*
 * Group by
 */
- (NSDictionary *)groupByUsingBlock:(id(^)(id obj))block;

@end
