//
//  Bussicess.m
//  eBook
//
//  Created by loufq on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Bussicess.h"
#import "AllHeader.h"
#import "Book.h"
@implementation Bussicess

+(void)fetchBookInfo:(BKBlock)info{
 
    //提示下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ 
		dispatch_async(dispatch_get_main_queue(), ^{ 
		});  
        [[Book sharedInstance] prepareBook];
 
		//解压代码 
		dispatch_async(dispatch_get_main_queue(), ^{
			   info(); 
		});
	});
    
}


@end
