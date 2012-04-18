//
//  BaseView.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  显示封装类（横版两页，竖版一页）

#import <UIKit/UIKit.h>

@interface BaseView : UIView{
    
}

+(id)createWithSize:(CGSize)aSize;
-(void)initLayout;


-(void)updateInfo:(NSDictionary*)aInfo;
@end
