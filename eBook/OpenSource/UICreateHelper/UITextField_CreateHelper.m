//
//  UITextField_CreateHelper.m
//  iMenuPod
//
//  Created by loufq on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UITextField_CreateHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextField(CreateHelp)

+(id)nodeWithSize:(CGSize)aSize{
    UITextField* tf =[[[UITextField alloc] initWithFrame:CGRectMake(0, 0, aSize.width, aSize.height)] autorelease];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.textAlignment = UITextAlignmentCenter;
     tf.keyboardAppearance = UIKeyboardAppearanceDefault;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.adjustsFontSizeToFitWidth =YES;
//    tf.layer.borderWidth = 1;
    tf.layer.cornerRadius = 8;
    [tf setAutocorrectionType:UITextAutocorrectionTypeNo]; 
    [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    return tf;
}

-(void)addInputAccessoryCustomView:(UIView*)aView{
    self.inputAccessoryView = aView;
}

@end