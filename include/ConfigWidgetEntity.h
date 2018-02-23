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
 <widget label="Search" left="80" top="280"
 icon="assets/images/i_search.png"
 config="widgets/Search/SearchWidget_Louisville.xml"
 url="widgets/Search/SearchWidget.a"/>
 
 read from config.xml
 */
@interface ConfigWidgetEntity : NSObject {
	NSString * _label;
    NSString * _title;
	NSString * _icon;
	NSString * _config;
	NSString * _className;
	NSString * _bundleName;
}
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSString * config;
@property (nonatomic, strong) NSString * className;
@property (nonatomic, strong) NSString * bundleName;
@end
