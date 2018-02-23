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


@interface EventBus : NSObject {

}
+(id) sharedInstance;
-(BOOL) dispatchNotificationName:(NSString *)name object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
-(BOOL) addListener:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
-(BOOL) removeListener:(id)observer name:(NSString *)aName object:(id)anObject;
@end
