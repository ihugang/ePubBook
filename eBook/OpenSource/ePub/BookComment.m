//
//  BookComment.m
//  eBook
//
//  Created by LiuWu on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookComment.h"

@implementation BookComment
@synthesize filename,currentBookComment;

SYNTHESIZE_SINGLETON_FOR_CLASS(BookComment);

-(void)getBookComment{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    self.filename=[path stringByAppendingPathComponent:@"bookcomment.plist"];  
    
    //    self.path = [ResManager docPath:@"bookmark.plist"];
    //    self.currentBookMark = [NSDictionary dictionaryWithContentsOfFile:filename];
    [self checkFile];
}

-(void)getBookComment:(BookCommentStyle)style
{
    //获取document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *name = @"";
    switch (style) {
        case iphone_minBookComment:
            name = @"iphone_minBookComment.plist";
            break;
        case iphone_middleBookComment:
            name = @"iphone_middleBookComment.plist";
            break;
        case iphone_maxBookComment:
            name = @"iphone_maxBookComment.plist";
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
        self.currentBookComment = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    }else {
        NSLog(@"has no file");
        self.currentBookComment = [[[NSMutableDictionary alloc] init] autorelease];
        [currentBookComment writeToFile:filename atomically:YES];
    }
}

@end
