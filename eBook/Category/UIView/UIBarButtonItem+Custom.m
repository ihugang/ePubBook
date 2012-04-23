 
#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (custom)

-(UIBarButtonItem*)initCancelItemForTarget:(id)target selector:(SEL)aSelector
{
return	[[self initWithTitle:@"Cancel"
					  style:UIBarButtonItemStylePlain 
					 target:target 
					 action:aSelector] autorelease];	
	
}
-(UIBarButtonItem*)initDoneItemForTarget:(id)target selector:(SEL)aSelector
{
	return	[[self initWithTitle:@"Done" 
						  style:UIBarButtonItemStylePlain 
						 target:target 
						 action:aSelector] autorelease];
}

@end
 