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
    
    NSString *test = @"甚至屈辱，心中充满了感慨。特别是进入南美，非洲一些国家的边境，都经常有看到中国人被";
    NSString *all = @"因持美国护照，李老胜进出的大部分国家不需要签证。美国护照在旅游时确实很方便，很多国家都可以落地签证。美国公民在有些国家备受尊重，而在仇视美国地区我一定声明自己是中国人，这方面的确给我带来一些便利。我进关时往往填单是自由撰稿人旅行作家或教师。当我望着同机下来的其他通关的华人同胞，有些甚至是头等舱名人，因持中国或台湾护照，被讨厌的海关人员问过来查过去，凭空增添麻烦甚至屈辱，心中充满了感慨。特别是进入南美，非洲一些国家的边境，都经常有看到中国人被搜身的经历。当飞机载着各国旅客到达时，乘客有欧洲人、北美人、日本人、韩国人、印度人等等。他们带着行李，总能顺利通过目的地国的边境，而很少受到盘问和搜身。但机场边境警察每每遇见疑似中国人模样的着陆客，就把他们叫到一旁，要求他们出示护照。当确认这些人确实不是欧、非美、日、韩、印人，警察就要求开包检查这些“等外”中国人，告诉你的理由是检查行李是否携带毒品。往往此时，一些国人为省得麻烦，一般塞给警察二十美元，也就免却了开包检查和被搜身的“麻烦”。 这样，时间长了，边防警察也就越加习惯于叫住中国人模样的着陆客，依照习惯要求开包检查、搜身，而他国国民则携带各自行李，畅行无阻地入境。这种麻烦已经成了一种顽症，每次航班下来一百多名各国乘客散去之后，就剩那么几个中国人在那里继续接受盘查。看着离去的他国国民，我不得不感到中国人已经沦为这些第三世界的二等公民——成了所谓查验“毒品”的特殊对象。";
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
