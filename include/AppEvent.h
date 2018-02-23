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
#import <Foundation/Foundation.h>

@interface AppEvent : NSObject {
	NSString *appEventName;
	id       appEventObject;
	NSDictionary * appEventUserInfo;
}
@property (nonatomic, strong) NSString *appEventName;
@property (nonatomic, strong) id       appEventObject;
@property (nonatomic, strong) NSDictionary * appEventUserInfo;

-(id)initWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
+(id)AppEventWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
-(BOOL)dispatch;
+(BOOL)dispatchEventWithName:(NSString *)eventName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;;
-(id)clone;
+(void)addListener:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
+(void)removeListener:(id)observer name:(NSString *)aName object:(id)anObject;
+(void)showError:(NSString *)error;

@end
