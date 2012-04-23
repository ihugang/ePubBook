 
#import <Foundation/Foundation.h>

@interface UIBarButtonItem (custom)

-(UIBarButtonItem*)initCancelItemForTarget:(id)target selector:(SEL)aSelector;
-(UIBarButtonItem*)initDoneItemForTarget:(id)target selector:(SEL)aSelector;

@end

