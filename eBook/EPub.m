//
//  EPub.m
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EPub.h"
#import "ZipArchive.h"
#import "TouchXML.h"
#import "Chapter.h"

@interface EPub()

- (void) parseEpub;
- (void) unzipAndSaveFileNamed:(NSString*)fileName;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;

@end


@implementation EPub
@synthesize spineArray,spineIndexArray,title;

static EPub *myEPub = nil;
/*
 单例模式实现方法
 */
+ (EPub *)sharedEpub
{
    @synchronized(self)
    {
        if (myEPub == nil) {
            myEPub = [[self alloc] init];
        }
    }
    return myEPub;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (myEPub == nil) {
            myEPub = [super allocWithZone:zone];
            return myEPub;
        }
    }
    return nil;
}

//初始化
- (id)initWithEPub:(NSURL *)Epubpath
{
    if ((self = [super init])) {
        epubFilePath = [Epubpath path];
        spineArray = [[NSMutableArray alloc] init];
        //开始解析
        [self parseEpub];
    }
    return self;
}

//解析
- (void) parseEpub{
    NSLog(@"epubFilePath:%@",epubFilePath);
	[self unzipAndSaveFileNamed:epubFilePath];//解压缩epub文件
    
	NSString* opfPath = [self parseManifestFile];//解析epub中container.xml文件返回opf文件路径
	[self parseOPF:opfPath];
}
//获取应用成Documents目录路径
- (NSString*) applicationDocumentsDirectory
{
    //获取系统中document文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths count] > 0 ? [paths objectAtIndex:0] : nil;
//    NSLog(@"document:%@",basePath);
    return basePath;
}

//解压缩epub文件
- (void) unzipAndSaveFileNamed:(NSString*)fileName
{
    //使用ZipArchive解压缩文件
    ZipArchive *za = [[ZipArchive alloc] init];
    //打开要解压的文件
    if ([za UnzipOpenFile:epubFilePath]) {
        //要压缩到的目标文件位置
        NSString *strPath = [NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
        NSLog(@"strPath:%@",strPath);
        NSFileManager *fileManager = [[NSFileManager alloc] init] ;
        //判断文件是否存在
        if ([fileManager fileExistsAtPath:strPath]) {
            //文件已经存在,删除当前位置的文件
            NSError *error;
            [fileManager removeItemAtPath:strPath error:&error];
        }
        [fileManager release];
        fileManager = nil;
        
        //把文件解压到目标文件里面
        BOOL result = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
        if (NO == result) {
            //解压失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error while unzipping the epub" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            alert = nil;
        }
        //关闭
        [za UnzipCloseFile];

    }
    [za release];
}
//解析META-INF/container.xml文件,返回content.opf文件的路径
- (NSString*) parseManifestFile
{
    //指定需解析文件的路径
    NSString *manifestFilePath = [NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml",[self applicationDocumentsDirectory]];
    NSLog(@"manifestFilePath:%@",manifestFilePath);
    //判断文件是否存在
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    if ([fileManager fileExistsAtPath:manifestFilePath]) {
        //开始解析,使用TouchXML解析
        CXMLDocument *manifestFile = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
        //获取Node
        CXMLNode *opfPath = [manifestFile nodeForXPath:@"//@full-path" error:nil];
        NSLog(@"opfPath:%@",[NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],[opfPath stringValue]]);
        //返回content.opf文件的路径
        return [NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],[opfPath stringValue]];
    }else{
        NSLog(@"ERROR: ePub not Valid");
		return nil;
    }
}
//解析opf文件
- (void) parseOPF:(NSString*)opfPath
{
    NSLog(@"解析OPF文件");
    CXMLDocument *opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
    //获取Nodes
    NSArray *itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSLog(@"itemsArray size: %d", [itemsArray count]);
    
    //直接读取dc里面的值/ 获取书的名字
    NSArray *dcTitle = [opfFile nodesForXPath:@"//dc:title" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://purl.org/dc/elements/1.1/" forKey:@"dc"] error:nil];
    NSLog(@"---------------: %@", [[dcTitle objectAtIndex:0] stringValue]);
    self.title = [[dcTitle objectAtIndex:0] stringValue];
    
    //获取ncx文件
    NSString *ncxFileName = nil;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
    //循环判断节点
    for(CXMLElement *element in itemsArray)
    {
        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        //ncx
        if ([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]) {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
            NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        //html xhtml xml
        if ([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"]) {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
            NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        //image
        if ([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"image/png"]) {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
            NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        //css
        if ([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"text/css"]) {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
            NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        //jpeg
        if ([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"image/jpeg"]) {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
            NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }

    }
    
    //从后往前找到第一个 / 的位置
    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
    NSString *ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    NSLog(@"ebookBasePath:%@",ebookBasePath);
    
    NSString *chapHref = [itemDictionary valueForKey:@"item"];
    NSLog(@"chapHref :%@",chapHref);
    
    //解析toc.ncx文件
    CXMLDocument *ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",ebookBasePath,ncxFileName]] options:0 error:nil];
    NSLog(@"ncxToc ======= > %@",ncxToc);
    
//    NSArray *aa = [ncxToc nodesForXPath:@"//ncx:navMap" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//    NSLog(@"__________________%@",[aa count]);
    
    //定义目录数组
    NSMutableDictionary *titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement *element in itemsArray) {
        NSString *href = [[element attributeForName:@"href"] stringValue];
//        NSLog(@"href:%@",href);
        NSString *xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        NSLog(@"xpath:%@",xpath);
        
        
        
        NSArray *navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        NSLog(@"navpoints ------------- %d",[navPoints count]);
        if([navPoints count]!=0){
            CXMLElement *titleElement = [navPoints objectAtIndex:0];
            NSLog(@"++++++++++++++%@",titleElement);
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }

    //解析opf文件  指定链接对应的页面
    NSArray *itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSLog(@"itemRefsArray size: %d", [itemRefsArray count]);
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    int count = 0;
	for (CXMLElement *element in itemRefsArray) {
        NSString *chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        NSLog(@"chapHref :%@",chapHref);
        NSLog(@"title---->%@",[titleDictionary valueForKey:chapHref]);
        if ([titleDictionary valueForKey:chapHref] != nil) {
            //根据webview的大小和页面中位置大小
            Chapter *tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]//所有文件路径
                                                          title:[titleDictionary valueForKey:chapHref] //目录
                                                   chapterIndex:count++];
            [tmpArray addObject:tmpChapter];
            if ([titleDictionary valueForKey:chapHref] != nil) {
                [indexArray addObject:tmpChapter];//目录对应的页面
            }
            [tmpChapter release];
        }
	}
	
	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
    self.spineIndexArray = [NSArray arrayWithArray:indexArray];
//    self.spineArray = [NSArray arrayWithArray:titleDictionary];
	
	[opfFile release];
	[tmpArray release];
    [indexArray release];
	[ncxToc release];
	[itemDictionary release];
	[titleDictionary release];

}

- (void)dealloc
{
    [myEPub release];
    [spineArray release];
    [epubFilePath release];
    [super dealloc];
}

@end
