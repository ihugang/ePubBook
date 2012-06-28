//
//  Book.h
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  一本书的信息

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#define curBook ([Book sharedInstance])
 
@interface Book : NSObject 
@property(nonatomic,retain)NSDictionary* currentBookInfo;
@property(nonatomic,assign)int PageWidth,PageHeight,BodyFontSize;
@property(nonatomic,assign)int PageCount;
@property(nonatomic,assign) int ChapterCount;
@property(nonatomic,retain)NSArray* chapters;
@property(nonatomic,retain)NSArray* Pages;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Book);

-(void)prepareBook;

-(NSString*)getPIndex:(NSString*)name pChapter:(NSInteger)c pIndex:(NSString *)p aIndex:(NSString*)a;


@end
