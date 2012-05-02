//
//  BooksCell.h
//  eBook
//
//  Created by LiuWu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@interface BooksCell : UITableViewCell
{
    UIImageView *bookIcon;
    UILabel *bookName;
    UILabel *bookAbout;
}
@property (nonatomic,retain) UIImageView *bookIcon;
@property (nonatomic,retain) UILabel *bookName;
@property (nonatomic,retain) UILabel *bookAbout;

@end
