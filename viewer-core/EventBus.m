////////////////////////////////////////////////////////////////////////////////
//
//Copyright (c) 2011-2012 Esri
//
//All rights reserved under the copyright laws of the United States.
//You may freely redistribute and use this software, with or
//without modification, provided you include the original copyright
//and use restrictions.  See use restrictions in the file:
//<install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
#import "EventBus.h"


@implementation EventBus
static EventBus * _eventBusInstance = nil;
+(id) sharedInstance
{
	if (!_eventBusInstance) {
		_eventBusInstance = [[[self class] alloc] init];
	}
	return _eventBusInstance;
}
-(BOOL) dispatchNotificationName:(NSString *)name object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:aUserInfo];
	return YES;
}
-(BOOL) addListener:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
	[[NSNotificationCenter defaultCenter]addObserver:observer selector:aSelector name:aName object:anObject];
	return YES;
}
-(BOOL) removeListener:(id)observer name:(NSString *)aName object:(id)anObject
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
	return YES;
}
@end
