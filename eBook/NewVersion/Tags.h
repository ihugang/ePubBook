//
//  Tags.h
//  HTMLParseSelectionDemo
//
//  Created by loufq on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tags : NSObject

@property(nonatomic,retain)NSString* className;
@property(nonatomic,retain)NSString* text;

+(id)createWithClassName:(NSString*)className text:(NSString*)text;

@end
