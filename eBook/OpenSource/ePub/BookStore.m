//
//  BookStore.m
//  eBook
//
//  Created by LiuWu on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookStore.h"
#import "AllHeader.h"

@implementation BookStore
@synthesize currentBookStore,books,BookCount;

SYNTHESIZE_SINGLETON_FOR_CLASS(BookStore);

-(void)getBook
{
    NSString* path = [ResManager docPath:@"Books.plist"];
    self.currentBookStore = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.books = DA(currentBookStore, @"books");
    
//    for (NSDictionary* item in DA(currentBookStore, @"books")) {
//        NSString* bookName = DO(item, @"name");        
//        NSString* path1 = DO(item, @"path");
//        DebugLog(@"aaaa ----> name: %@ , path: %@",bookName,path1);
//    } 
}

@end
