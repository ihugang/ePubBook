//
//  Tags.m
//  HTMLParseSelectionDemo
//
//  Created by loufq on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tags.h"

@implementation Tags
@synthesize className,text;

+(id)createWithClassName:(NSString*)className text:(NSString*)text{
    Tags* tag =[[[Tags alloc] init] autorelease];
    tag.className = className;
    tag.text = text;
    return tag;
}
@end
