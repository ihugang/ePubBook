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
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, 110)];
        self.backgroundColor = [UIColor blueColor];
        
        int height = 25 ;
        UIFont*  font = [UIFont systemFontOfSize:14.0];

        content = [[UILabel alloc] init];
        [content setFrame:CGRectMake(15, 20 , self.bounds.size.width - 60, height)];
        [content setNumberOfLines:0];//必须写，让label可以自动换行
        [content setBackgroundColor:[UIColor clearColor]];
        [content setFont:font];
        [content setAutoresizesSubviews:YES];
        [content setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        //        content.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:content];
        
        index = [[UILabel alloc] init];
        [index setFrame:CGRectMake(self.bounds.size.width - 50, 20, 30, height)];
        [index setFont:font];
        [index setBackgroundColor:[UIColor clearColor]];
        [index setTextAlignment:UITextAlignmentRight];
        [index setAutoresizesSubviews:YES];
        [index setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:index];
        
        UILabel *fenge = [[UILabel alloc] init];
        [fenge setFrame:CGRectMake(15, self.bounds.size.height -3, self.bounds.size.width, 1)];
        [fenge setBackgroundColor:[UIColor colorWithPatternImage:skinImage(@"catalogbar/h005.png")]];
        [fenge setAutoresizesSubviews:YES];
        [fenge setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
//        [self addSubview:fenge];

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
