//
//  UIWebView+Additions.h.m
//  EverPhoto
//
//  Created by loufq on 11-4-16.
//  Copyright 2011 e0571.com. All rights reserved.
//

#import "UIWebView+Additions.h"


@implementation UIWebView (UIWebView_Additions)

-(void)loadWithURLString:(NSString*)aURLString
{
	if ([aURLString length] < 5) {
		return;
	}
	if ([aURLString hasPrefix:@"http://"] == NO && [aURLString hasPrefix:@"https://"] == NO) {
		aURLString = [NSString stringWithFormat:@"http://%@", aURLString];
	}
	NSURL* url =[NSURL URLWithString:aURLString];
	NSURLRequest* req =[NSURLRequest requestWithURL:url];
	[self loadRequest:req];
}
@end
