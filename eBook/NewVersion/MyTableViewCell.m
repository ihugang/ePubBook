//
//  MyTableViewCell.m
//  eBook
//
//  Created by LiuWu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
@synthesize date,number,content;

- (id)init
{
    [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        self.backgroundColor = [UIColor clearColor];
        
        int height = 25 ;
        UIFont*  font = [UIFont systemFontOfSize:14.0];
        
        date = [[UILabel alloc] init];
        [date setFrame:CGRectMake(25, 5, 250, height)];
        [date setFont:font];
        [date setBackgroundColor:[UIColor clearColor]];
        [date setAutoresizesSubviews:YES];
        [date setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:date];
        
        number = [[UILabel alloc] init];
        [number setFrame:CGRectMake(self.bounds.size.width - 80, 5, 50, height)];
        [number setFont:font];
        [number setBackgroundColor:[UIColor clearColor]];
        [number setTextAlignment:UITextAlignmentRight];
        [number setAutoresizesSubviews:YES];
        [number setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:number];
        
        content = [[UILabel alloc] init];
        [content setFrame:CGRectMake(25, height + 15, self.bounds.size.width - 40, 50)];
        [content setNumberOfLines:0];//必须写，让label可以自动换行
        [content setBackgroundColor:[UIColor clearColor]];
        [content setFont:font];
        [content setAutoresizesSubviews:YES];
        [content setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
//        content.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:content];
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
