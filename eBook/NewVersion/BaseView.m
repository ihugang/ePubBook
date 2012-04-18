//
//  BaseView.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView


+(id)createWithSize:(CGSize)aSize{
    CGRect frame = CGRectMake(0, 0, aSize.width, aSize.height);
    return [[[self alloc] initWithFrame:frame] autorelease];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    
}

-(void)updateInfo:(NSDictionary*)aInfo{
    
}
@end
