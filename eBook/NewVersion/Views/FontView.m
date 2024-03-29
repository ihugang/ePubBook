//
//  FontView.m
//  eBook
//
//  Created by LiuWu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontView.h"
#import <QuartzCore/QuartzCore.h>
#import "Book.h"
#import "ContentView.h"
#import "Chapter.h"

@implementation FontView
@synthesize curPageIndex,curChapterIndex,curChapterPageIndex;

- (void)dealloc {
    [curPageIndex release];curPageIndex = nil;
    [curChapterIndex release];curChapterIndex = nil;
    [curChapterPageIndex release];curPageIndex = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendPageToBookMark" object:nil];
    [super dealloc];
}

-(void)initLayout
{
    CALayer *layer = [CALayer layer];
//    layer.borderColor = [UIColor blackColor].CGColor;
//    layer.borderWidth = 1;
    layer.cornerRadius = 10.0;//设置圆角
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.frame = CGRectMake(10, 20,self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:layer];
    
    CALayer *imageLayer =[CALayer layer];
    imageLayer.frame = CGRectMake(38, -17,40, 20);
    imageLayer.cornerRadius =10.0;
    imageLayer.contents =(id)skinImage(@"fontbar/jiantou.png").CGImage;
    imageLayer.masksToBounds =YES;
    [layer addSublayer:imageLayer];
    
    //亮度设置View
    UIView *brightness = [[[UIView alloc] initWithFrame:CGRectMake(20, 25, self.bounds.size.width - 20, 40)] autorelease];
    [self addSubview:brightness];
    
    UIImageView *min = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 15, 15)] autorelease];
    [min setImage:skinImage(@"fontbar/c003.png")];
    [brightness addSubview:min];
    
    UIImageView *max = [[[UIImageView alloc] initWithFrame:CGRectMake(brightness.bounds.size.width - 20, 10, 20, 20)] autorelease];
    [max setImage:skinImage(@"fontbar/c004.png")];
    [brightness addSubview:max];
    
    sliderA=[[UISlider alloc]initWithFrame:CGRectMake(20, 8, brightness.bounds.size.width - 40, 0)];
    sliderA.backgroundColor = [UIColor clearColor];
    sliderA.value= 1 - [[[NSUserDefaults standardUserDefaults] valueForKey:@"bookBrightness"] floatValue];
    sliderA.minimumValue=0.2;
    sliderA.maximumValue=1.0;
    //左右轨的图片
    UIImage *stetchLeftTrack= skinImage(@"fontbar/c005.png");
    UIImage *stetchRightTrack = skinImage(@"fontbar/c006.png");
    [sliderA setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [sliderA setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //滑块图片
    UIImage *thumbImage = skinImage(@"fontbar/c006-1.png");
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [sliderA setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [sliderA setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [sliderA addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
//    [sliderA addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [brightness addSubview:sliderA];
    
    UIImageView *fenge = [[[UIImageView alloc] initWithFrame:CGRectMake(10,self.bounds.size.height/2 + 20,self.bounds.size.width,1)] autorelease];
    [fenge setImage:skinImage(@"catalogbar/h005.png")];
    [self addSubview:fenge];
    
    UIImageView *font = [[[UIImageView alloc] initWithFrame:CGRectMake(30,self.bounds.size.height/2 + 30,self.bounds.size.width - 40,30)] autorelease];
    [font setImage:skinImage(@"fontbar/c007.png")];
    [font setUserInteractionEnabled:YES];
    [self addSubview:font];
    
//    UIButton *minButton = [UIButton nodeWithOnImage:skinImage(@"fontbar/c008-选中.png") offImage:skinImage(@"fontbar/c008.png")];
    minButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [minButton setBackgroundImage:skinImage(@"fontbar/c008.png") forState:UIControlStateNormal];
    [minButton setFrame:CGRectMake(1,1,(font.bounds.size.width-4)/3,font.bounds.size.height-2)];
    [minButton setTitle:@"小字" forState:UIControlStateNormal];
    [minButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [minButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [minButton setTag:100];
    [minButton addTarget:self action:@selector(fontSelect:) forControlEvents:UIControlEventTouchUpInside];
    [font addSubview:minButton];
    
//    UIButton *middleButton = [UIButton nodeWithOnImage:skinImage(@"fontbar/c009-选中.png") offImage:skinImage(@"fontbar/c009.png")];
    middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleButton setBackgroundImage:skinImage(@"fontbar/c009.png") forState:UIControlStateNormal];
    [middleButton setFrame:CGRectMake((font.bounds.size.width-4)/3+2,1,(font.bounds.size.width-4)/3,font.bounds.size.height-2)];
    [middleButton setTitle:@"中字" forState:UIControlStateNormal];
    [middleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [middleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [middleButton setTag:101];
    [middleButton addTarget:self action:@selector(fontSelect:) forControlEvents:UIControlEventTouchUpInside];
    [font addSubview:middleButton];
    
    //UIButton *maxButton = [UIButton nodeWithOnImage:skinImage(@"fontbar/c010-选中.png") offImage:skinImage(@"fontbar/c010.png")];
    maxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maxButton setBackgroundImage:skinImage(@"fontbar/c010.png") forState:UIControlStateNormal];
    [maxButton setFrame:CGRectMake((font.bounds.size.width-4)/3 *2 +3,1,(font.bounds.size.width-4)/3,font.bounds.size.height-2)];
    [maxButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [maxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [maxButton setTitle:@"大字" forState:UIControlStateNormal];
    [maxButton setTag:102];
    [maxButton addTarget:self action:@selector(fontSelect:) forControlEvents:UIControlEventTouchUpInside];
    [font addSubview:maxButton];
    
    UIImageView *line = [[[UIImageView alloc] initWithFrame:CGRectMake((font.bounds.size.width-4)/3+1,0,1,font.bounds.size.height)] autorelease];
    [line setImage:skinImage(@"fontbar/按钮间隔线.png")];
    [font addSubview:line];
    
    UIImageView *line1 = [[[UIImageView alloc] initWithFrame:CGRectMake((font.bounds.size.width-4)/3*2+2,0,1,font.bounds.size.height)] autorelease];
    [line1 setImage:skinImage(@"fontbar/按钮间隔线.png")];
    [font addSubview:line1];
    
    //判断默认旋转的是那一个字体
    float fontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:@"bodyFontSize"] floatValue];
    if (fontSize == 28) {
        [minButton setBackgroundImage:skinImage(@"fontbar/c008-选中.png") forState:UIControlStateNormal];
    }else if(fontSize == 36)
    {
        [middleButton setBackgroundImage:skinImage(@"fontbar/c009-选中.png") forState:UIControlStateNormal];
    }else {
        [maxButton setBackgroundImage:skinImage(@"fontbar/c010-选中.png") forState:UIControlStateNormal];
    }
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float fBrightness = 1- slider.value;
//    NSLog(@"sliderValueChanged:%.1f",fBrightness);
    //保存设置的屏幕亮度
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",fBrightness] forKey:@"bookBrightness"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //发送通知，就是说此时要调用观察者处的方
    [[NSNotificationCenter defaultCenter] postNotificationName:@"brightness" object:[NSString stringWithFormat:@"%.1f",fBrightness]];
    //设置当前屏幕亮度
//    [[UIScreen mainScreen] setWantsSoftwareDimming:YES];
//    [[UIScreen mainScreen] setBrightness:fBrightness];
}

- (void)sliderDragUp:(id)sender
{
    
}

//获取当前页面所在的html和在html的第几页
- (void)getPages
{
    int tempSpineIndex = 0;//HTML
    int tempPageIndex = 0;//Page
    
    int perTotalIndex = 0;//temp
    int curTotalIndex = 0;//temp
    for (Chapter* chapter in curBook.chapters) {   
        curTotalIndex += chapter.pageCount;
        if (self.curPageIndex.intValue >=perTotalIndex && self.curPageIndex.intValue <curTotalIndex) {
            tempPageIndex = self.curPageIndex.intValue - perTotalIndex;
            break;
        }
        perTotalIndex=curTotalIndex;
        tempSpineIndex++;
    }
    self.curChapterIndex = [NSString stringWithFormat:@"%d",tempSpineIndex];
    self.curChapterPageIndex = [NSString stringWithFormat:@"%d",tempPageIndex];
    DebugLog(@"FontView -------------> chapter:%@   Page: %@ ",curChapterIndex,curChapterPageIndex);
}

//获取当前Chapter之前的chapter中的页面数量
- (NSInteger)getNowPageIndex
{
    int allpage = 0;
    Chapter *chapter ;
    for (int i = 0; i < curChapterIndex.intValue; i ++) {
        if (curChapterIndex.intValue == 0) {
            allpage = 0;
        }else {
            chapter = [curBook.chapters objectAtIndex:i];
            allpage += chapter.pageCount;
        }
    }
    DebugLog(@"getNowPageIndex: ---- %d",allpage);
    return allpage;
}

- (void)fontSelect:(id)sender
{
    UIButton *select = (UIButton *)sender;
    NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
    //设置当前页面
    self.curPageIndex = npageIndex;
    NSLog(@" npageIndex --> %@",npageIndex);
    
    [self getPages];
//    NSInteger before = [self getNowPageIndex];
    //获取当前页面的p index 和 Auto Index
    NSString *curNowPageIndex = [NSString stringWithFormat:@"%d",self.curChapterPageIndex.intValue];
    NSString *nowParaIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"ParaIndex"]; 
    NSString *nowAtomIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"AtomIndex"]; 
    
    DebugLog(@"FontView ---->P: %@   a: %@",nowParaIndex,nowAtomIndex);
    
//    DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
//    NSString *pIndex = nil;
    if (select.tag == 100) {
        [minButton setBackgroundImage:skinImage(@"fontbar/c008-选中.png") forState:UIControlStateNormal];
        [middleButton setBackgroundImage:skinImage(@"fontbar/c009.png") forState:UIControlStateNormal];
        [maxButton setBackgroundImage:skinImage(@"fontbar/c010.png") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"28" forKey:@"bodyFontSize"];
        //写入数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        [curBook prepareBook];
//        pIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue+before];
        
        [[NSUserDefaults standardUserDefaults] setValue:iphone_min forKey:@"currentPageIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FontChange" object:iphone_min];
        
        
    }else if(select.tag == 101){
        [minButton setBackgroundImage:skinImage(@"fontbar/c008.png") forState:UIControlStateNormal];
        [middleButton setBackgroundImage:skinImage(@"fontbar/c009-选中.png") forState:UIControlStateNormal];
        [maxButton setBackgroundImage:skinImage(@"fontbar/c010.png") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"36" forKey:@"bodyFontSize"];
        //写入数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        [curBook prepareBook];
//        pIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue+before];
        
        [[NSUserDefaults standardUserDefaults] setValue:iphone_mid forKey:@"currentPageIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FontChange" object:iphone_mid];
        
        
    }else {
        [minButton setBackgroundImage:skinImage(@"fontbar/c008.png") forState:UIControlStateNormal];
        [middleButton setBackgroundImage:skinImage(@"fontbar/c009.png") forState:UIControlStateNormal];
        [maxButton setBackgroundImage:skinImage(@"fontbar/c010-选中.png") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"44" forKey:@"bodyFontSize"];
        //写入数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        [curBook prepareBook];
//        pIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue+before];
        
        [[NSUserDefaults standardUserDefaults] setValue:iphone_max forKey:@"currentPageIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FontChange" object:iphone_max];
    }
    
//    DebugLog(@"FontView =========>P:%@",pIndex);
    
    //发送通知，就是说此时要调用观察者处的方
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageLoad" object:[NSString stringWithFormat:@"%d",select.tag]];
    
}

@end
