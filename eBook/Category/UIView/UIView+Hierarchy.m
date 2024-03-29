//
//  UIView+Hierarchy.m
//
//  Created by Marin Todorov on 26/02/2010.
//  for http://www.touch-code-magazine.com
//


#import "UIView+Hierarchy.h"


@implementation UIView(Hierarchy)

- (UIView *)firstParentOfClass:(Class)klass;
{
    UIView *parent = [self superview];
    do
    {
        if ([parent isKindOfClass:klass])
        {
            return parent;
        }
        
        parent = [parent superview];
    } while (nil != parent);
    
    return nil;
}

-(int)getSubviewIndex
{
	return [self.superview.subviews indexOfObject:self];
}

-(void)bringToFront
{
	[self.superview bringSubviewToFront:self];
}

-(void)sendToBack
{
	[self.superview sendSubviewToBack:self];
}

-(void)bringOneLevelUp
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

-(void)sendOneLevelDown
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

-(BOOL)isInFront
{
	return ([self.superview.subviews lastObject]==self);
}

-(BOOL)isAtBack
{
	return ([self.superview.subviews objectAtIndex:0]==self);
}

-(void)swapDepthsWithView:(UIView*)swapView
{
	[self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}


@end
