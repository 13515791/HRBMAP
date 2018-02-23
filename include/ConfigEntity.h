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

/*
 config.xml 
 */
@class ConfigMapEntity;
@interface ConfigEntity : NSObject {

	NSString		* _title;
	NSString		* _subtitle;
	NSString		* _logo;
	NSDictionary	* _style;
	NSString		* _geometryServiceUrl;
	ConfigMapEntity * _configMapEntity;
	// array of ConfigWidgetEntity
	NSArray			* _widgetContainer; 
	
}
@property (nonatomic, strong) NSString			* title;
@property (nonatomic, strong) NSString			* subtitle;
@property (nonatomic, strong) NSString			* logo;
@property (nonatomic, strong) NSDictionary		* style;
@property (nonatomic, strong) NSString			* geometryServiceUrl;
@property (nonatomic, strong) ConfigMapEntity	* configMapEntity;
@property (nonatomic, strong) NSArray			* widgetContainer; 
@end
