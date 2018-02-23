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
#import "AppEvent.h"
#import "EventBus.h"
#import "AppEventNames.h"
@implementation AppEvent
@synthesize appEventName;
@synthesize appEventObject;
@synthesize appEventUserInfo;


#pragma mark - 初始化
-(id) init
{
	return	[self initWithName:@"" object:nil userInfo:nil];
}

-(id)initWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	if (self = [super init]) {
		self.appEventName     = eventName;
		self.appEventObject   = anObject;
		self.appEventUserInfo = aUserInfo;
	}
	return self;
}
+(id)AppEventWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	AppEvent *appEvent = [[AppEvent alloc] initWithName:eventName object:anObject userInfo:aUserInfo];
	return appEvent;
}
#pragma mark - 消息分发
-(BOOL)dispatch
{
	return [[EventBus sharedInstance] dispatchNotificationName:self.appEventName object:self.appEventObject userInfo:self.appEventUserInfo];
}
+(BOOL)dispatchEventWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	return [[EventBus sharedInstance] dispatchNotificationName:eventName object:anObject userInfo:aUserInfo];
}
#pragma mark - clone
-(id)clone
{
	AppEvent *appEventClone = [[AppEvent alloc] initWithName:self.appEventName object:self.appEventObject userInfo:self.appEventUserInfo];
	return appEventClone;
}
#pragma mark - 消息监听和移除
+(void)addListener:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [[EventBus sharedInstance]addListener:observer selector:aSelector name:aName object:anObject];
}
+(void)removeListener:(id)observer name:(NSString *)aName object:(id)anObject
{
	[[EventBus sharedInstance] removeListener:observer name:aName object:anObject];
}

#pragma mark - 错误消息分发
+(void)showError:(NSString *)error
{
	[AppEvent dispatchEventWithName:APP_ERROR object:nil userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];

}
#pragma mark - 析构
-(void)dealloc
{
	self.appEventName;
	self.appEventObject;
	self.appEventUserInfo;
}
@end
