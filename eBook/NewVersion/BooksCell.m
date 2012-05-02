//
//  BooksCell.m
//  eBook
//
//  Created by LiuWu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BooksCell.h"

@implementation BooksCell
@synthesize bookIcon,bookName,bookAbout;

- (id)init
{
    [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        self.backgroundColor = [UIColor clearColor];
        
        int height = self.bounds.size.height ;
        int width = self.bounds.size.width;
        UIFont*  font = [UIFont systemFontOfSize:14.0];
        
        bookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,height - 20, height - 20)];
        [bookIcon setBackgroundColor:[UIColor clearColor]];
        [bookIcon setAutoresizesSubviews:YES];
        [bookIcon setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [self addSubview:bookIcon];
        
        bookName = [[UILabel alloc] initWithFrame:CGRectMake(height, 10, width - height, 25)];
        [bookName setBackgroundColor:[UIColor clearColor]];
        [bookName setFont:[UIFont systemFontOfSize:20.0]];
        [bookName setAutoresizesSubviews:YES];
        [bookName setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [self addSubview:bookName];
        
        bookAbout = [[UILabel alloc] init];
        [bookAbout setFrame:CGRectMake(height, 40, width - height-20, 44)];
        [bookAbout setNumberOfLines:0];//必须写，让label可以自动换行
        [bookAbout setBackgroundColor:[UIColor clearColor]];
        [bookAbout setFont:font];
        [bookAbout setAutoresizesSubviews:YES];
        [bookAbout setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [self addSubview:bookAbout];
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
