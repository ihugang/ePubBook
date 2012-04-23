//
//  UIView+Motion.m
//  AirQueue
//
//  Created by zppro on 11-8-25.
//  Copyright 2011年 E0571. All rights reserved.
//

#import "UIView+Motion.h"
#import <QuartzCore/QuartzCore.h> 
@implementation UIView (Motion) 

- (void) flipMe{
    [UIView transitionWithView:self duration:0.3f options:UIViewAnimationOptionTransitionFlipFromLeft  animations:^{
        self.frame = self.frame; 
    } completion:NULL];
}

- (void) shakeMe
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0);
    
    self.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:100.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

/*
- (void)swingMeOld
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGFloat angle = 0.04;
    CGAffineTransform rotatorRight  = CGAffineTransformRotate(CGAffineTransformIdentity,angle);
    CGAffineTransform rotatorLeft = CGAffineTransformRotate(CGAffineTransformIdentity, -angle);
    
    self.transform = rotatorLeft;
     
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        //[UIView setAnimationRepeatCount: [[NSNumber numberWithFloat:INFINITY] floatValue]];
        self.transform = rotatorRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    [pool release];
}
*/

- (void) swingMe
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
     
    CGFloat angle = 0.04;
    CGAffineTransform rotatorRight  = CGAffineTransformRotate(CGAffineTransformIdentity,angle);
    CGAffineTransform rotatorLeft = CGAffineTransformRotate(CGAffineTransformIdentity, -angle);

    self.transform = rotatorLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        //[UIView setAnimationRepeatCount: [[NSNumber numberWithFloat:INFINITY] floatValue]];
        self.transform = rotatorRight;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }];
    //NSLog(@"swingMe end");
    [pool drain];
}

-(void) finishSwingMe{

    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:NULL]; 
    
} 

- (void) scaleMe2D{
     
    CGAffineTransform translateScaleIn  = CGAffineTransformMakeScale(0.90, 0.90);
    //CGAffineTransform translateScaleNormal  = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.07 animations:^{
        self.transform = translateScaleIn;
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }]; 
}

- (void) moveMeTo:(CGPoint) newCenter
{ 
    [self moveMeTo:newCenter withDuration:0.2];
}
- (void) moveMeTo:(CGPoint) newCenter withDuration:(float) duration{
    [UIView animateWithDuration:duration animations:^{
        self.center = newCenter;
    }completion:NULL];
}

- (void) moveMeTo:(CGPoint) newCenter andScaleTo:(CGSize)newSize
{  
    [self moveMeTo:newCenter andScaleTo:newSize withDuration:0.2];
}

- (void) moveMeTo:(CGPoint) newCenter andScaleTo:(CGSize)newSize withDuration:(float) duration{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.bounds = CGRectMake(0,0,newSize.width, newSize.height); 
        self.center = newCenter;
    }completion:NULL];
}
@end
