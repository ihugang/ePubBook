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
    
    NSString *test = @"背运时应该适时地休息，玩扑克是很需要运气的，";
    NSString *all = @"扑克比赛也有很多种变化，而您只需要参加您熟悉的比赛 ，尤其是在玩现金真钱的时候。这将给您最佳的机会去赢得比赛，同时也因为一些显而易见的原因 ，比如说如果您根本不知道如何玩，那您又怎么可能会赢呢。不是说您不可能那么好运，但如果您想要成为一名“常胜将军”，您就非得明明白白地知道自己需要怎么进行比赛。如果您感觉到疲倦或是背运时应该适时地休息，玩扑克是很需要运气的，但同样也不可缺少的是智慧，聪明的玩家才能机智地取胜。这种智慧只能是来源于比赛的积累。您应该认识到是多么应该在低成本的比赛中不断地磨练自己的技巧。同样，明智的您也应该明白在进行这类比赛的同时，尝试不同的扑克玩法是大有益处的。";
    NSRange range = [all rangeOfString:test];
    int location = range.location;
    int leight = range.length;
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Location:%i,Leight:%i",location,leight]];
    NSLog(@"astring:%@",astring);
    
    
    application.statusBarHidden=NO;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (YES) {
        self.rootVC = [[[RootVC alloc] init] autorelease];
        self.window.rootViewController = rootVC;
    }
    else{
        eBook = [[[eBookViewController alloc] init] autorelease];
        self.window.rootViewController = eBook;
    }
    [self.window makeKeyAndVisible];
    
    //检查问价是否存在，拷贝文件到document目录
    NSString *docPath = documentPath;
    DebugLog(@"documentPaht ---> %@",docPath);
    NSString *path = resPath(@"/book");
    DebugLog(@"path --->  %@",path);
    NSString *newPath = [NSString stringWithFormat:@"%@/book",docPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newPath] == NO) {
        //先创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:NO attributes:nil error:nil];
        //拷贝文件
        NSArray *files =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString* obj in files){
            NSError* error;
            if (![[NSFileManager defaultManager] 
                  copyItemAtPath:[path stringByAppendingPathComponent:obj] 
                  toPath:[newPath stringByAppendingPathComponent:obj]
                  error:&error])
                DebugLog(@"%@", [error localizedDescription]);
            DebugLog(@"file --> %@",[path stringByAppendingPathComponent:obj] );
            DebugLog(@"fileto --> %@",[newPath stringByAppendingPathComponent:obj]);
        }
    }else {
        DebugLog(@"files has be copy to document!");
    }
        
    //屏幕亮度控制
    brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [brightnessView setBackgroundColor:[UIColor blackColor]];
    [brightnessView setUserInteractionEnabled:NO];
    [self.window addSubview:brightnessView];
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlphaBrightness:) name:@"brightness" object:nil];
    
    return YES;
}

//获取某文件夹下的所有文件
-(NSArray*)GetFilesName:(NSString*)path
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    NSArray *files = [fileManager subpathsAtPath: path ];
    return  files;
}


- (void) setAlphaBrightness:(NSNotification*) notification
{
//    NSLog(@"test ---- .> %@",[notification object]);
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
//    NSLog(@"applicationDidBecomeActive");
//    NSLog(@"winBrightness----%.1f",[[UIScreen mainScreen] brightness]);    
//    float winBrightness = [[UIScreen mainScreen] brightness];
    defaults = [NSUserDefaults standardUserDefaults];
    //记录屏幕当前亮度
//    [defaults setValue:[NSString stringWithFormat:@"%.1f",winBrightness] forKey:@"winBrightness"];
    [defaults synchronize];//写入数据
    //第一次进入，
    if ([defaults valueForKey:@"bookBrightness"] == nil) {
        NSLog(@"first enter");
        //设置系统当前亮度
        [defaults setValue:[NSString stringWithFormat:@"%.1f",0.0] forKey:@"bookBrightness"];
        [defaults synchronize];//写入数据
        //[brightnessView setAlpha:[[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]];//设置alpha值
    }
    
    //设置第一次运行程序的字体
    if ([defaults valueForKey:@"bodyFontSize"] == nil) {
        NSLog(@"first set fontsize");
        [defaults setValue:@"28" forKey:@"bodyFontSize"];
        [defaults synchronize];//写入数据
    }
    
    NSLog(@"nowbightness -- %f",[[defaults valueForKey:@"bookBrightness"] floatValue]);
    //设置应用系统亮度
    //[[UIScreen mainScreen] setBrightness:[[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue]];
    
    
    [brightnessView setAlpha:[[defaults valueForKey:@"bookBrightness"] floatValue]];//设置alpha值
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}

@end
