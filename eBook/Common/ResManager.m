//
//  ResManager.m
//  WQMobile
//
//  Created by loufq on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResManager.h"
#import "FileUtil.h"
#import "MacroFunctions.h"
@implementation ResManager

+(UIImage*)getSkinImage:(NSString*)aPath{
    NSString* path =  [[[self navResPath] stringByAppendingPathComponent:@"Skin/Default/"] stringByAppendingPathComponent:aPath];
    return [UIImage imageWithContentsOfFile:path];    
}

+(UIImage*)getResImage:(NSString*)aPath{
    NSString* path =  [self getResPath:aPath];
    return [UIImage imageWithContentsOfFile:path];   
}

+(NSString*)getResPath:(NSString*)aPath{
    NSString* path =  [[[self navResPath] stringByAppendingPathComponent:@"Demo"] stringByAppendingPathComponent:aPath];
    return path;
}
+(NSString*)navResPath{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"];
}

+(NSString*)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString*)docPath:(NSString*)aPath{
    NSString* path = [DOCUMENTS_DIR stringByAppendingPathComponent:aPath];
     
    if (![FileUtil fileExist:path]) {
        path =[ResManager getResPath:aPath];
    }
    return path;
}
+(NSString*)docPath:(NSString*)aPath forSave:(BOOL)isSave{
    NSString* path = [DOCUMENTS_DIR stringByAppendingPathComponent:aPath];
    if (![FileUtil fileExist:path]) {
        [FileUtil ensureDirectoryExists:path];
    }
    return path;
}
 
@end
