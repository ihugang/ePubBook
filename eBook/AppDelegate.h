//
//  AppDelegate.h
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eBookViewController.h"
#import "RootVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    eBookViewController *eBook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootVC *rootVC;

@end
