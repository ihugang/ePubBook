//
//  eBookViewController.h
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"
#import "EPubPageView.h"
#import "EPub.h"

@interface eBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *catalogLabel;//书名
    UITableView *catalogLists;//目录列表
    EPubViewController *epubViewController;
    EPubPageView *epubPageView;
    
    EPub *epub;
}
@property (nonatomic,retain) UILabel *catalogLabel;
@property (nonatomic,retain) UITableView *catalogLists;
@property (nonatomic,retain) EPubViewController *epubViewController;
@property (nonatomic,retain) EPubPageView *epubPageView;
@property (nonatomic,retain) EPub *epub;

@end
