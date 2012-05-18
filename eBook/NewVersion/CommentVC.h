//
//  CommentVC.h
//  eBook
//
//  Created by LiuWu on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"

@interface CommentVC : BaseVC

@property (nonatomic,retain) NSMutableDictionary *comment;
@property (nonatomic,retain) NSString *className;
@property (nonatomic,retain) UITextView *textView;

@end
