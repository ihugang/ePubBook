//
//  AppShare.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppShare.h"

@implementation AppShare
static AppShare* curInstans;
@synthesize isLandscape,ePub;
- (void)dealloc
{
    self.ePub = nil;
    
    [super dealloc];
}
+(AppShare*)getInstans{
    if (curInstans==nil) {
        curInstans = [[AppShare alloc] init];
    }
    return curInstans;
}

-(EPub*)ePub{
    if (!ePub) {
         ePub = [[EPub sharedEpub] retain];
    } 
    return ePub;
}





@end
