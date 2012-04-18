//
//  EPub.h
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPub : NSObject
{
    NSString *title;
    NSArray *spineArray;//目录数组
    NSArray *spineIndexArray;//目录页码
	NSString *epubFilePath;
}
@property(nonatomic, retain) NSArray *spineArray;
@property(nonatomic,retain) NSArray *spineIndexArray;
@property(nonatomic,retain) NSString *title;

- (id)initWithEPub:(NSString *)path;

+ (EPub *)sharedEpub;

@end
