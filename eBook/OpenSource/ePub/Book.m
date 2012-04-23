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
        path = [ResManager docPath:@"PageBreak~iPad@2x.plist"]; 
    }
    else{
        path = [ResManager docPath:@"PageBreak~iPhone@2x.plist"];
        
    }
    
    self.currentBookInfo =[NSDictionary dictionaryWithContentsOfFile:path];
    BodyFontSize = DI(self.currentBookInfo, @"BodyFontSize");
    PageWidth = DI(self.currentBookInfo, @"PageWidth");
    PageHeight = DI(self.currentBookInfo, @"PageHeight"); 
    NSMutableArray* cs = [NSMutableArray array]; 
    int index = 0,iAllPageCount = 0;
    for (NSArray* item in DA(currentBookInfo, @"PageBreakSet")) {
        NSString* shortPath =[NSString stringWithFormat:@"book/Chuang Ye 36Tiao Jun Gui _split_%03d.htm",index];
        NSString* path = resPath(shortPath);
        NSString* title = shortPath.lastPathComponent;
        Chapter* chapter = [[[Chapter alloc] initWithPath:path title:title chapterIndex:index] autorelease];
       
        chapter.pageCount = item.count; 
        [cs addObject:chapter];
        index++;  
        iAllPageCount+= item.count;
    } 
    self.ChapterCount = index;
    self.PageCount =iAllPageCount;
    
    self.chapters = cs;
}

@end
