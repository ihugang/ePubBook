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
@synthesize chapters,Pages;
SYNTHESIZE_SINGLETON_FOR_CLASS(Book);

-(void)prepareBook{ 

    NSLog(@"Book.m  ---->  prepareBook");
    
    float fontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:@"bodyFontSize"] floatValue];
    NSLog(@"bodyFontSize --- > %f",fontSize);
    //第一次程序加载，字体默认值
    if (fontSize == 0) {
        fontSize = 28;
    }
    
    NSString* path = nil;
    if (mf_IsPad) {
//        path = [ResManager docPath:@"iPhone_2@2x36.plist"]; 
        if (fontSize == 28) {
            path = [ResManager docPath:@"iPad_2@2x.plist"];
        }else if(fontSize == 36){
            path = [ResManager docPath:@"iPad_2@2x36.plist"];
        }else {
            path = [ResManager docPath:@"iPad_2@2x44.plist"];
        }
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
    NSArray *pages = nil;
    NSMutableArray* allPages = [NSMutableArray array]; 
    for (NSDictionary* item in DA(currentBookInfo, @"PageBreakSet")) {
        NSString* title = DO(item, @"title");        
        NSString* shortPath =[NSString stringWithFormat:@"/book/%@.html",title];
//        NSString *shortPath = @"book/第四章新手入门.html";
        
        //获取document目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:shortPath];
//        DebugLog(@"filename ---> %@",filename);
        
//        NSString* filename = resPath(shortPath);
        pages = DA(item, @"pages");
        [allPages addObject:pages];
//        NSLog(@"shortpath - %@",shortPath);
//        NSString *path1 = DO(item, @"path");
//        NSLog(@"Book path - > %@",path);
        
        Chapter* chapter = [[[Chapter alloc] initWithPath:filename title:title chapterIndex:iAllPageCount ] autorelease];
        //title
        //加1,给页面扉页留位置
        chapter.pageCount = DA(item, @"pages").count + 1; 
        
//        DebugLog(@"chapter:%d pagecount -- %d",index,iAllPageCount);
        [cs addObject:chapter];
        index++;  
//        iAllPageCount+= item.count;
        iAllPageCount += chapter.pageCount;
    } 
    self.ChapterCount = index;
    self.PageCount =iAllPageCount;
    self.Pages = allPages;
    self.chapters = cs;
}
//返回plist中对应的页面位置
-(NSString*)getPIndex:(NSString*)name pChapter:(NSInteger)c pIndex:(NSString *)p aIndex:(NSString*)a
{
    DebugLog(@"getPIndex -------> %@   %@  %@",p,a,name);
    NSString *path = [ResManager docPath:name]; 
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *all = DA(dic, @"PageBreakSet");
    NSDictionary *chap = [all objectAtIndex:c];
    NSArray *pages = DA(chap, @"pages");
    DebugLog(@"getPindex -------> %@",pages);
    
    NSString *pIndex = @"";
    for (int i =0 ; i< pages.count; i++) {
        if ([[[pages objectAtIndex:i] objectForKey:@"ParaIndex"] intValue] == p.intValue) {
            //等于当前P,判断在p中的偏移位置
            if ([[[pages objectAtIndex:i] objectForKey:@"AtomIndex"] intValue] == a.intValue) {
                pIndex = [NSString stringWithFormat:@"%d",i];
                break;
            }else {
                if ([[[pages objectAtIndex:i] objectForKey:@"AtomIndex"] intValue] > a.intValue) {
                    pIndex = [NSString stringWithFormat:@"%d",i];
                    break;
                }
//                pIndex = [NSString stringWithFormat:@"%d",i+1];
            }
        }else {//没有匹配的P 根据大于当前p的index
            if ([[[pages objectAtIndex:i] objectForKey:@"ParaIndex"] intValue] > p.intValue) {
                pIndex = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
    }
    DebugLog(@"index -------> %@",pIndex);
    return pIndex;
}

@end
