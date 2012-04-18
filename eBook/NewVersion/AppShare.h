//
//  AppShare.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPub.h"

#define share ([AppShare getInstans])

@interface AppShare : NSObject

+(AppShare*)getInstans;


@property(nonatomic,retain)  EPub* ePub;


@property(nonatomic,assign)  BOOL isLandscape;

@end
