//
//  Book.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Book.h"
#import "Chapter.h"
@implementation Book
@synthesize currentBookInfo;
@synthesize BodyFontSize,PageWidth,PageHeight;
@synthesize PageCount,ChapterCount;
@synthesize chapters;
SYNTHESIZE_SINGLETON_FOR_CLASS(Book);

-(void)prepareBook{ 

    NSString* path = nil;
    if (mf_IsPad) {
//        path = [ResManager docPath:@"PageBreak~iPad@2x.plist"]; 
        path = [ResManager docPath:@"iPhone_2@2x.plist"]; 
    }
    else{
        path = [ResManager docPath:@"iPhone_2@2x.plist"]; 
    }
    
    self.currentBookInfo =[NSDictionary dictionaryWithContentsOfFile:path];
    BodyFontSize = DI(self.currentBookInfo, @"BodyFontSize");
    PageWidth = DI(self.currentBookInfo, @"PageWidth");
    PageHeight = DI(self.currentBookInfo, @"PageHeight"); 
    NSMutableArray* cs = [NSMutableArray array]; 
    int index = 0,iAllPageCount = 0;
    for (NSDictionary* item in DA(currentBookInfo, @"PageBreakSet")) {
        NSString* title = DO(item, @"title");        
        NSString* shortPath =[NSString stringWithFormat:@"book/%@.html",title];
        NSString* path = resPath(shortPath);

        Chapter* chapter = [[[Chapter alloc] initWithPath:path title:title chapterIndex:index] autorelease];
        //title
        chapter.pageCount = DA(item, @"pages").count; 
        [cs addObject:chapter];
        index++;  
        iAllPageCount+= item.count;
    } 
    self.ChapterCount = index;
    self.PageCount =iAllPageCount;
    
    self.chapters = cs;
}

@end
