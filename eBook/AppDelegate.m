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
    
    NSString *test = @"。游戏形式";
    NSString *all = @"如果你要考虑如何从游戏中获利，就像获得快乐一样。我们最好由限注(limit)Holdem开始，它是初学者的理想之地，固定的赌注结构意味着你可以受到保护而不会只在一局中就损失大量的资金。我该玩什么样的游戏?我需要多少钱才够呢?开始玩的级别取决于你会用多少资金去冒险。我们资金储备(bankroll)的建议，你应该准备250个大注(bb)去玩。那么在网络游戏0.01元/0.02元这样最小的级别中，你只需要5块钱就够了，在0.5元/1元的水平上，你需要250块钱。如果你是个新玩家，这个数字听起来会很多。但请记住这只是对你在短期内手气波动所作出的缓冲资金。如果你读了一些书或文章的话，对你所做的事情有所了解，你会比你的对手更出色，因此会在长期的游戏中获取更大的收益。简言之，这一数字是经过测算确保你不会耗光所有资金得出的，而不是随时让你处于风险边缘的危险数字。假如你要成为真正的赢家而不单单只是为了开心的话，面对不同大小的游戏你一定需要足够资金储备(bankroll)。这种情况下，就得看你能付出多少代价了。游戏形式：";
    NSRange range = [all rangeOfString:test];
    int location = range.location;
    int leight = range.length;
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Location:%i,Leight:%i",location,leight]];
    NSLog(@"astring:%@",astring);
    [astring release];
    
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
