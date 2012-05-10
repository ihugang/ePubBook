//
//  TagsHelper.m
//  HTMLParseSelectionDemo
//
//  Created by loufq on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagsHelper.h"
#import "Tags.h"

@implementation TagsHelper

static TagsHelper* helper;

+(id)sharedInstanse{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TagsHelper alloc] init];
    });
    return helper;
}

-(void)addTagWithClassId:(NSString*)aId txt:(NSString*)aTxt{
 
   NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString* filePath =[docPath stringByAppendingPathComponent:@"PageTags"];
    NSMutableArray* md =[NSMutableArray arrayWithContentsOfFile:filePath];
    if (!md) {
        md =[NSMutableArray array];
    } 
    NSDictionary* dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         aId,@"classId",
                         aTxt,@"text",
                          nil];
    [md addObject:dict];
    [md writeToFile:filePath atomically:YES];
}

-(NSArray*)getTagsInfo{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString* filePath =[docPath stringByAppendingPathComponent:@"PageTags"];
    NSMutableArray* md =[NSMutableArray arrayWithContentsOfFile:filePath];
    NSMutableArray* list = [NSMutableArray array];
    for (NSDictionary* item in md) {
        Tags* t =[Tags createWithClassName:[item objectForKey:@"classId"] text:[item objectForKey:@"text"]];
        [list addObject:t];
    }
    return list; 
}

@end
