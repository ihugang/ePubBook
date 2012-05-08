//
//  BookStore.h
//  eBook
//
//  Created by LiuWu on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

#define bookStore ([BookStore sharedInstance])

@interface BookStore : NSObject
@property (nonatomic,retain) NSDictionary *currentBookStore;
@property (nonatomic,retain) NSArray *books;
@property(nonatomic,assign)int BookCount;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(BookStore);

-(void)getBook;

@end
