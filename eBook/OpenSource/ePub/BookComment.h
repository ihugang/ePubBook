//
//  BookComment.h
//  eBook
//
//  Created by LiuWu on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#define bookComment ([BookComment sharedInstance])

@interface BookComment : NSObject
@property (nonatomic,retain) NSString* filename;
@property (nonatomic,retain) NSMutableDictionary *currentBookComment;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(BookComment);

-(void)getBookComment;
@end
