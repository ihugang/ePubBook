//
//  AppDelegate.m
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "AppShare.h"
#import "ResManager.h"
#import "DemoDataParse.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootVC;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /*
     解析成plist
     [DemoDataParse parse];
     return YES;
     */
    NSLog(@"didFinishLaunchingWithOptions");
    
    application.statusBarHidden=NO;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (YES) {
        self.rootVC = [[RootVC alloc] init];
        self.window.rootViewController = rootVC;
    }
    else{
        eBook = [[[eBookViewController alloc] init] autorelease];
        self.window.rootViewController = eBook;
    }
    [self.window makeKeyAndVisible];
    
    NSLog(@"self %f,%f",self.window.bounds.size.width,self.window.bounds.size.height);
    
    brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [brightnessView setBackgroundColor:[UIColor blackColor]];
    [brightnessView setUserInteractionEnabled:NO];
    [self.window addSubview:brightnessView];
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlphaBrightness:) name:@"brightness" object:nil];
    
    return YES;
}

- (void) setAlphaBrightness:(NSNotification*) notification
{
    NSLog(@"test ---- .> %@",[notification object]);
    //通过这个获取到传递的对象
    [brightnessView setAlpha:[[notification object] floatValue]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    float winBrightness = [[[NSUserDefaults standardUserDefaults] valueForKey:@"winBrightness"] floatValue];
//    NSLog(@"winBrightness ---> %.1f",winBrightness);
//    [[UIScreen mainScreen] setBrightness:winBrightness];
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    float winBrightness = [[[NSUserDefaults standardUserDefaults] valueForKey:@"winBrightness"] floatValue];
//    NSLog(@"winBrightness ---> %.1f",winBrightness);
//    [[UIScreen mainScreen] setBrightness:winBrightness];
    
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    NSLog(@"winBrightness----%.1f",[[UIScreen mainScreen] brightness]);    
    float winBrightness = [[UIScreen mainScreen] brightness];
    //记录屏幕当前亮度
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",winBrightness] forKey:@"winBrightness"];
    //第一次进入，
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] == nil) {
        NSLog(@"first enter");
        //设置系统当前亮度
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",winBrightness] forKey:@"bookBrightness"];
        [brightnessView setAlpha:1 - [[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]];//设置alpha值
    }
    NSLog(@"nowbightness -- %f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]);
    //设置应用系统亮度
    //[[UIScreen mainScreen] setBrightness:[[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]];
    
    
    [brightnessView setAlpha:[[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]];//设置alpha值
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}

@end
