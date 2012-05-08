//
//  Book.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Book.h"
#import "Chapter.h"
#import "AllHeader.h"

@implementation Book
@synthesize currentBookInfo;
@synthesize BodyFontSize,PageWidth,PageHeight;
@synthesize PageCount,ChapterCount;
@synthesize chapters;
SYNTHESIZE_SINGLETON_FOR_CLASS(Book);

-(void)prepareBook{ 

    NSLog(@"Book.m  ---->  prepareBook");
    
    float fontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:@"bodyFontSize"] floatValue];
    NSLog(@"bodyFontSize --- > %f",fontSize);
    
    NSString* path = nil;
    if (mf_IsPad) {
//        path = [ResManager docPath:@"PageBreak~iPad@2x.plist"]; 
        path = [ResManager docPath:@"iPhone_2@2x36.plist"]; 
    }
    else{
        if (fontSize == 28) {
            path = [ResManager docPath:@"iPhone_2@2x.plist"]; 
        }else if(fontSize == 36)
        {
            path = [ResManager docPath:@"iPhone_2@2x36.plist"];
        }else {
            path = [ResManager docPath:@"iPhone_2@2x44.plist"];
        }
    }
    
    self.currentBookInfo =[NSDictionary dictionaryWithContentsOfFile:path];
    BodyFontSize = DI(self.currentBookInfo, @"BodyFontSize");
    PageWidth = DI(self.currentBookInfo, @"PageWidth");
    PageHeight = DI(self.currentBookInfo, @"PageHeight"); 
    
    NSLog(@"Book prepareBook - >BodyFontSize:%d,PageWidth:%d,PageHeight:%d",BodyFontSize,PageWidth,PageHeight);
    
    NSMutableArray* cs = [NSMutableArray array]; 
    int index = 0,iAllPageCount = 0;
    for (NSDictionary* item in DA(currentBookInfo, @"PageBreakSet")) {
        NSString* title = DO(item, @"title");        
        NSString* shortPath =[NSString stringWithFormat:@"book/%@.html",title];
//        NSString *shortPath = @"book/第四章新手入门.html";
        
        NSString* path = resPath(shortPath);
//        NSLog(@"shortpath - %@",shortPath);
//        NSString *path1 = DO(item, @"path");
//        NSLog(@"Book path - > %@",path);
        
        Chapter* chapter = [[[Chapter alloc] initWithPath:path title:title chapterIndex:index] autorelease];
        //title
        chapter.pageCount = DA(item, @"pages").count; 
        [cs addObject:chapter];
        index++;  
//        iAllPageCount+= item.count;
        iAllPageCount += chapter.pageCount;
    } 
    self.ChapterCount = index;
    self.PageCount =iAllPageCount;
    
    self.chapters = cs;
}

@end
