//
//  ChapterListVC.h
//  eBook
//
//  Created by LiuWu on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"

@protocol ChapterListVCDelegate <NSObject>

- (void)ChapterListClick;

@end

@interface ChapterListVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *chapterList;
    int check;
    UIButton *cataButton1;
    UIButton *cataButton2;
    UIButton *cataButton3;
    UIButton *cataButton4;
    
    int curSpineIndex;
    NSIndexPath *ip;
}

@property (nonatomic,retain) NSMutableArray *bookMarkSortedValues;
@property (nonatomic,retain) NSArray *bookPickSortedValues;
@property (nonatomic,assign) id<ChapterListVCDelegate>delegate;

@end
