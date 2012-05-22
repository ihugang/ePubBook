//
//  ChapterTitlePageView.h
//  eBook
//
//  Created by LiuWu on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@interface ChapterTitlePageView : BaseView

@property (nonatomic,retain) NSString *chaterTitle;
@property (nonatomic,retain) UILabel *chapterIndex;
@property (nonatomic,retain) UILabel *chapterName;
@property (nonatomic,retain) UILabel *enChaterIndex;

@end
