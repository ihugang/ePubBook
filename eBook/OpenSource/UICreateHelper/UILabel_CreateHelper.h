//
//  UILabel_CreateHelper.h
//  iPodMenuPlus
//
//  Created by loufq on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(CreateHelp)
+(UILabel*)node;
+(UILabel*)nodeWithString:(NSString*)aString;
+(UILabel*)nodeWithString:(NSString *)txt font:(UIFont*)font;
+(UILabel*)nodeWithString:(NSString *)txt font:(UIFont*)font size:(CGSize)size;
@end
