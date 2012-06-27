//
//  BookPick.h
//  eBook
//
//  Created by LiuWu on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#define bookPick ([BookPick sharedInstance])

typedef enum{
    iphone_minBookpick,
    iphone_middleBookpick,
    iphone_maxBookpick
} BookPickStyle;

@interface BookPick : NSObject
@property (nonatomic,retain) NSString* filename;
@property (nonatomic,retain) NSMutableDictionary *currentBookPick;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(BookPick);

-(void)getBookPick;
-(void)getBookPick:(BookPickStyle)style;

@end
