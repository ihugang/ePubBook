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
    
    NSString *test = @"明到牌桌上，你可以想象，玩家A的脸色是多么难看。";
    NSString *all = @"无限下注德州扑克(NO-LIMIT)游戏过程中，诈术更加重要。曾经在 5-5 NO-LIMIT牌桌上见过这样一手牌：玩家A是一个中年男人，玩牌比较保守，玩家B为一年轻女孩，玩牌令人琢磨不定。玩家A拿到一张红桃A一张梅花K，玩家B拿到一对2，悬牌前玩家A将赌注加到$50， 玩家B跟注，其它玩家全弃牌。翻开悬牌为Q(红桃)，Q(方块)，K(方块)，玩家A下注$100，玩家B跟注，转牌为一张红桃5，玩家A下注$200，玩家B跟注，河牌为一张红桃6，玩家A下注$200，玩家B将自己全部筹码共$1500全押进去，玩家A要跟注的话，需将自己剩下的大约$800全押进去，玩家A考虑了半天，决定弃牌。玩家B一对2运用恰当的诈术赢了这手牌。 分析：玩家B知道玩家A玩牌比较保守，而自己留给对方的印象是玩牌琢磨不定，这给自己后来的使诈奠定了心理基础。5张共用牌为QQK56，三张为红桃，又有一对Q，这种牌型为自己奠定了使诈的牌型基础，因为这种牌型很容易令对方猜想自己有3个Q或有同花。最后，玩家B桌面上的筹码多于对方，纵然使诈不成，不会全部输光，仍有翻身的机会，所有这一切，为玩家B的使诈创造了极为有利的条件。玩家A最后弃牌投降，的确是因为他相信对方手里有一个Q。后来玩家B将自己的一对小2明到牌桌上，你可以想象，玩家A的脸色是多么难看。";
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
