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

#import "ConfigMapEntity.h"
#import <ArcGIS/ArcGIS.h>

@implementation ConfigMapEntity
@synthesize wraparound180		= _wraparound180;
@synthesize initialExtent		= _initialExtent;
@synthesize fullExtent			= _fullExtent;
@synthesize baseMaps			= _baseMaps;
@synthesize tiledLayers			= _tiledLayers;
@synthesize operationalLayers	= _operationalLayers;
@end
