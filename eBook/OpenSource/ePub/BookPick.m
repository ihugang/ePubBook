//
//  BookPick.m
//  eBook
//
//  Created by LiuWu on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookPick.h"

@implementation BookPick
@synthesize filename,currentBookPick;

SYNTHESIZE_SINGLETON_FOR_CLASS(BookPick);

-(void)getBookPick{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    self.filename=[path stringByAppendingPathComponent:@"bookpick.plist"];  
    
    //    self.path = [ResManager docPath:@"bookmark.plist"];
    //    self.currentBookMark = [NSDictionary dictionaryWithContentsOfFile:filename];
    [self checkFile];
}

-(void)getBookPick:(BookPickStyle)style
{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *name = @"";
    switch (style) {
        case iphone_minBookpick:
            name = @"iphone_minBookPick.plist";
            break;
        case iphone_middleBookpick:
            name = @"iphone_middleBookPick.plist";
            break;
        case iphone_maxBookpick:
            name = @"iphone_maxBookPick.plist";
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
        self.currentBookPick = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    }else {
        NSLog(@"has no file");
        self.currentBookPick = [[[NSMutableDictionary alloc] init] autorelease];
        [currentBookPick writeToFile:filename atomically:YES];
    }

}

@end
