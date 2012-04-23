//
//  UIView+Motion.h
//  AirQueue
//
//  Created by zppro on 11-8-25.
//  Copyright 2011年 E0571. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Motion)
    
- (void) flipMe;
- (void) shakeMe;
- (void) swingMe;
- (void) finishSwingMe;
- (void) scaleMe2D;
- (void) moveMeTo:(CGPoint) newCenter;
- (void) moveMeTo:(CGPoint) newCenter withDuration:(float) duration;
- (void) moveMeTo:(CGPoint) newCenter andScaleTo:(CGSize)newSize;
- (void) moveMeTo:(CGPoint) newCenter andScaleTo:(CGSize)newSize withDuration:(float) duration;
@end
