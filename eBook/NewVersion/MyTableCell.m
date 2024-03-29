//
//  MyTableCell.m
//  eBook
//
//  Created by LiuWu on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTableCell.h"

@implementation MyTableCell
@synthesize index,content;

- (id)init
{
    [super init];
    if (self) {
//        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, 110)];
        self.backgroundColor = [UIColor clearColor];
        
        int height = 25 ;
        UIFont*  font = [UIFont systemFontOfSize:14.0];

        content = [[UILabel alloc] init];
        [content setFrame:CGRectMake(20, 10 , self.bounds.size.width - 60, height)];
//        [content setNumberOfLines:0];//必须写，让label可以自动换行
        [content setBackgroundColor:[UIColor clearColor]];
        [content setFont:font];
        [content setAutoresizesSubviews:YES];
        [content setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        //        content.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:content];
        
        index = [[UILabel alloc] init];
        [index setFrame:CGRectMake(self.bounds.size.width - 50, 10, 30, height)];
        [index setFont:font];
        [index setBackgroundColor:[UIColor clearColor]];
        [index setTextAlignment:UITextAlignmentRight];
        [index setAutoresizesSubviews:YES];
        [index setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:index];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
