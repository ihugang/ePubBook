//
//  NSString+Additions.h
//  LFQ Fundation
//
//  Created by yangxh on 11-3-29.
//  Copyright 2011 E0571. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Additions)

// 编码
- (NSString *) base64StringEncode;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

// 解码
- (NSString *) base64StringDecode;
+ (NSData *) base64DataFromString:(NSString *)string;

// 过滤UUID的-
- (NSString *)fileName;

// MD5
- (NSString *)MD5;

+ (NSString*)stringWithUUID;

- (BOOL)isContainsString:(NSString *)searchKey;
- (BOOL)isNotContainsString:(NSString *)searchKey;
- (BOOL)hasSubstring:(NSString *)substring;
- (NSString *)after:(NSString *)substring;

// 构建url
#define BUILD_URL(...) [NSString urlWithArgs:__VA_ARGS__,nil]
+ (NSString *)urlWithArgs:(NSString *)firstArg, ...;

- (NSString *)trim;

@end
