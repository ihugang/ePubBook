//
//  ResManager.h
//  WQMobile
//
//  Created by loufq on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define skinImage(_path) ([ResManager getSkinImage:_path])
#define resImage(_path) ([ResManager getResImage:_path])
#define resPath(_path) ([ResManager getResPath:_path])
#define config(_pageid)([ResManager getPageConfig:_pageid])

@interface ResManager : NSObject

+(UIImage*)getSkinImage:(NSString*)aPath;

+(UIImage*)getResImage:(NSString*)aPath;

+(NSString*)getResPath:(NSString*)aPath;

+(NSString*)navResPath;
 
+(NSString*)docPath:(NSString*)aPath;
+(NSString*)docPath:(NSString*)aPath forSave:(BOOL)isSave;
@end
