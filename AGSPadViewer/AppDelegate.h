//
//  AppDelegate.h
//  AGSPadViewer
//
//  Created by zhang baocai on 13-4-15.
//  Copyright (c) 2013年 Esri. All rights reserved.
//
//  Edited by MaY on 14-4-5.
//  Copyright (c) 2014年 esriChina. All rights reserved.
//
#import <UIKit/UIKit.h>
#import  <ArcGIS/ArcGIS.h>

@class AGSPadViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AGSPadViewController *viewController;
@property (strong, nonatomic) NSString *currentMapName;
@property (strong, nonatomic) NSString *currentAtlasPath;
@property (strong, nonatomic) AGSGraphicsLayer *drawGraphicLayer;
@property(nonatomic,strong) NSArray *datasetPoint;
@property(nonatomic,strong) NSArray *datasetLine;
@property(nonatomic,strong) NSArray *datasetPolygon;
@property bool isShowDrawInfo;
@property(nonatomic,strong) NSString *worldTpkPath;
-(void)logAppStatus:(NSString*)status;

@end
