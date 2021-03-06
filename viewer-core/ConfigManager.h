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
#import "ConfigEntity.h"

@interface ConfigManager : NSObject {
	ConfigEntity * _configEntity;
	
}
-(id) initWithConfigXML:(NSString *) path;
@property (nonatomic, strong) ConfigEntity * configEntity;
@end
