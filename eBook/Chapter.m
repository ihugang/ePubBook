//
//  Chapter.m
//  EBooks
//
//  Created by LiuWu on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Chapter.h"
#import "NSString+HTML.h"

@implementation Chapter
@synthesize delegate,chapterIndex, title, pageCount, spinePath, text, windowSize, fontPercentSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        spinePath = [theSpinePath retain];
        title = [theTitle retain];
        chapterIndex = theIndex;
        /* 
		NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:theSpinePath]] encoding:NSUTF8StringEncoding];
		text = [[html stringByConvertingHTMLToPlainText] retain];
        NSLog(@"text ------- >>>>>%@",text);
         
		[html release];
        */
    }
    return self;
}

//根据窗口大小加载页面
- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize
{
    fontPercentSize = theFontPercentSize;
    windowSize = theWindowSize;
    NSLog(@"webviewSize: %f * %f, fontPercentSize: %d", theWindowSize.size.width, theWindowSize.size.height,theFontPercentSize);
    //加载webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:windowSize];
    [webView setDelegate:self];
    //返回加载页面
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:spinePath]];
    [webView loadRequest:urlRequest];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
	[webView dealloc];
}
//加载页面结束后，返回当前文件在webView中显示的页数，和总页数，和显示的样式
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置访问页面的第一个外部样式表
    NSString *varMysheet = @"var mysheet = document.styleSheets[0]";
    //定义一个javascript方法，用来添加css样式
    NSString *addCssRule = @"function addCSSRule(selector,newRule){"
    "if(mysheet.addRule){"
        "mysheet.addRule(selector,newRule);"                                //For IE
    "}else{"
        "ruleIndex = mysheet.cssRules.length;"
        "mysheet.insertRule(selector + '{' + newRule + ';}' , ruleIndex);"  //NS/Firefox
    "}"
    "}";
    NSLog(@"w:%f h:%f", webView.bounds.size.width, webView.bounds.size.height);
    //给页面添加样式
    //根据webView的宽度和高度设置html的寛高
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
    //标题显示位置
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    //设置页面字体
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontPercentSize];
    
    //webView与javascript交互
    [webView stringByEvaluatingJavaScriptFromString:varMysheet];
    [webView stringByEvaluatingJavaScriptFromString:addCssRule];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule1];
    [webView stringByEvaluatingJavaScriptFromString:insertRule2];
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    //获取返回页面的总宽度
    int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    //计算文件的页数
    pageCount = totalWidth / webView.bounds.size.width;
    
    NSLog(@"Chapter %d: title:%@ -> 包含：%d pages", chapterIndex, title, pageCount);
    [webView dealloc];
    [delegate chapterDidFinishLoad:self];
}

- (void)dealloc {
    [title release];
	[spinePath release];
	[text release];
    [super dealloc];
}

@end
