//
//  UILabel_CreateHelper.m
//  iPodMenuPlus
//
//  Created by loufq on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UILabel_CreateHelper.h"
#import "UIView+Size.h"

@implementation UILabel(CreateHelp)

+(UILabel*)node{
    return [self nodeWithString:nil];
}

+(UILabel*)nodeWithString:(NSString*)aString{
    UILabel* lbl =[[[UILabel alloc] init] autorelease];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor =[UIColor clearColor];
    lbl.text = aString;
    lbl.size =[aString sizeWithFont:lbl.font];
    return lbl;
}

+(UILabel*)nodeWithString:(NSString *)txt font:(UIFont*)font{
    UILabel* lbl =[[[UILabel alloc] init] autorelease];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor =[UIColor clearColor];
    lbl.text = txt;
    lbl.font = font;
    lbl.size =[txt sizeWithFont:font];
    return lbl;
}

+(UILabel*)nodeWithString:(NSString *)txt font:(UIFont*)font size:(CGSize)size{
    UILabel* lbl =[[[UILabel alloc] init] autorelease];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor =[UIColor clearColor];
    lbl.text = txt;
    lbl.font = font;
    lbl.size =size;
    return lbl;
}

@end 