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
 */
/*
 config.xml  
 <layer label="Topo"    type="tiled" visible="false"
 url="http://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"/>
 layer Object
 read from config.xml
 */
@interface ConfigLayerEntity : NSObject {
	NSString * _label;
	NSString * _type;
	BOOL       _visible;
	NSString * _url;
	float      _alpha;
	NSString * _popupConfig;
    NSString * _icon;
}
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) BOOL       visible;
@property (nonatomic, assign) float      alpha;
@property (nonatomic, strong) NSString * popupConfig;
@property (nonatomic, strong) NSString * icon;
@end
