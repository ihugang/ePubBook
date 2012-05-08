//
//  SearchResult.m
//  AePubReader
//
//  Created by Federico Frappi on 05/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "Book.h"

@implementation SearchResult

@synthesize pageIndex, chapterIndex,chapterPageIndex,neighboringText, hitIndex, originatingQuery;

- initWithChapterIndex:(int)theChapterIndex pageIndex:(int)thePageIndex hitIndex:(int)theHitIndex neighboringText:(NSString*)theNeighboringText originatingQuery:(NSString*)theOriginatingQuery{
    if((self=[super init])){
        chapterIndex = theChapterIndex;
        pageIndex = thePageIndex +1;
        hitIndex = theHitIndex;
        self.neighboringText = [theNeighboringText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.originatingQuery = theOriginatingQuery;
        
        int page = 0;
        for (int i= 0; i < chapterIndex; i++) {
            page += [[curBook.chapters objectAtIndex:i] pageCount];
        }
        chapterPageIndex = page+pageIndex;
        DebugLog(@"searchResult pagecout -----> %d",page+pageIndex);
    }
    return self;
}

- (void)dealloc {
    [neighboringText release];
	[originatingQuery release];
    [super dealloc];
}

@end
