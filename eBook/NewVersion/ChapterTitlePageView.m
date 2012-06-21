//
//  ChapterTitlePageView.m
//  eBook
//
//  Created by LiuWu on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChapterTitlePageView.h"

@implementation ChapterTitlePageView
@synthesize chaterTitle,chapterName,chapterIndex,enChaterIndex;

- (void)dealloc {
    [super dealloc];
}

-(void)initLayout
{
//    self.backgroundColor = [UIColor redColor];
    DebugLog(@"-----> %f ,---> %f",self.bounds.size.width,self.bounds.size.height);
    UIImageView *bgImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    [bgImage setImage:skinImage(@"fontbar/5002.png")];
    [self addSubview:bgImage];
    
//    self.chapterIndex = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, 200, 44)];
    self.chapterIndex = [[[UILabel alloc] init] autorelease];
    [chapterIndex setBackgroundColor:[UIColor clearColor]];
    [self addSubview:chapterIndex];
    
//    self.chapterName = [[UILabel alloc] initWithFrame:CGRectMake(chapterIndex.left, chapterIndex.bottom ,self.bounds.size.width - chapterIndex.left, 44)];
    self.chapterName = [[[UILabel alloc] init] autorelease];
    
    [chapterName setBackgroundColor:[UIColor clearColor]];
    [self addSubview:chapterName];
    
//    self.enChaterIndex = [[UILabel alloc] initWithFrame:CGRectMake(chapterIndex.left, chapterName.bottom, 200, 44)];
    self.enChaterIndex = [[[UILabel alloc] init] autorelease];
    [enChaterIndex setFont:[UIFont systemFontOfSize:20]];
    [enChaterIndex setBackgroundColor:[UIColor clearColor]];
    [self addSubview:enChaterIndex];
    
    if (mf_IsPad) {
        [self.chapterIndex setFrame:CGRectMake(80, 65, 200, 44)];
        [chapterIndex setFont:[UIFont boldSystemFontOfSize:40]];
        [chapterName setFont:[UIFont systemFontOfSize:40]];
        [self.chapterName setFrame:CGRectMake(self.chapterIndex.left, self.chapterIndex.bottom +10,self.bounds.size.width - self.chapterIndex.left, 44)];
        [self.enChaterIndex setFrame:CGRectMake(chapterIndex.left, chapterName.bottom, self.bounds.size.width - self.chapterIndex.left, 44)];
    }else {
        [self.chapterIndex setFrame:CGRectMake(30, 25, 200, 44)];
        [chapterIndex setFont:[UIFont boldSystemFontOfSize:30]];
        [chapterName setFont:[UIFont systemFontOfSize:25]];
        [self.chapterName setFrame:CGRectMake(self.chapterIndex.left, self.chapterIndex.bottom ,self.bounds.size.width - self.chapterIndex.left, 44)];
        [self.enChaterIndex setFrame:CGRectMake(self.chapterIndex.left, self.chapterName.bottom, self.bounds.size.width - self.chapterIndex.left, 44)];
    }

}

@end
