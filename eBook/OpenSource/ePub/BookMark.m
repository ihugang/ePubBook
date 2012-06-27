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
    [self checkFile];
    
}

-(void)getBookMark:(BookMarkStyle)style
{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *name = @"";
    switch (style) {
        case iphone_minBookMark:
            name = @"iphone_minBookMark.plist";
            break;
        case iphone_middleBookMark:
            name = @"iphone_middleBookMark.plist";
            break;
        case iphone_maxBookMark:
            name = @"iphone_maxBookMark.plist";
            break;
        default:
            break;
    }
    self.filename=[path stringByAppendingPathComponent:name];  
    [self checkFile];
}

- (void)checkFile
{
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease] ;
    //判断文件是否存在
    if ([fileManager fileExistsAtPath:filename]) {
        //文件存在
        self.currentBookMark = [NSDictionary dictionaryWithContentsOfFile:filename];
        self.bookmarks = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    }else {
        NSLog(@"has no file");
        self.currentBookMark = [[[NSDictionary alloc] init] autorelease];
        self.bookmarks = [[[NSMutableDictionary alloc] init] autorelease];
        [bookmarks writeToFile:filename atomically:YES];
    }
}

@end
