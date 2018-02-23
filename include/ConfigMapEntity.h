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
 <map wraparound180="true" 
 initialextent="-14083000 3139000 -10879000 5458000" 
 fullextent="-20000000 -20000000 20000000 20000000" 
 top="40">
 */
@class AGSEnvelope;
@interface ConfigMapEntity : NSObject {
	BOOL		  _wraparound180;
	AGSEnvelope * _initialExtent;
	AGSEnvelope * _fullExtent;
	NSArray     * _baseMaps;//Array of ConfigLayerEntity
    NSArray     * _tiledLayers;//Array of ConfigLayerEntity
	NSArray     * _operationalLayers; //Array of ConfigLayerEntity
}
@property (nonatomic, assign) BOOL			        wraparound180;
@property (nonatomic, strong) AGSEnvelope * initialExtent;
@property (nonatomic, strong) AGSEnvelope * fullExtent;
@property (nonatomic, strong) NSArray	  * baseMaps;
@property (nonatomic, strong) NSArray	  * tiledLayers;
@property (nonatomic, strong) NSArray     * operationalLayers;
@end
