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

#import "ConfigManager.h"
#import "TBXML.h"
#import <ArcGIS/ArcGIS.h>
#import "ConfigMapEntity.h"
#import "ConfigLayerEntity.h"
#import "ConfigWidgetEntity.h"

@implementation ConfigManager
@synthesize configEntity=_configEntity;

-(id) initWithConfigXML:(NSString *) path
{
	self = [super init];
	if (self) {
		ConfigEntity * configEntityTemp = [[ConfigEntity alloc] init];
		self.configEntity = configEntityTemp;
		TBXML * tbxml = [[TBXML alloc] initWithXMLFilePath:path];
		//config.xml load failed
		if (tbxml == nil  ) {
			return  nil;
		}
		//rootXMLElement load failed
		TBXMLElement *rootXMLElement = tbxml.rootXMLElement;
		if (rootXMLElement == nil ) {
			return  nil;
		}
		//get title
		/*
		TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:rootXMLElement];
		self.configEntity.title = [TBXML textForElement:titleElement];
		
		//get subtitle
		TBXMLElement * subTitleElement = [TBXML childElementNamed:@"subtitle" parentElement:rootXMLElement];
		self.configEntity.subtitle = [TBXML textForElement:subTitleElement];
		
		//get logo
		TBXMLElement * logoElement = [TBXML childElementNamed:@"logo" parentElement:rootXMLElement];
		self.configEntity.logo = [TBXML textForElement:logoElement];
		*/
		//get style
	//	TBXMLElement * styleElement = [TBXML childElementNamed:@"style" parentElement:rootXMLElement];
		
		//get geometryservice
		//TBXMLElement * geometryServiceElement = [TBXML childElementNamed:@"geometryservice" parentElement:rootXMLElement];		
		//self.configEntity.geometryServiceUrl = [TBXML textForElement:geometryServiceElement];
		
		//get map
		ConfigMapEntity *configMapEntity = [[ConfigMapEntity alloc] init];
		TBXMLElement * mapElement = [TBXML childElementNamed:@"map" parentElement:rootXMLElement];
		NSString *wraparound180Att= [TBXML valueOfAttributeNamed:@"wraparound180" forElement:mapElement];
		// no wraparound180 Attribute
		if (wraparound180Att == nil ) 
		{
			configMapEntity.wraparound180 = NO;
		}
		else
		{
			if ([wraparound180Att isEqualToString:@"true"]) {
				configMapEntity.wraparound180 = YES;
			}
			else {
				configMapEntity.wraparound180 = NO;
			}

		}
		//
		NSString *initialextentAtt= [TBXML valueOfAttributeNamed:@"initialextent" forElement:mapElement];
		if (initialextentAtt == nil ) 
		{
			configMapEntity.initialExtent = nil;
		}
		else
		{
			NSArray *listItems = [initialextentAtt componentsSeparatedByString:@" "];
			AGSEnvelope * initialExtent = [[AGSEnvelope alloc] 
										   initWithXmin:[[listItems objectAtIndex:0] doubleValue] 
										   ymin:[[listItems objectAtIndex:1] doubleValue]  
										   xmax:[[listItems objectAtIndex:2] doubleValue]  
										   ymax:[[listItems objectAtIndex:3] doubleValue]  
										   spatialReference:nil];
			
			configMapEntity.initialExtent = initialExtent;
			
		}
		//
		NSString *fullextentAtt= [TBXML valueOfAttributeNamed:@"fullextent" forElement:mapElement];
		if (fullextentAtt == nil ) 
		{
			configMapEntity.fullExtent = nil;
		}
		else
		{
			NSArray *listItems2 = [fullextentAtt componentsSeparatedByString:@" "];
			AGSEnvelope * fullExtent = [[AGSEnvelope alloc] 
										   initWithXmin:[[listItems2 objectAtIndex:0] doubleValue] 
										   ymin:[[listItems2 objectAtIndex:1] doubleValue]  
										   xmax:[[listItems2 objectAtIndex:2] doubleValue]  
										   ymax:[[listItems2 objectAtIndex:3] doubleValue]  
										   spatialReference:nil];
			
			configMapEntity.fullExtent = fullExtent;
			
		}
		// read Basemap layers
		TBXMLElement * baseMapsElement = [TBXML childElementNamed:@"basemaps" parentElement:mapElement];
		TBXMLElement * layerElement = baseMapsElement->firstChild;
		NSMutableArray * baseMaps = [[NSMutableArray alloc] initWithCapacity:10];
		while (layerElement) {
			ConfigLayerEntity * configLayerEntity = [[ConfigLayerEntity alloc] init];
			NSString *strLabel= [TBXML valueOfAttributeNamed:@"label" forElement:layerElement];
			configLayerEntity.label = strLabel;
			NSString *strType= [TBXML valueOfAttributeNamed:@"type" forElement:layerElement];
			configLayerEntity.type = strType;
			NSString *strVisible= [TBXML valueOfAttributeNamed:@"visible" forElement:layerElement];
			if (strVisible == nil) 
			{
				configLayerEntity.visible = NO;
			}
			else
			{
				if ([strVisible isEqualToString:@"true"]) {
					configLayerEntity.visible = YES;
				}
				else {
					configLayerEntity.visible = NO;
				}
				
			}
			NSString *strUrl= [TBXML valueOfAttributeNamed:@"url" forElement:layerElement];
			configLayerEntity.url = strUrl;
			NSString *strAlpha= [TBXML valueOfAttributeNamed:@"alpha" forElement:layerElement];
			if (strAlpha == nil) 
			{
				configLayerEntity.alpha = 1.0;
			}
			else {
				configLayerEntity.alpha = [strAlpha doubleValue];
			}
            NSString *strICON = [TBXML valueOfAttributeNamed:@"icon" forElement:layerElement];
			if (strICON == nil)
			{
				configLayerEntity.icon= @"default_basemapView_icon.jpg";
			}
			else {
				configLayerEntity.icon = strICON;
			}
			
			[baseMaps addObject:configLayerEntity];
			
			layerElement = layerElement->nextSibling;
		}
		configMapEntity.baseMaps = baseMaps;
		// read tiledLayers
        TBXMLElement *tiledLayersElement = [TBXML childElementNamed:@"tiledlayers" parentElement:mapElement];
		TBXMLElement *tiledLayerElement = tiledLayersElement->firstChild;
		NSMutableArray *tiledLayers = [[NSMutableArray alloc] initWithCapacity:10];
		while (tiledLayerElement) {
			ConfigLayerEntity * configLayerEntity = [[ConfigLayerEntity alloc] init];
			NSString *strLabel= [TBXML valueOfAttributeNamed:@"label" forElement:tiledLayerElement];
			configLayerEntity.label = strLabel;
			NSString *strType= [TBXML valueOfAttributeNamed:@"type" forElement:tiledLayerElement];
			configLayerEntity.type = strType;
			NSString *strVisible= [TBXML valueOfAttributeNamed:@"visible" forElement:tiledLayerElement];
			if (strVisible == nil )
			{
				configLayerEntity.visible = NO;
			}
			else
			{
				if ([strVisible isEqualToString:@"true"]) {
					configLayerEntity.visible = YES;
				}
				else {
					configLayerEntity.visible = NO;
				}
				
			}
			NSString *strUrl= [TBXML valueOfAttributeNamed:@"url" forElement:tiledLayerElement];
			configLayerEntity.url = strUrl;
			NSString *strAlpha= [TBXML valueOfAttributeNamed:@"alpha" forElement:tiledLayerElement];
            
			if (strAlpha == nil )
			{
				configLayerEntity.alpha = 1.0;
			}
			else {
				configLayerEntity.alpha = [strAlpha doubleValue];
			}
			[tiledLayers addObject:configLayerEntity];
			
			tiledLayerElement = tiledLayerElement->nextSibling;
		}
		configMapEntity.tiledLayers = tiledLayers;
		//read operationallayers
		TBXMLElement * opLayersElement = [TBXML childElementNamed:@"operationallayers" parentElement:mapElement];
		TBXMLElement * opLayerElement = opLayersElement->firstChild;
		NSMutableArray * opLayers = [[NSMutableArray alloc] initWithCapacity:10];
		while (opLayerElement) {
			ConfigLayerEntity * configLayerEntity = [[ConfigLayerEntity alloc] init];
			NSString *strLabel= [TBXML valueOfAttributeNamed:@"label" forElement:opLayerElement];
			configLayerEntity.label = strLabel;
			NSString *strType= [TBXML valueOfAttributeNamed:@"type" forElement:opLayerElement];
			configLayerEntity.type = strType;
			NSString *strVisible= [TBXML valueOfAttributeNamed:@"visible" forElement:opLayerElement];
			if (strVisible == nil ) 
			{
				configLayerEntity.visible = NO;
			}
			else
			{
				if ([strVisible isEqualToString:@"true"]) {
					configLayerEntity.visible = YES;
				}
				else {
					configLayerEntity.visible = NO;
				}
				
			}
			NSString *strUrl= [TBXML valueOfAttributeNamed:@"url" forElement:opLayerElement];
			configLayerEntity.url = strUrl;
			NSString *strAlpha= [TBXML valueOfAttributeNamed:@"alpha" forElement:opLayerElement];

			if (strAlpha == nil ) 
			{
				configLayerEntity.alpha = 1.0;
			}
			else {
				configLayerEntity.alpha = [strAlpha doubleValue];
			}
			[opLayers addObject:configLayerEntity];
			
			opLayerElement = opLayerElement->nextSibling;
		}
		configMapEntity.operationalLayers = opLayers;
		
		self.configEntity.configMapEntity  = configMapEntity;
		
		
		
		// read widgetContainer
		TBXMLElement * widgetcontainerElement = [TBXML childElementNamed:@"widgetcontainer" parentElement:rootXMLElement];
		TBXMLElement * widgetElement = widgetcontainerElement->firstChild;
		NSMutableArray * widgetcontainer = [[NSMutableArray alloc] initWithCapacity:10];
		// read operationallayers
		while (widgetElement) {
			ConfigWidgetEntity * configWidgetEntity = [[ConfigWidgetEntity alloc] init];
			NSString *strLabel= [TBXML valueOfAttributeNamed:@"label" forElement:widgetElement];
			configWidgetEntity.label = strLabel;
            NSString *strTitle= [TBXML valueOfAttributeNamed:@"title" forElement:widgetElement];
			configWidgetEntity.title = strTitle;
			NSString *strIcon= [TBXML valueOfAttributeNamed:@"icon" forElement:widgetElement];
			configWidgetEntity.icon = strIcon;
			
			NSString *strClassName= [TBXML valueOfAttributeNamed:@"classname" forElement:widgetElement];
			configWidgetEntity.className = strClassName;
			NSString *strConfig= [TBXML valueOfAttributeNamed:@"config" forElement:widgetElement];
			configWidgetEntity.config = strConfig;
			NSString *strBundleName= [TBXML valueOfAttributeNamed:@"bundle" forElement:widgetElement];
			configWidgetEntity.bundleName = strBundleName;
			// add configWidgetEntity to widgetcontainer
			[widgetcontainer addObject:configWidgetEntity];
			
			widgetElement = widgetElement->nextSibling;
		}
		self.configEntity.widgetContainer = widgetcontainer;
		
	}
	return self;
}
@end
