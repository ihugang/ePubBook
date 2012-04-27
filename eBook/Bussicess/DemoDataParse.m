//
//  DemoDataParse.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DemoDataParse.h"
#import "TouchXML.h"

@interface DemoDataParse()
- (void) parseWithPath:(NSString*)aPath;
- (void) parseDire:(CXMLDocument *) document;
- (void) parseRoot:(CXMLDocument *) document;
@end


@implementation DemoDataParse


+(void)parseTitles{
    
    
}

+(void)parse{

    DemoDataParse* ssp =[[[DemoDataParse alloc] init] autorelease];
    //NSString* path = resPath(@"PageBreak~iPhone@2x.xml");
    NSString* path = resPath(@"PageBreak~iPad@2x.xml");
    [ssp parseWithPath:path];
}


-(void)parseWithPath:(NSString*)aPath{
    //获得文件路径
    NSString *XMLPath = aPath;
    //取得数据
    NSData *XMLData = [NSData dataWithContentsOfFile:XMLPath];
    //生成CXMLDocument对象
    CXMLDocument *document = [[[CXMLDocument alloc] initWithData:XMLData
                                                        options:0
                                                          error:nil
                              ] autorelease];
    //[self parseDire:document];
    [self parseRoot:document]; 
    
    
}
- (void) parseDire:(CXMLDocument *) document
{
    NSArray *books = NULL;
    books = [document nodesForXPath:@"//PageBreakSet" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
    //
    books = [document nodesForXPath:@"//wp7book" error:nil];
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [element childCount]; i++)
            {
                if ([[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }
            //NSLog(@"%@", item);
        }
    }
}
- (void) parseRoot:(CXMLDocument *) document
{
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];//PageBreakSet(s)
    
    for (CXMLElement *element in books)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            int PageWidth = [[[element attributeForName:@"PageWidth"] stringValue] intValue];
            int PageHeight = [[[element attributeForName:@"PageHeight"] stringValue] intValue];
            int BodyFontSize = [[[element attributeForName:@"BodyFontSize"] stringValue] intValue];
            [item setValue:NI(PageWidth) forKey:@"PageWidth"];
            [item setValue:NI(PageHeight) forKey:@"PageHeight"];
            [item setValue:NI(BodyFontSize) forKey:@"BodyFontSize"];
            DebugLog(@"PageBreakSet:%d-%d-%d",PageWidth,PageHeight,BodyFontSize);
            NSArray* PageBreakPoss = element.children;
            NSMutableArray* breaskPosList =[NSMutableArray array];
 
            //
            int perChapterIndex = 0;
            NSMutableArray* chapterPages =[NSMutableArray array];
            
            for (CXMLElement* pos in PageBreakPoss) {
                if ([pos isKindOfClass:[CXMLElement class]])
                {
                    if ([[element name] isEqualToString:@"PageBreakSet"]) 
                    {   NSMutableDictionary *itemBreak = [[NSMutableDictionary alloc] init];
                        int ChapterIndex = [[[pos attributeForName:@"ChapterIndex"] stringValue] intValue];
                        
                        if (perChapterIndex!=ChapterIndex) {//
                            [breaskPosList addObject:chapterPages];
                             chapterPages =[NSMutableArray array];
                            perChapterIndex = ChapterIndex;
                        } 
                        int ParaIndex = [[[pos attributeForName:@"ParaIndex"] stringValue] intValue];
                        int AtomIndex = [[[pos attributeForName:@"AtomIndex"] stringValue] intValue];
                        [itemBreak setValue:NI(ChapterIndex) forKey:@"ChapterIndex"];
                        [itemBreak setValue:NI(ParaIndex) forKey:@"ParaIndex"];
                        [itemBreak setValue:NI(AtomIndex) forKey:@"AtomIndex"];
                        [chapterPages addObject:itemBreak];
                        DebugLog(@"PageBreakPos:%d-%d-%d", ChapterIndex,ParaIndex,AtomIndex);
                    }
                }
            }
            [item setValue:breaskPosList forKey:@"PageBreakSet"]; 
            [item writeToFile:[ResManager docPath:@"PageBreak~iPad@2x.plist" forSave:YES] atomically:YES];
            break;//demo just get one
        }
    }
}
@end
