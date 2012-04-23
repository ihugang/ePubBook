//
//  UIAlertView+SCMethods.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 3/14/10.
//	aleks.nesterow@gmail.com
//
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "UIAlertView+SCMethods.h"


@interface UIAlertView(P)
+(NSString*)getLocString:(NSString*)aText;
@end


@implementation UIAlertView (SCMethods)

+ (UIAlertView *)alertViewFromError:(NSError *)error {
  
    
    
  UIAlertView *result = [[[UIAlertView alloc] initWithTitle:[error localizedFailureReason]
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:[self getLocString:@"确定"]
                                          otherButtonTitles:nil] autorelease];
  return result;
}

+ (void)showWithError:(NSError *)error {
  [[[[UIAlertView alloc] initWithTitle:[self getLocString:@"错误"]
                               message:[error localizedDescription]
                              delegate:nil
                     cancelButtonTitle:[self getLocString:@"确定"]
                     otherButtonTitles:nil] autorelease] show];
}

+ (void)showWithErrorNO400:(NSError *)error
{
    if(error.code != 400){
        [[[[UIAlertView alloc] initWithTitle:[self getLocString:@"错误"]
                                     message:[error localizedDescription]
                                    delegate:nil
                           cancelButtonTitle:[self getLocString:@"确定"]
                           otherButtonTitles:nil] autorelease] show];
    }
}

+ (void)showWithMessage:(NSString *)message {
  
  [[[[UIAlertView alloc] initWithTitle:nil
                               message:message
                              delegate:nil
                     cancelButtonTitle:[self getLocString:@"确定"]
                     otherButtonTitles:nil] autorelease] show];
}

+ (void)showWithTitle:(NSString *)title {
  
  [[[[UIAlertView alloc] initWithTitle:title
                               message:nil
                              delegate:nil
                     cancelButtonTitle:[self getLocString:@"确定"]
                     otherButtonTitles:nil] autorelease] show];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
  
  [[[[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:[self getLocString:@"确定"]
                     otherButtonTitles:nil] autorelease] show];
}


+ (void)showWithTitle:(NSString *)title message:(NSString *)message error:(NSError *)error {
  NSString *messageWithError = message;
  if (error) {
    messageWithError = [NSString stringWithFormat:@"%@\n(%@)", message, [error localizedDescription]];
  }
  return [self showWithTitle:title message:messageWithError];
}

+ (void)showSysInfoWithMessage:(NSString *)message {
    return [self showWithTitle:[self getLocString:@"系统信息"] message:message];
}

+(NSString*)getLocString:(NSString*)aText{ 
    return aText;
}


@end
