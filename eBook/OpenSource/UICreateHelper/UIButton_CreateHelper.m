//
//  UIButton_CreateHelper.m
//  iPodMenuPlus
//
//  Created by loufq on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIButton_CreateHelper.h"
#import "UIView+Size.h"
#import "UIControl+BlocksKit.h"
#import "UIView+Motion.h"
#import "MacroFunctions.h"

@implementation UIButton(CreateHelp)

+(UIButton*)node{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}
+(UIButton*)nodeWithTitle:(NSString*)aTitle{
    return [self nodeWithTitle:aTitle onImage:nil offImage:nil];
}
+(UIButton*)nodeWithOnImage:(UIImage*)onImage offImage:(UIImage*)offImage{
    return [self nodeWithTitle:nil onImage:onImage offImage:offImage];
}

+(UIButton*)nodeWithTitle:(NSString*)aTitle image:(UIImage*)image{
    return [self nodeWithTitle:aTitle onImage:nil offImage:image];
    
}


+(UIButton*)nodeWithTitle:(NSString*)aTitle onImage:(UIImage*)onImage offImage:(UIImage*)offImage{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
 
//    DebugLog(@"----- %f  ,----  %f",offImage.size.width,offImage.size.height);
    btn.size = CGSizeMake(offImage.size.width, offImage.size.height);
    [btn setTitle:aTitle forState:UIControlStateNormal];
 
    
    if (mf_IsPad) {
        btn.size = CGSizeMake(offImage.size.width/2, offImage.size.height/2);
    } else {
        btn.size = CGSizeMake(offImage.size.width/2, offImage.size.height/2);
    }
    
    [btn setTitleForAllStatus:aTitle];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (offImage) {
        [btn setBackgroundImage:offImage forState:UIControlStateNormal];  
        
    }
    
    if (onImage) {
        [btn setBackgroundImage:onImage forState:UIControlStateSelected];     
        [btn setBackgroundImage:onImage forState:UIControlStateHighlighted];  
    }
    
    
    return btn;
}

//scaleMe2D
+(UIButton*)nodeScaleMe2D{
    UIButton* btn = [self node];
    [btn addScaleMe2DAnimation];
    return btn;
}
+(UIButton*)nodeScaleMe2DWithTitle:(NSString*)aTitle{
    UIButton* btn = [self nodeWithTitle:aTitle];
    [btn addScaleMe2DAnimation];
    return btn;
}
+(UIButton*)nodeScaleMe2DWithTitle:(NSString*)aTitle image:(UIImage*)image{
    UIButton* btn = [self nodeWithTitle:aTitle image:image];
    [btn addScaleMe2DAnimation];
    return btn;
}
+(UIButton*)nodeScaleMe2DWithOnImage:(UIImage*)onImage offImage:(UIImage*)offImage{
    UIButton* btn = [self nodeWithOnImage:onImage offImage:offImage];
    [btn addScaleMe2DAnimation];
    return btn;
}
+(UIButton*)nodeScaleMe2DWithTitle:(NSString *)aTitle onImage:(UIImage*)onImage offImage:(UIImage*)offImage{
    UIButton* btn = [self nodeWithTitle:aTitle onImage:onImage offImage:offImage];
    [btn addScaleMe2DAnimation];
    return btn;
}

-(void)addScaleMe2DAnimation{
    [self addEventHandler:^(id sender) {
        [self scaleMe2D];
    } forControlEvents:UIControlEventTouchUpInside];
}

-(void)addEvent:(SEL)aSel atContainer:(NSObject*)aParent{
    [self addTarget:aParent action:aSel forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setTitleForAllStatus:(NSString*)aText{
    [self setTitle:aText forState:UIControlStateNormal];
    [self setTitle:aText forState:UIControlStateSelected];
    [self setTitle:aText forState:UIControlStateHighlighted];
    [self setTitle:aText forState:UIControlStateDisabled]; 
}
-(NSString*)title{
    return [self titleForState:UIControlStateNormal];
}


@end
