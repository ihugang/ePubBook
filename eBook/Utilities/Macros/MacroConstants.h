//
//  MacroConstants.h
//  CheckDaily
//
//  Created by 钟 平 on 11-9-11.
//  Copyright 2011年 zppro. All rights reserved.
//

#ifndef CheckDaily_MacroConstants_h
#define CheckDaily_MacroConstants_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
 

#define kSuccessOfInvokeResult @"Success"
#define kErrorCodeOfInvokeResult @"ErrorCode"
#define kErrorMessageOfInvokeResult @"ErrorMessage"
#define kErrorCodeForConcurrency 59999
#define kErrorDomain @"codans"

#define kNotificationNameLocationDidUpdate @"locationDidUpdate"

//CoreData 
#import "e0571CoreDataManager.h"
#import "NSManagedObjectContext+e0571.h"
#import "NSManagedObject+e0571.h"
#define moc ([[e0571CoreDataManager sharedInstance] contextForCurrentThread])
 

#pragma mark - Device
#define YANGXH_SIMULATOR [DEVICE_UDID isEqualToString:@"25C31522-28AA-513E-83C8-0A5A4EC42BE1"]

#endif
