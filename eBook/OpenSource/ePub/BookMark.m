//
//  BookMark.m
//  eBook
//
//  Created by LiuWu on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookMark.h"
#import "AllHeader.h"

@implementation BookMark
@synthesize filename,currentBookMark,bookmarks;

SYNTHESIZE_SINGLETON_FOR_CLASS(BookMark);

-(void)getBookMark
{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    self.filename=[path stringByAppendingPathComponent:@"bookmark.plist"];  
    
    //    self.path = [ResManager docPath:@"bookmark.plist"];
//    self.currentBookMark = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    //判断文件是否存在
    if ([fileManager fileExistsAtPath:filename]) {
        //文件存在
        self.currentBookMark = [NSDictionary dictionaryWithContentsOfFile:filename];
        self.bookmarks = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    }else {
        NSLog(@"has no file");
        self.currentBookMark = [[NSDictionary alloc] init];
        self.bookmarks = [[NSMutableDictionary alloc] init];
        [bookmarks writeToFile:filename atomically:YES];
    }
}

@end
