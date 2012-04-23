//
//  UIButton_CreateHelper.h
//  iPodMenuPlus
//
//  Created by loufq on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(CreateHelp)
+(UIButton*)node;
+(UIButton*)nodeWithTitle:(NSString*)aTitle;
+(UIButton*)nodeWithTitle:(NSString*)aTitle image:(UIImage*)image;
+(UIButton*)nodeWithOnImage:(UIImage*)onImage offImage:(UIImage*)offImage;
+(UIButton*)nodeWithTitle:(NSString *)aTitle onImage:(UIImage*)onImage offImage:(UIImage*)offImage;

//scaleMe2D
+(UIButton*)nodeScaleMe2D;
+(UIButton*)nodeScaleMe2DWithTitle:(NSString*)aTitle;
+(UIButton*)nodeScaleMe2DWithTitle:(NSString*)aTitle image:(UIImage*)image;
+(UIButton*)nodeScaleMe2DWithOnImage:(UIImage*)onImage offImage:(UIImage*)offImage;
+(UIButton*)nodeScaleMe2DWithTitle:(NSString *)aTitle onImage:(UIImage*)onImage offImage:(UIImage*)offImage;


-(void)addScaleMe2DAnimation;
-(void)addEvent:(SEL)aSel atContainer:(NSObject*)aParent;
-(void)setTitleForAllStatus:(NSString*)aText;
-(NSString*)title;
@end