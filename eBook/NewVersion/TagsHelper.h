//
//  TagsHelper.h
//  HTMLParseSelectionDemo
//
//  Created by loufq on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsHelper : NSObject{
    
}




+(id)sharedInstanse;

-(void)addTagWithClassId:(NSString*)aId txt:(NSString*)aTxt;
-(id)getTagsInfo;

@end
