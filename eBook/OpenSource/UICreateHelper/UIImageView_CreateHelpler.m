//
//  UIImageView_CreateHelpler.m
//  iPodMenuPlus
//
//  Created by loufq on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImageView_CreateHelpler.h"
#import "UIView+Size.h"
#import "MacroFunctions.h"

@implementation UIImageView(CreateHelp)
+(UIImageView*)node{
    UIImageView* iv =[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
    return iv;
}

+(UIImageView*)nodeWithImage:(UIImage*)image{
    UIImageView* iv =[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
    if (mf_IsPad) {
         iv.size = CGSizeMake(image.size.width, image.size.height);    
    }
    else{
        iv.size = CGSizeMake(image.size.width/2, image.size.height/2);    
    }
    iv.image = image;
    return iv;
}
@end
