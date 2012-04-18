//
//  Chapter.h
//  EBooks
//
//  Created by LiuWu on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Chapter;

@protocol ChapterDelegate <NSObject>
@required
- (void) chapterDidFinishLoad:(Chapter*)chapter;
@end

@interface Chapter : NSObject<UIWebViewDelegate>
{
    NSString *spinePath;
    NSString *title;
	NSString *text;
    id <ChapterDelegate> delegate;
    int pageCount;
    int chapterIndex;
    CGRect windowSize;
    int fontPercentSize;
}
@property (nonatomic, assign) id delegate;

@property (nonatomic, readonly) int pageCount, chapterIndex, fontPercentSize;
@property (nonatomic, readonly) NSString *spinePath, *title, *text;
@property (nonatomic, readonly) CGRect windowSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;
- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize;

@end
