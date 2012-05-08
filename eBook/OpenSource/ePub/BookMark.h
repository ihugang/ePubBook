//
//  BookMark.h
//  eBook
//
//  Created by LiuWu on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#define bookMarks ([BookMark sharedInstance])

@interface BookMark : NSObject
@property (nonatomic,retain) NSString* filename;
@property (nonatomic,retain) NSDictionary *currentBookMark;
@property (nonatomic,retain) NSMutableDictionary *bookmarks;


SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(BookMark);

-(void)getBookMark;


@end
