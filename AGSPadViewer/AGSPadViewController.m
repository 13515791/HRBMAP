//
//  AGSPadViewController.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-4-15.
//  Copyright (c) 2013年 Esri. All rights reserved.
//
//  Edited by MaY on 14-4-5.
//  Copyright (c) 2014年 esriChina. All rights reserved.
//

#import "AGSPadViewController.h"
#import "AppEvent.h"
#import "AppEventNames.h"
#import "WidgetsManager.h"
#import "ConfigManager.h"
#import "ConfigLayerEntity.h"
#import "ConfigMapEntity.h"
#import "UIImageView+AGSNorthArrow.h"
#import "WAWModalViewController.h"
#import "CorrdTransform.h"
#import "POI.h"
#import "AppEventNames.h"
#import "AppEvent.h"
#import "MaLocationDisplayDataSource.h"

#define kLAYERNAME_POI @"POISearchLayer"
#define kSEARCHRESULT_LIMIT 1000

@interface AGSPadViewController ()
{
    UIPopoverController * _searchResultPopoverControl;
    SearchResultViewController *_SRViewControl;
    NSMutableArray *_searchResultArray;
    MaLocationDisplayDataSource *_gpsOnGeoQ;
    AGSGraphic *_graphic_POIselected;
}
-(void) configViewer;
-(void) loadLayersFromConfig:(ConfigLayerEntity *)configLayerEntity;
@end

@implementation AGSPadViewController
@synthesize mapView = _mapView;
@synthesize basemapBtn = _basemapBtn;
@synthesize locationBtn = _locationBtn;
@synthesize northArrow = _northArrow;
@synthesize locManager = _locManager;
//添加搜索框
@synthesize searchBar=_searchBar;
@synthesize showMessage=_showMessage;
@synthesize distanceUnitBtn=_distanceUnitBtn;
@synthesize UnitsketchLayer=_UnitsketchLayer;
@synthesize areaUnitBtn=_areaUnitBtn;
@synthesize cleanBtn=_cleanBtn;
@synthesize editorBtn= _editorBtn;
@synthesize editViewController=_editViewController;
@synthesize activeFeatureLayer = _featureLayer;
@synthesize rightLogo=_rightLogo;
@synthesize leftLogo=_leftLogo;
@synthesize editVC=_editVC;
@synthesize selectVC=_selectVC;
@synthesize editGraphicLayer=_editGraphicLayer;
@synthesize graphicID=_graphicID;
@synthesize graphicAttachments=_graphicAttachments;
@synthesize showVC=_showVC;
@synthesize showHelpViewController=_showHelpViewController;

-(void)dealloc
{
    //self.basemapBtn;
    //self.locationBtn;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self prefersStatusBarHidden];
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if( orientation == UIInterfaceOrientationPortrait||orientation == UIInterfaceOrientationPortraitUpsideDown)
	{        
        self.view.frame = CGRectMake(0,0,768,1024);
    }
    else
    {
        self.view.frame = CGRectMake(0,0,1024,768);
    }

    [self configViewer];

    self.mapView.touchDelegate = self;
    //[self.editViewController  ];
    
    //初始化设置全局地图名称 内蒙区域全图
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.currentMapName=@"内蒙区域全图";
    
    delegate.isShowDrawInfo=NO;
    
    _editGraphicLayer=[AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:_editGraphicLayer withName:kLAYERNAME_DRAWGRAPHIC];
    [self showDrawInfo];
    //[self show]
    
    //初始化编辑窗体
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.editVC = [storyboard instantiateViewControllerWithIdentifier:@"Editor"];
    self.editVC.delegate= self;
    
    //Add Listener for menu change
    [AppEvent addListener:self selector:@selector(toolbarVisuable:) name:TOOLBAR_ACTIVE object:nil];
    
    
    NSURL* url = [NSURL URLWithString:@"https://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineCommunity/MapServer"];
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [self.mapView addMapLayer:tiledLayer withName:@"Basemap Tiled Layer"];
       /*
     //set Runtime's license
     [self setLicense];
     */
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [_widgetsManager shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}
// event relay
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_widgetsManager willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_widgetsManager didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    //[self refreshUI];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_widgetsManager willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Config UI&Data
//config UI,data
-(void) configViewer
{
    /*** UI ***/
    _mapView = [[AGSMapView alloc] initWithFrame:self.view.bounds];
    _mapView.backgroundColor=[UIColor whiteColor];
    _mapView.gridLineColor=[UIColor clearColor];
    self.mapView.callout.accessoryButtonHidden = YES;
    self.mapView.callout.customView = nil;
    self.mapView.callout.image = nil;
    self.mapView.callout.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mapView];
    //添加头尾图标
    _rightLogo=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    _rightLogo.backgroundColor=[UIColor clearColor];
    _rightLogo.image=[UIImage imageNamed:@"LOGO.png"];
    [_mapView addSubview:_rightLogo];
    
    _leftLogo=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height-30, 243, 32)];
    _leftLogo.image=[UIImage imageNamed:@"copyright.png"];
    [_mapView addSubview:_leftLogo];
    
    //basemapButton
	_basemapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_basemapBtn setFrame:CGRectMake(self.mapView.frame.size.width - 75, 80.0, 64.0, 64.0)];
    [_basemapBtn setBackgroundImage:[UIImage imageNamed:@"影像.png"] forState:UIControlStateNormal];
    [_basemapBtn setBackgroundImage:[UIImage imageNamed:@"矢量.png"] forState:UIControlStateSelected];
    [_basemapBtn addTarget:self action: @selector(baseMapTap:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_basemapBtn];
    
    //显示详细信息
    _showMessage=[UIButton buttonWithType:UIButtonTypeCustom];
    [_showMessage setFrame:CGRectMake(self.mapView.frame.size.width - 60, 180, 48.0, 48.0)];
    [_showMessage setBackgroundImage:[UIImage imageNamed:@"简介.png"] forState:UIControlStateNormal];
    [_showMessage setBackgroundImage:[UIImage imageNamed:@"简介.png"] forState:UIControlStateSelected];
    [_showMessage addTarget:self action: @selector(showMessageImg:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_showMessage];
    
    //显示标注数据
    _collectDataBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_collectDataBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, 240, 48.0, 48.0)];
    [_collectDataBtn setBackgroundImage:[UIImage imageNamed:@"标注数据_Off.png"] forState:UIControlStateNormal];
    [_collectDataBtn setBackgroundImage:[UIImage imageNamed:@"标注数据_On.png"] forState:UIControlStateSelected];
    [_collectDataBtn addTarget:self action: @selector(showCollectData) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_collectDataBtn];
    
    //编辑按钮
    _editorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_editorBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, 300, 48.0, 48.0)];
    [_editorBtn setBackgroundImage:[UIImage imageNamed:@"标注.png"] forState:UIControlStateNormal];
    [_editorBtn setBackgroundImage:[UIImage imageNamed:@"标注_On.png"] forState:UIControlStateSelected];
    [_editorBtn addTarget:self action: @selector(editorBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_editorBtn];
    
    //测距功能
    _distanceUnitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_distanceUnitBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, 360, 48.0, 48.0)];
    [_distanceUnitBtn setBackgroundImage:[UIImage imageNamed:@"测距.png"] forState:UIControlStateNormal];
    [_distanceUnitBtn setBackgroundImage:[UIImage imageNamed:@"测距_On.png"] forState:UIControlStateSelected];
    [_distanceUnitBtn addTarget:self action: @selector(DistanceUnitMap:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_distanceUnitBtn];
    
    //测量面积
    _areaUnitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_areaUnitBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, 420, 48.0, 48.0)];
    [_areaUnitBtn setBackgroundImage:[UIImage imageNamed:@"面积.png"] forState:UIControlStateNormal];
    [_areaUnitBtn setBackgroundImage:[UIImage imageNamed:@"面积_On.png"] forState:UIControlStateSelected];
    [_areaUnitBtn addTarget:self action: @selector(areaUnitMap:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_areaUnitBtn];
    
    //清楚按钮 _cleanBtn
    _cleanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_cleanBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, 480, 48.0, 48.0)];
    [_cleanBtn setBackgroundImage:[UIImage imageNamed:@"清楚按钮.png"] forState:UIControlStateNormal];
    [_cleanBtn setBackgroundImage:[UIImage imageNamed:@"清楚按钮.png"] forState:UIControlStateSelected];
    [_cleanBtn addTarget:self action: @selector(cleanSearchMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_cleanBtn];
    
    //LocationButton
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, self.mapView.frame.size.height -80, 48.0, 48.0)];
    [_locationBtn setBackgroundImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
    [_locationBtn setBackgroundImage:[UIImage imageNamed:@"定位_On.png"] forState:UIControlStateSelected];
    [_locationBtn addTarget:self action: @selector(showCurrectLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_locationBtn];
    
    //add helpbutton
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_helpBtn setFrame:CGRectMake(MENU_ORIGIN_X, self.mapView.frame.size.height - MENU_HEIGHT +95., 88.0, 88.0)];
    //NSLog(@"_helpBtn.view---%@",NSStringFromCGRect(_helpBtn.frame));
    [_helpBtn setBackgroundImage:[UIImage imageNamed:@"帮助.png"] forState:UIControlStateNormal];
    [_helpBtn setBackgroundImage:[UIImage imageNamed:@"帮助.png"] forState:UIControlStateSelected];
    [_helpBtn addTarget:self action: @selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_helpBtn];

    
    //add search bar
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(700, MENU_LOGO_HEIGHT-25, 250, 50)];
    _searchBar.backgroundColor = [UIColor clearColor];
    if (iOSVersion >= 7.0)
    {
        //_searchBar.backgroundImage = [self createImageWithColor:[UIColor clearColor]];
        //_searchBar.barTintColor=[UIColor blueColor];
        UIImage *img = [[UIImage imageNamed:@"searchBarBackImg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        _searchBar.backgroundImage=img;
        _searchBar.searchBarStyle=UISearchBarStyleMinimal;
    }
    else
    {
        for (UIView *subview in _searchBar.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    _searchBar.placeholder  = @"请输入搜索内容";
    _searchBar.showsSearchResultsButton = YES;
    _searchBar.showsCancelButton = NO;
    _searchBar.translucent = YES;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.delegate = self;
    
    _SRViewControl = [[SearchResultViewController alloc]init];
    _SRViewControl.delegate = self;
    _searchResultPopoverControl = [[UIPopoverController alloc]initWithContentViewController:_SRViewControl];
    [_mapView addSubview:_searchBar];
    
    /*** read Config ***/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *configFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"config.xml"];
    if (![fileManager fileExistsAtPath:configFilePath])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
        [fileManager copyItemAtPath:path toPath:configFilePath error:nil];
    }
	_configManager = [[ConfigManager alloc] initWithConfigXML:configFilePath];
    if (_configManager.configEntity.configMapEntity.wraparound180)
    {
        [_mapView enableWrapAround];
    }
    if (_configManager.configEntity.configMapEntity.initialExtent) {
        AGSEnvelope *env = _configManager.configEntity.configMapEntity.initialExtent;
        [_mapView zoomToEnvelope:env animated:NO];
    }
    
    //load tiledLayers
	for (int i=0; i<[_configManager.configEntity.configMapEntity.baseMaps count]; i++)
    {
		ConfigLayerEntity * agsLayerEntity = [_configManager.configEntity.configMapEntity.baseMaps objectAtIndex:i];
        [self loadLayersFromConfig:agsLayerEntity];
	}
    //load operationLayers
	//...
    
	//add widget manager
    _widgetsManager = [[WidgetsManager alloc] initWithConfig:_configManager.configEntity andMapView:self.mapView];
	CGRect frame =CGRectMake(MENU_ORIGIN_X, MENU_ORIGIN_Y, MENU_WIDTH, MENU_HEIGHT);
    _widgetsManager.frame =frame;
    _widgetsManager.userInteractionEnabled = YES;
	[_mapView addSubview:_widgetsManager];
}

-(void) loadLayersFromConfig:(ConfigLayerEntity *)configLayerEntity
{
	NSURL *mapUrl = [NSURL URLWithString:configLayerEntity.url];
    id agsLayer;
	//Online
    if ([configLayerEntity.type isEqualToString:@"tiled"])
    {
		agsLayer = [[AGSTiledMapServiceLayer alloc ]initWithURL:mapUrl];
	}
    else if ([configLayerEntity.type isEqualToString:@"localTiled"])
    {
        NSString *_TPKPath;
        if ([configLayerEntity.url hasPrefix:@"/"])
        {
            NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            _TPKPath =  [documentsDirectory stringByAppendingPathComponent:configLayerEntity.url];
        }
        else
        {
            _TPKPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configLayerEntity.url];
        }
        NSFileManager *fileMng = [[NSFileManager alloc]init];
        if ([fileMng fileExistsAtPath:_TPKPath])
        {
            agsLayer = [AGSLocalTiledLayer localTiledLayerWithPath:_TPKPath];
        }
        else
        {
            agsLayer = nil;
            NSLog(@"指向的TPK文件不存在！");
        }
	}
    else if([configLayerEntity.type isEqualToString:@"dynamic"])
    {
		agsLayer = [[AGSDynamicMapServiceLayer alloc ]initWithURL:mapUrl];
	}
    else if([configLayerEntity.type isEqualToString:@"feature"])
    {
		agsLayer = [AGSFeatureLayer featureServiceLayerWithURL:mapUrl mode:AGSFeatureLayerModeOnDemand];
	}
    else if([configLayerEntity.type isEqualToString:@"localFeature"])
    {
        NSString *_GDBPath;
        NSString *layerName = [configLayerEntity.url lastPathComponent];
        NSString *GDBName = [configLayerEntity.url stringByDeletingLastPathComponent];
        if ([configLayerEntity.url hasPrefix:@"/"])
        {
            NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            _GDBPath =  [documentsDirectory stringByAppendingPathComponent:GDBName];
        }
        else
        {
            _GDBPath =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:GDBName];
        }
        NSError *err;
        NSFileManager *fileMng = [[NSFileManager alloc]init];
        if ([fileMng fileExistsAtPath:_GDBPath])
        {
            AGSGDBGeodatabase *localdb = [AGSGDBGeodatabase geodatabaseWithPath:_GDBPath error:&err];
            AGSGDBFeatureTable *ftable = [localdb featureTableForLayerName:layerName];
            agsLayer = [[AGSFeatureTableLayer alloc]initWithFeatureTable:ftable];
        }
        else
        {
            agsLayer = nil;
            NSLog(@"指向的Geodatabase文件不存在！");
        }
	}
    else
    {
        agsLayer = nil;
    }
    if (agsLayer)
    {
        //NSLog(configLayerEntity.label);
        [self.mapView addMapLayer:agsLayer withName:configLayerEntity.label];
        AGSLayer *layer = (AGSLayer *)agsLayer;
        layer.opacity = configLayerEntity.alpha;
        layer.visible = configLayerEntity.visible;
    }
}


//Custom method
-(void)configBasemapViewContainer
{
    NSMutableArray *basemapSnaps = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<[_configManager.configEntity.configMapEntity.baseMaps count]; i++)
    {
		ConfigLayerEntity * agsLayerEntity = [_configManager.configEntity.configMapEntity.baseMaps objectAtIndex:i];
        NSArray *basemapSnap = [[NSArray alloc]initWithObjects:agsLayerEntity.label,agsLayerEntity.icon,agsLayerEntity.url,agsLayerEntity.type, nil];
        [basemapSnaps addObject:basemapSnap];
	}
    _sg = [[BaseMapSelectViewController alloc]initWithBasemaps:basemapSnaps];
    _sg.mapView = self.mapView;
    [_mapView addSubview:_sg.view];
}

//
-(void)baseMapTap:(id)sender
{
    NSString *filePath;
    if(!_basemapBtn.selected)
    {
        filePath=[NSString stringWithFormat:@"%@%@",[self MapfilePath], @"/data/切片图层/TM.tpk"];
    }
    else
    {
        filePath=[NSString stringWithFormat:@"%@%@",[self MapfilePath], @"/data/切片图层/nmsl.tpk"];
    }
    
    AGSLayer *baseLayer=[self.mapView baseLayer];
    [self.mapView removeMapLayer:baseLayer];
    AGSLocalTiledLayer* layer = [AGSLocalTiledLayer localTiledLayerWithPath:filePath];
    [self.mapView insertMapLayer:layer withName:@"内蒙区域全图" atIndex:0];
    [self.mapView setMinScale:18489297.737236];
    //4513.988705 9027.977411
    [self.mapView setMaxScale:4513.988705];
    _basemapBtn.selected = !_basemapBtn.selected;
}

//显示地图集详细信息
-(void)showMessageImg:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.showVC = [storyboard instantiateViewControllerWithIdentifier:@"AtlasMessage"];
    self.showVC.delegate=self;
    
    NSArray *maps=[self.mapView mapLayers];
    AGSLayer *basemapName=maps[0];
    
    [self.showVC showMessage:basemapName.name];

    //当前地图名称
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSFileManager* filemanager=[NSFileManager defaultManager];
    NSString *tpkPathStr;
    //判断当前图集时候存在详细信息
    if([basemapName.name isEqualToString:@"世界地图集"]==YES)
    {
        tpkPathStr=delegate.worldTpkPath;
    }
    else if([basemapName.name isEqualToString:@"中国地图集"]==YES)
    {
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            //NSString *SqlStr=@"select * from POI_new where MC like";
            NSString *SqlStr=[NSString stringWithFormat:@"select * from CAdata where CityName = '%@'",delegate.currentMapName];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *tpkPaht=(char *)sqlite3_column_text(statement, 3);
                    tpkPathStr=[[NSString alloc] initWithUTF8String:tpkPaht];
                }
            }
            //关闭数据库
            sqlite3_close(MyDatabase);
        }
    }
    else
    {
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            //NSString *SqlStr=@"select * from POI_new where MC like";
            NSString *SqlStr=[NSString stringWithFormat:@"select * from tttt where CountyName = '%@'",delegate.currentMapName];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *tpkPaht=(char *)sqlite3_column_text(statement, 3);
                    tpkPathStr=[[NSString alloc] initWithUTF8String:tpkPaht];
                }
            }
            //关闭数据库
            sqlite3_close(MyDatabase);
        }
    }
    
    NSString *tpklastfilePath=[tpkPathStr stringByDeletingLastPathComponent];
    
    if([filemanager fileExistsAtPath:[NSString stringWithFormat:@"%@%@/images/",documentsDir,tpklastfilePath] isDirectory:NO]==YES)
    {
        [self presentViewController:self.showVC animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前图集没有详细信息！"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    /*
    NSString *messageImg=[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/%@.jpg",documentsDir,delegate.currentMapName,delegate.currentMapName];
    NSString *images=[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/images/",documentsDir,delegate.currentMapName];
    
    NSArray *files = [filemanager subpathsAtPath:images ];
       */

    _showMessage.selected = !_showMessage.selected;
}


-(void)ShowMessageViewControllerWasDismissed: (ShowMessageViewController *)showMessageViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//测量长度
-(void)DistanceUnitMap:(id)sender
{
    if(!_distanceUnitBtn.selected)
    {
        [self setDrawStatus];
        if(_areaUnitBtn.selected==YES)
        {
            _areaUnitBtn.selected=!_areaUnitBtn.selected;
        }
        if(_editorBtn.selected==YES)
        {
            _editorBtn.selected=!_editorBtn.selected;
            [self.mapView removeMapLayerWithName:@"Editsketchlayer"];
        }
        self.UnitsketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
        self.UnitsketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
        [self.mapView addMapLayer:self.UnitsketchLayer withName:@"Unitsketchlayer"];
        self.mapView.touchDelegate = self.UnitsketchLayer;
    }
    else
    {
        AGSGeometry *sketchGeometry = self.UnitsketchLayer.geometry;
        AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
        double distance=[geometryEngine geodesicLengthOfGeometry:sketchGeometry inUnit:AGSSRUnitKilometer];
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:6];
        
        NSString *distanceMessage=[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:distance]]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前测量的距离（千米）"
                                                        message:distanceMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        self.mapView.touchDelegate=self;
        [alert show];
    }
    _distanceUnitBtn.selected = !_distanceUnitBtn.selected;
}


//测量面积
-(void)areaUnitMap:(id)sender
{
    if(!_areaUnitBtn.selected)
    {
        [self setDrawStatus];
        if(_distanceUnitBtn.selected==YES)
        {
            _distanceUnitBtn.selected=!_distanceUnitBtn.selected;
        }
        if(_editorBtn.selected==YES)
        {
            _editorBtn.selected=!_editorBtn.selected;
            [self.mapView removeMapLayerWithName:@"Editsketchlayer"];
        }
        self.UnitsketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
        self.UnitsketchLayer.geometry = [[AGSMutablePolygon alloc] initWithSpatialReference:self.mapView.spatialReference];
        [self.mapView addMapLayer:self.UnitsketchLayer withName:@"Unitsketchlayer"];
        self.mapView.touchDelegate = self.UnitsketchLayer;
    }
    else
    {
        AGSGeometry *sketchGeometry = self.UnitsketchLayer.geometry;
        AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
        double distance=[geometryEngine geodesicAreaOfGeometry:sketchGeometry inUnit:AGSAreaUnitsSquareKilometers];
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:6];
        
        NSString *distanceMessage=[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:distance]]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前测量的面积（平方千米）"
                                                        message:distanceMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        self.mapView.touchDelegate=self;
        [alert show];
    }
    _areaUnitBtn.selected = !_areaUnitBtn.selected;
}

//清楚搜索内容
-(void)cleanSearchMessage:(id)sender
{
    //_searchResultArray=nil;
    //_searchResultArray=[[NSMutableArray alloc] init];
    _searchBar.text=@"";
    AGSGraphicsLayer *graphicLayer = (AGSGraphicsLayer *)[_mapView mapLayerForName:kLAYERNAME_POI];
    [graphicLayer removeAllGraphics];
    _SRViewControl.searchResult=nil;
    [_SRViewControl.tableView reloadData];
    [_mapView.callout dismiss];
}
//GPS
-(void)showCurrectLocation:(id)sender
{
    //get location update info
    if (!_gpsOnGeoQ)
    {
        _gpsOnGeoQ = [[MaLocationDisplayDataSource alloc]init];
        
        _mapView.locationDisplay.dataSource  = _gpsOnGeoQ;
        _mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        _mapView.rotationAngle = 0.0;
    }
    if(_locationBtn.selected)
    {
        [_mapView.locationDisplay stopDataSource];
        _mapView.locationDisplay.alpha = 0.;//locationDisplay'symbol do not disappear  for customLocationDatasource,so...
    }
    else
    {
        [_mapView.locationDisplay startDataSource];
        _mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        _mapView.locationDisplay.alpha = 1.;
    }
    _locationBtn.selected = !_locationBtn.selected;
}
//
-(void)showCollectData
{
    if(_collectDataBtn.selected)
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.isShowDrawInfo=NO;
         [self showDrawInfo];
    }
    else
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.isShowDrawInfo=YES;
        [self showDrawInfo];
    }
    _collectDataBtn.selected = !_collectDataBtn.selected;
}
//现实帮助
-(void)showHelp
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self.showHelpViewController = [storyboard instantiateViewControllerWithIdentifier:@"showHelp"];
    self.showHelpViewController.delegate=self;
    [self presentViewController:self.showHelpViewController animated:YES completion:nil];
}

-(void)ShowHelpVCWasDismissed:(ShowHelpVC *)ShowHelpVCViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - utils
//输出毫秒级的时间
-(NSString *)getDateForMS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [NSString stringWithFormat:@"Date%@", [dateFormatter stringFromDate:[NSDate date]]];
}

//地图路径
- (NSString *)MapfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

//control rigth toolar's visuable
-(void)toolbarVisuable:(NSNotification *)notification
{
    NSDictionary * dict= [notification userInfo];
	NSNumber *widgetId = [dict objectForKey:@"widgetId"];
    if ([widgetId intValue] == 3)
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.currentMapName=@"内蒙区域全图";
        if(_basemapBtn.selected==YES)
        {
            _basemapBtn.selected = !_basemapBtn.selected;
            [_basemapBtn setBackgroundImage:[UIImage imageNamed:@"影像.png"] forState:UIControlStateNormal];
        }
        [self showDrawInfo];
        _basemapBtn.hidden = _distanceUnitBtn.hidden= _areaUnitBtn.hidden = _locationBtn.hidden = _searchBar.hidden =_cleanBtn.hidden = NO;
        _showMessage.hidden= YES;
        self.mapView.touchDelegate=self;
    }
    else
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *atlasName;
        //世界地图集
        if([widgetId intValue] == 0)
        {
            atlasName=@"世界地图集";
            [_mapView.locationDisplay stopDataSource];
            _mapView.locationDisplay.alpha = 0.;//locationDisplay'symbol do not disappear  for customLocationDatasource,so...
            if(_locationBtn.selected==YES)
            {
                [_locationBtn setBackgroundImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
                _locationBtn.selected = !_locationBtn.selected;
            }
            
            if(_areaUnitBtn.selected==YES)
            {
                _areaUnitBtn.selected=!_areaUnitBtn.selected;
            }
            if(_distanceUnitBtn.selected==YES)
            {
                _distanceUnitBtn.selected=!_distanceUnitBtn.selected;
            }
            [self setDrawStatus];
        }
        //中国地图集
        else if([widgetId intValue] == 1)
        {
            atlasName = @"中国地图集";
            [_mapView.locationDisplay stopDataSource];
            _mapView.locationDisplay.alpha = 0.;//locationDisplay'symbol do not disappear  for customLocationDatasource,so...
            if(_locationBtn.selected==YES)
            {
                [_locationBtn setBackgroundImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
                _locationBtn.selected = !_locationBtn.selected;
            }
            if(_areaUnitBtn.selected==YES)
            {
                _areaUnitBtn.selected=!_areaUnitBtn.selected;
            }
            if(_distanceUnitBtn.selected==YES)
            {
                _distanceUnitBtn.selected=!_distanceUnitBtn.selected;
            }
            [self setDrawStatus];
        }
        //内蒙地图集
        else if([widgetId intValue] == 2)
        {
            atlasName=@"内蒙地图集";
            [_mapView.locationDisplay stopDataSource];
            _mapView.locationDisplay.alpha = 0.;//locationDisplay'symbol do not disappear  for customLocationDatasource,so...
            if(_locationBtn.selected==YES)
            {
                [_locationBtn setBackgroundImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
                _locationBtn.selected = !_locationBtn.selected;
            }
            
            if(_areaUnitBtn.selected==YES)
            {
                _areaUnitBtn.selected=!_areaUnitBtn.selected;
            }
            if(_distanceUnitBtn.selected==YES)
            {
                _distanceUnitBtn.selected=!_distanceUnitBtn.selected;
            }
            [self setDrawStatus];
        }
         delegate.currentMapName=atlasName;
        self.mapView.touchDelegate=self;
        [self showDrawInfo];
        _basemapBtn.hidden = _distanceUnitBtn.hidden= _areaUnitBtn.hidden = _locationBtn.hidden = _searchBar.hidden = _cleanBtn.hidden=YES;
        _showMessage.hidden = NO;
    }
}
//搜索框里面在添加的时候会有UIsearchtextfield，这里面必须把这个设置去掉，才不会出现阴影
- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - AGSMapViewLayerDelegate
- (void)mapViewDidLoad:(AGSMapView *)mapView
{
	[AppEvent dispatchEventWithName:MAP_LOADED object:self userInfo:nil];
}
#pragma mark -
#pragma mark AGSMapViewCalloutDelegate
- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
	if ([graphic.layer.name isEqualToString: kLAYERNAME_POI]) {
        //extract the type of graphics to check.
        self.mapView.callout.title = (NSString*)[graphic.allAttributes objectForKey:@"NAME"];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Touch Delegate Methods
- (void) mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features
{
    //Show popups for features that were tapped on
    NSMutableArray *tappedFeatures_draw = [[NSMutableArray alloc]init];
    NSMutableArray *tappedFeatures_searchResult = [[NSMutableArray alloc]init];
    NSEnumerator* keys = [features keyEnumerator];
    for (NSString* key in keys)
    {
        if ([key isEqualToString:kLAYERNAME_DRAWGRAPHIC]) {
            [tappedFeatures_draw addObjectsFromArray:[features objectForKey:key]];
            
        }else if([key isEqualToString:kLAYERNAME_POI]){
            [tappedFeatures_searchResult addObjectsFromArray:[features objectForKey:key]];
        }
    }
    
    if (tappedFeatures_draw.count>0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        self.editVC = [storyboard instantiateViewControllerWithIdentifier:@"Editor"];
        self.editVC.delegate= self;
        AGSGraphic *graphic=tappedFeatures_draw[tappedFeatures_draw.count-1];
        NSDictionary *graphicInfo=[graphic allAttributes];
        _graphicID=[graphicInfo valueForKey:@"attid"];
        _graphicAttachments=[graphicInfo valueForKey:@"attachmentpath"];
        [self.editVC addTemplatesForLayersInMap:graphic];
        
        self.editVC.modalPresentationStyle = UIModalPresentationFormSheet;
        self.editVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:self.editVC animated:YES completion:nil];
    }else if(tappedFeatures_searchResult.count>0){//feature for callout
        AGSGraphic *graphic =tappedFeatures_searchResult[tappedFeatures_searchResult.count-1];
        [self hilightSelectedGraphic:graphic];
        [_mapView zoomToGeometry:graphic.geometry withPadding:1.0 animated:YES];
        CGPoint Offset;
        Offset.x = 0.;
        Offset.y = 0.;
        self.mapView.callout.title = (NSString *)[graphic.allAttributes objectForKey:@"NAME"];
        [self.mapView.callout showCalloutAt:(AGSPoint*)graphic.geometry screenOffset:Offset animated:YES];
    }
}

#pragma mark - Search

- (void)search4POI:(NSString*) text{
    if (_searchResultArray) {
        _searchResultArray = nil;
    }
    //***search text format
    /*处理空格*/
    NSString *string = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSCharacterSet *characterSet1 = [NSCharacterSet whitespaceCharacterSet];
    NSArray *array1 = [string componentsSeparatedByCharactersInSet:characterSet1];
    NSMutableString *newString1 = [NSMutableString string];
    for(NSString *string in array1)
    {
        [newString1 appendString:string];
    }
    NSCharacterSet *characterSet2 = [NSCharacterSet characterSetWithCharactersInString:@"<~!@#$%%^&**()_+-={}[]|:\',.;/>?"];
    NSArray *array2 = [newString1 componentsSeparatedByCharactersInSet:characterSet2];
    NSMutableString *newString2 = [NSMutableString string];
    if (array2) {
        if (array2.count >1) {//the manual keywords
            for(NSString *str in array2)
            {
                if ([str length]>0) {
                    [newString2 appendString:[NSString stringWithFormat:@"%%%@",str]];
                }
            }
        }else{//Separate input string to characters,then add '%X%Y...%' for increase the scope of search
            for (int i =0; i < newString1.length; i ++) {
                NSRange range;
                range.location = i;
                range.length = 1;
                [newString2 appendString:[NSString stringWithFormat:@"%%%@",[newString1 substringWithRange:range]]];
            }
        }
    }
    
    _searchResultArray=[[NSMutableArray alloc] init];
    
    //数据库查询
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        //NSString *SqlStr=@"select * from POI_new where MC like '%内%蒙%古%人%民%政%府%";
        NSString *SqlStr=[NSString stringWithFormat:@"select * from POInew where MC like '%@%%'",newString2];
        //NSLog(@"Search by :%@",SqlStr);
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                POI *record =[[POI alloc]init];
                char *MC = (char *)sqlite3_column_text(statement, 1);
                record.Name = [[NSString alloc] initWithUTF8String:MC];
                char *X=(char *)sqlite3_column_text(statement, 2);
                record.X =[[[NSString alloc] initWithUTF8String:X] doubleValue];
                char *Y=(char *)sqlite3_column_text(statement, 3);
                record.Y =[[[NSString alloc] initWithUTF8String:Y] doubleValue];
                [_searchResultArray addObject:record];
            }
        }
        //关闭数据库
        sqlite3_close(MyDatabase);
    }
    //load 1000 POI on the map
    [_mapView removeMapLayerWithName:kLAYERNAME_POI];
    AGSGraphicsLayer *POIlayer = [AGSGraphicsLayer graphicsLayer];
    [_mapView addMapLayer:POIlayer withName:kLAYERNAME_POI];
    if (_searchResultArray) {
        int resultCount;
        if (_searchResultArray.count > kSEARCHRESULT_LIMIT) {
            resultCount = kSEARCHRESULT_LIMIT;
        }else{
            resultCount = _searchResultArray.count;
        }
        for (int i =0; i< resultCount; i++) {
            POI *poi = [_searchResultArray objectAtIndex:i];
            AGSPictureMarkerSymbol *sm = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bullet-green.png"];
            AGSPoint *pnt = [AGSPoint pointWithX:poi.X y:poi.Y spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:poi.Name,@"NAME",nil];
            AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:(AGSGeometry *)pnt symbol:sm attributes:attribute];
            [POIlayer addGraphic:graphic];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self search4POI:searchBar.text];
    _SRViewControl.searchResult = _searchResultArray;
    [_SRViewControl.tableView reloadData];
    CGRect rect = CGRectMake(searchBar.frame.origin.x+searchBar.frame.size.width/2, searchBar.frame.origin.y+searchBar.frame.size.height/2+10, 5., 5.);
    [_searchResultPopoverControl presentPopoverFromRect:rect inView:_mapView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //[searchBar resignFirstResponder];
    _SRViewControl.searchResult=nil;
    [_SRViewControl.tableView reloadData];
    AGSGraphicsLayer *graphicLayer = (AGSGraphicsLayer *)[_mapView mapLayerForName:kLAYERNAME_POI];
    [graphicLayer removeAllGraphics];
    [_mapView.callout dismiss];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    CGRect rect = CGRectMake(searchBar.frame.origin.x+searchBar.frame.size.width-30, searchBar.frame.origin.y+searchBar.frame.size.height-20, 10., 10.);
    [_searchResultPopoverControl presentPopoverFromRect:rect inView:_mapView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark- SearchResultPickerDelegate
-(void)searchResultPickerIndex:(NSInteger)index forTableType:(NSInteger)TableType{
    // POIs on the map
    AGSGraphicsLayer *graphicLayer = (AGSGraphicsLayer *)[_mapView mapLayerForName:kLAYERNAME_POI];
    
    AGSGraphic *graphic = [graphicLayer.graphics objectAtIndex:index];
    [self hilightSelectedGraphic:graphic];
    [_mapView zoomToGeometry:graphic.geometry withPadding:1.0 animated:YES];
    CGPoint Offset;
    Offset.x = 0.;
    Offset.y = 0.;
    self.mapView.callout.title = (NSString *)[graphic.allAttributes objectForKey:@"NAME"];
    [self.mapView.callout showCalloutAt:(AGSPoint*)graphic.geometry screenOffset:Offset animated:YES];
}
-(void)hilightSelectedGraphic:(AGSGraphic *)graphic{
    AGSGraphicsLayer *graphicLayer = (AGSGraphicsLayer *)[_mapView mapLayerForName:kLAYERNAME_POI];
    for (AGSGraphic *gra in graphicLayer.graphics) {
        if (gra == graphic) {
            gra.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bullet-red.png"];
        }else{
            gra.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"bullet-green.png"];
        }
    }
    
}
#pragma mark - 编辑功能
//编辑功能
-(void)editorBtn:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[self.editketchLayer removeAllGraphics];
    if(_areaUnitBtn.selected==YES)
    {
        _areaUnitBtn.selected=!_areaUnitBtn.selected;
    }
    if(_distanceUnitBtn.selected==YES)
    {
        _distanceUnitBtn.selected=!_distanceUnitBtn.selected;
    }
    [self setDrawStatus];
    
    if([delegate.currentMapName isEqualToString:@"中国地图集"]==YES||[delegate.currentMapName isEqualToString:@"世界地图集"]==YES||[delegate.currentMapName isEqualToString:@"内蒙地图集"]==YES)
    {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请选择图集内容！"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];
    }
    else
    {
        if(!_editorBtn.selected)
        {
            self.editketchLayer=[AGSSketchGraphicsLayer graphicsLayer];
            self.editketchLayer.geometry = [[AGSMutablePoint alloc] initWithSpatialReference:self.mapView.spatialReference];
            [self.editketchLayer removeAllGraphics];
            [self.mapView addMapLayer:self.editketchLayer withName:@"Editsketchlayer"];
            self.mapView.touchDelegate = self.editketchLayer;
        }
        else
        {
            if(self.editketchLayer.graphics.count>0)
            {
                //弹出窗体
                if(self.editketchLayer.graphics.count>0)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
                    self.editVC = [storyboard instantiateViewControllerWithIdentifier:@"Editor"];
                    //[self.editVC.view setFrame:CGRectMake(0, 0, 100, 200)];
                    self.editVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    //[self.editVC.view setFrame:CGRectMake(0, 0, 100, 200)];
                    self.editVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    self.editVC.delegate=self;
                    [self presentViewController:self.editVC animated:YES completion:nil];
                    //[self presentedViewController:self.editVC ]
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请绘制标绘图形信息！"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                [alert show];
            }
        }
        _editorBtn.selected = !_editorBtn.selected;
    }
}

-(void)EditControllerWasDismissed: (EditController*) featureTemplatePickerViewController
{
    [self.mapView removeMapLayer:self.editketchLayer];
    self.mapView.touchDelegate=self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成编辑
-(void)EditControllerReturnEditorMessage:(EditController *)editorViewController :(NSString *)descriptText :(NSMutableArray *)attachment :(NSString *)Update
{
    NSString *drawDescription=descriptText;
    NSMutableArray *drawAttachment=attachment;
    NSString *drawAttPath=@"";
    if(drawAttachment.count>0)
    {
        for(NSInteger i=0;i<drawAttachment.count;i++)
        {
            NSArray *media=[drawAttachment objectAtIndex:i];
            drawAttPath=[NSString stringWithFormat:@"%@%@|",drawAttPath,media[0]];
        }
    }
    
    AGSSketchGraphicsLayer *editorlayer;
    //遍历maps，获取名称
    NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *lay=[[AGSLayer alloc] init];
        lay=mapLayers[i];
        NSString *name=lay.name;
        if([name isEqualToString: @"Editsketchlayer"] == YES)
        {
            editorlayer=mapLayers[i];
        }
    }
    
    AGSGeometry *editGeo=[editorlayer.geometry copy];
    AGSGraphic *editorGraphic;
    NSString *mediaGeoMetry;
    
    if([editGeo isKindOfClass:[AGSPoint class]])
    {
        editorGraphic=[[AGSGraphic alloc] initWithGeometry:editGeo symbol:nil attributes:nil];
        AGSPoint *mediaPoint=(AGSPoint *)editGeo;
        double mX=mediaPoint.x;
        double mY=mediaPoint.y;
        mediaGeoMetry=[NSString stringWithFormat:@"%@,%@",[NSString stringWithFormat:@"%f",mX],[NSString stringWithFormat:@"%f",mY]];
        
        [self.mapView zoomToGeometry:mediaPoint withPadding:3.0 animated:YES];
    }
    
    NSString* mediaNameID;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddhh:mm:ss"];
    mediaNameID = [formatter stringFromDate:[NSDate date]];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *Atlasname=delegate.currentMapName;
    
    if([Update isEqualToString:@"updata"]==YES)
    {
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            NSString *SqlStrUpdata=[NSString stringWithFormat:@"UPDATE AttachmentTable SET description='%@',attachmentpath='%@' where attid='%@'",drawDescription,drawAttPath,_graphicID];

            if (sqlite3_exec(MyDatabase, [SqlStrUpdata UTF8String], nil, nil, nil) == SQLITE_OK)
            {
                sqlite3_close(MyDatabase);
                
                NSArray *fAttachments=[_graphicAttachments componentsSeparatedByString:@"|" ];
                NSArray *bAttachments=[drawAttPath componentsSeparatedByString:@"|"];
                
                if(fAttachments.count>bAttachments.count)
                {
                    for(NSInteger i=0;i<fAttachments.count-1;i++)
                    {
                        if([self delAttachmet:fAttachments[i] :bAttachments])
                        {
                            
                        }
                        else
                        {
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",paths[0],fAttachments[i]] isDirectory:NO]==YES);
                            {
                                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@",paths[0],fAttachments[i]] error:nil];
                            }
                        }
                    }
                }
            }
            else
            {
                sqlite3_close(MyDatabase);
            }
        }
    }
    else
    {
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            NSString *SqlStrInsert=[NSString stringWithFormat:@"insert into  AttachmentTable(description,attachmentpath,atlasname,attid,geotype,geometry)values('%@','%@','%@','%@','%@','%@')",drawDescription,drawAttPath,Atlasname,mediaNameID,@"点",mediaGeoMetry];
            //sqlite3_stmt *statement;
            if (sqlite3_exec(MyDatabase, [SqlStrInsert UTF8String], nil, nil, nil) == SQLITE_OK)
            {
                sqlite3_close(MyDatabase);
            }
            else
            {
                sqlite3_close(MyDatabase);
            }
        }
    }
    
    //数据库操作
    self.mapView.touchDelegate=self;
    
    //遍历maps，获取名称
    //NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *lay=[[AGSLayer alloc] init];
        lay=mapLayers[i];
        NSString *name=lay.name;
        if([name isEqualToString: @"Editsketchlayer"] == YES)
        {
            [self.mapView removeMapLayerWithName:name];
            //[self.mapView removeMapLayer:self.editketchLayer];
        }
    }
    [self showDrawInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//判断更新是否删除原有附件
-(BOOL)delAttachmet:(NSString *)path :(NSArray *)batts
{
    BOOL isaaa=NO;

    for(NSInteger i=0;i<batts.count-1;i++)
    {
        if([path isEqualToString:batts[i]]==YES)
        {
            isaaa= YES;
            break;
        }
    }
    return isaaa;
}

-(void)delgraphic:(EditController *)editorViewController :(NSString *)graID
{
    //删除附件
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        NSString *SqlStr=[NSString stringWithFormat:@"select * from  AttachmentTable where attid='%@'",graID];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *attachmentpath=(char *)sqlite3_column_text(statement, 2);
                NSString *attachmentpathStr=[[NSString alloc] initWithUTF8String:attachmentpath];
                
                NSArray *attachments=[attachmentpathStr componentsSeparatedByString:@"|"];
                for(NSInteger i=0;i<attachments.count-1;i++)
                {
                    NSString *filePath=attachments[i];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",paths[0],filePath] isDirectory:NO]==YES);
                    {
                        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@",paths[0],filePath] error:nil];
                    }
                }
            }
        }
        sqlite3_close(MyDatabase);
    }

    //删除数据
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        NSString *sqlDel=[NSString stringWithFormat:@"delete  from  AttachmentTable where attid='%@'",graID];
        if(sqlite3_exec(MyDatabase, [sqlDel UTF8String], nil, nil, nil)== SQLITE_OK)
        {
            sqlite3_close(MyDatabase);
        }
    }
    
    [self showDrawInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//显示查询结果
-(void)showDrawInfo
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegate.isShowDrawInfo==YES)
    {
        NSArray *mapLayers=[self.mapView mapLayers];
        for(NSInteger i=0;i<mapLayers.count;i++)
        {
            AGSLayer *maplayer=mapLayers[i];
            if([maplayer.name isEqualToString:kLAYERNAME_DRAWGRAPHIC]==YES)
            {
                [self.mapView removeMapLayer:maplayer];
            }
        }
    
        AGSGraphicsLayer *graphicLayer=[AGSGraphicsLayer graphicsLayer];
    
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *Atlasname=delegate.currentMapName;
    
        NSArray *graphicKey=[[NSArray alloc] initWithObjects:@"description",@"attachmentpath",@"atlasname",@"attid",@"geotype",@"geometry",nil];
        NSArray *graphicValue;
    
        AGSGeometry *mediaGeo;
        AGSGraphic *mediaGraphic;
    
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            NSString *SqlStr=[NSString stringWithFormat:@"select * from  AttachmentTable where atlasname='%@'",Atlasname];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *description = (char *)sqlite3_column_text(statement, 1);
                    NSString *descriptionStr = [[NSString alloc] initWithUTF8String:description];
                    char *attachmentpath=(char *)sqlite3_column_text(statement, 2);
                    NSString *attachmentpathStr=[[NSString alloc] initWithUTF8String:attachmentpath];
                    char *atlasname=(char *)sqlite3_column_text(statement, 3);
                    NSString *atlasnameStr=[[NSString alloc] initWithUTF8String:atlasname];
                    char *attid=(char *)sqlite3_column_text(statement, 4);
                    NSString *attidStr=[[NSString alloc] initWithUTF8String:attid];
                    char *geotype=(char *)sqlite3_column_text(statement, 5);
                    NSString *geotypeStr=[[NSString alloc] initWithUTF8String:geotype];
                    AGSPictureMarkerSymbol *picMarker;
                    char *geometry=(char *)sqlite3_column_text(statement, 6);
                    NSString *geometryStr=[[NSString alloc] initWithUTF8String:geometry];
                    if([geotypeStr isEqualToString:@"点"]==YES)
                    {
                        NSArray *pointArray=[geometryStr componentsSeparatedByString:@","];
                        double px=[pointArray[0] doubleValue];
                        double py=[pointArray[1] doubleValue];
                        AGSPoint *point=[[AGSPoint alloc] initWithX:px y:py spatialReference:self.mapView.spatialReference];
                        mediaGeo=point;
                        picMarker=[AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed: @"marker.png"];
                    }
                
                    graphicValue=[[NSArray alloc] initWithObjects:descriptionStr,attachmentpathStr,atlasnameStr, attidStr,geotypeStr,geometryStr,nil];
                    NSDictionary *attributes=[[NSDictionary alloc] initWithObjects:graphicValue forKeys:graphicKey];
                    mediaGraphic=[[AGSGraphic alloc] initWithGeometry:mediaGeo symbol:picMarker attributes:attributes];
                
                    [graphicLayer addGraphic:mediaGraphic];
                }
            }
            sqlite3_close(MyDatabase);
        }
        [self.mapView addMapLayer:graphicLayer withName:kLAYERNAME_DRAWGRAPHIC];
    }
    else
    {
        NSArray *mapLayers=[self.mapView mapLayers];
        for(NSInteger i=0;i<mapLayers.count;i++)
        {
            AGSLayer *maplayer=mapLayers[i];
            if([maplayer.name isEqualToString:kLAYERNAME_DRAWGRAPHIC ]==YES)
            {
                [self.mapView removeMapLayer:maplayer];
            }
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.UnitsketchLayer removeAllGraphics];
        [self.mapView removeMapLayerWithName:@"Unitsketchlayer"];
    }
}

//数据库路径
- (NSString *)DBfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"NMAtlas.sqlite"];
}

//地图集路径
- (NSString *)AtlasfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

- (void)refreshUI
{
//LocationButton
    [self.locationBtn setFrame:CGRectMake(self.mapView.frame.size.width - 60, self.mapView.frame.size.height -60, 48.0, 48.0)];
}

//LicenseInfo
- (void) setLicense
{
    //许可级别：Developer|Basic|Standard
    AGSLicenseLevel lvl = [[AGSRuntimeEnvironment license] licenseLevel];
    if (lvl  == AGSLicenseLevelDeveloper)
    {
        NSError *error;
        //应用注册号：Client ID
        NSString *clientID = @"ZQQO1Ar6tpZar12Y";
        [AGSRuntimeEnvironment setClientID:clientID error:&error];
        if(error)
        {
            NSLog(@"错误,无效的client ID!");
        }
        //标准版许可号
        NSString *standardLicenseCode = @"runtimestandard,102,XXXXXXX";
        AGSLicenseResult result = [[AGSRuntimeEnvironment license] setLicenseCode:standardLicenseCode];
        if (result != AGSLicenseResultValid)
        {
            NSLog(@"错误,无效的标准版许可号!");
        }
    }
}

#pragma mark - EditorViewControllerDelegate methods

-(void)editorViewController:(EditorViewController*) editorViewController didSelectFeatureTemplate:(AGSFeatureTemplate*)template forLayer:(id<AGSGDBFeatureSourceInfo>)layer
{
    AGSGDBFeatureTable* fTable = (AGSGDBFeatureTable*) layer;
    AGSGDBFeature* feature = [fTable featureWithTemplate:template];
    
    //获取当前地图名称
    AGSLayer *clayer=[[AGSLayer alloc] init];
    NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        clayer=mapLayers[i];
        NSString *layername=clayer.name;
        NSLog(@"layname=%@",layername);
    }
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *cLayerName=delegate.currentMapName;
    
    [feature setAttributeWithString:cLayerName forKey:@"地图名称"];
    //NSDictionary *fa=feature.allAttributes;

    AGSPopupInfo *pi = [AGSPopupInfo popupInfoForGDBFeatureTable:fTable];
    AGSPopup *p = [[AGSPopup alloc]initWithGDBFeature:feature popupInfo:pi];
    
    self.popupsVC = [[AGSPopupsContainerViewController alloc] initWithPopups:@[p] usingNavigationControllerStack:NO];
    self.popupsVC.delegate = self;
    self.popupsVC.modalPresentationStyle = UIModalPresentationFormSheet;
    self.popupsVC.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    
    //First, dismiss the Feature Template Picker
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //Next, Present the popup view controller
    [self presentViewController:self.popupsVC animated:YES completion:nil];
    [self.popupsVC startEditingCurrentPopup];
}

-(void)editorViewControllerWasDismissed: (EditorViewController*) featureTemplatePickerViewController
{
    isEditBtnClick=NO;
    [_editorBtn setBackgroundImage:[UIImage imageNamed:@"editorOn.png"] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPopupsVCForPopups:(NSArray*)popups
{
    _popupsVC = [[AGSPopupsContainerViewController alloc]initWithPopups:popups usingNavigationControllerStack:NO];
    _popupsVC.delegate = self;
    _popupsVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _popupsVC.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    //_popupsVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self presentViewController:_popupsVC animated:YES completion:nil];
}

-(void)popupsContainerDidFinishViewingPopups:(id<AGSPopupsContainer>)popupsContainer
{
    self.mapView.touchDelegate=self;
    [self.popupsVC dismissViewControllerAnimated:YES completion:nil];
}

-(AGSGeometry *)popupsContainer:(id<AGSPopupsContainer>)popupsContainer wantsNewMutableGeometryForPopup:(AGSPopup *)popup
{
    switch (popup.gdbFeatureSourceInfo.geometryType)
    {
        case AGSGeometryTypePoint:
            return [[AGSMutablePoint alloc]initWithSpatialReference:self.mapView.spatialReference];
            break;
        case AGSGeometryTypePolygon:
            return [[AGSMutablePolygon alloc]initWithSpatialReference:self.mapView.spatialReference];
            break;
        case AGSGeometryTypePolyline:
            return [[AGSMutablePolyline alloc]initWithSpatialReference:self.mapView.spatialReference];
            break;
        default:
            return [[AGSMutablePoint alloc]initWithSpatialReference:self.mapView.spatialReference];
            break;
    }
}

-(void) popupsContainer:(id<AGSPopupsContainer>)popupsContainer readyToEditGeometry:(AGSGeometry *)geometry forPopup:(AGSPopup *)popup
{
    if (!_sgl)
    {
        _sgl = [[AGSSketchGraphicsLayer alloc]initWithGeometry:geometry];
        [_mapView addMapLayer:_sgl withName:@"editorSGLayer"];
        _mapView.touchDelegate = _sgl;
    }
    else
    {
        _sgl.geometry = geometry;
    }
    
    [self.popupsVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)popupsContainer:(id<AGSPopupsContainer>)popupsContainer didFinishEditingForPopup:(AGSPopup*)popup
{
    // Remove sketch layer
    [self.mapView removeMapLayer:_sgl];
    //self.sgl = nil;
    self.mapView.touchDelegate = self;
    
    [self.popupsVC dismissViewControllerAnimated:YES completion:nil];

}


-(void)showPopupsForFeatures:(NSArray*)features
{
    NSMutableArray *popups = [NSMutableArray arrayWithCapacity:features.count];
    
    for (id<AGSFeature> feature in features)
    {
        AGSPopup* popup;
        AGSGDBFeature* gdbFeature = (AGSGDBFeature*)feature;
        AGSPopupInfo* popupInfo = [AGSPopupInfo popupInfoForGDBFeatureTable:gdbFeature.table];
        popup = [AGSPopup popupWithGDBFeature:gdbFeature popupInfo:popupInfo];
        [popups addObject:popup];
    }
    
    [self showPopupsVCForPopups:popups];
}

-(void)popupsContainer:(id<AGSPopupsContainer>)popupsContainer didCancelEditingForPopup:(AGSPopup *)popup
{
    [_mapView removeMapLayer:_sgl];
    _sgl = nil;
    _mapView.touchDelegate = self;
    [self.popupsVC dismissViewControllerAnimated:YES completion:nil];
    _editorBtn.selected = YES;
}

//设置标绘、测量、测距状态
-(void)setDrawStatus
{
    NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *mapLayer=mapLayers[i];
        if([mapLayer.name isEqualToString:@"Unitsketchlayer"]==YES||[mapLayer.name isEqualToString:@"aaaaa"]==YES)
        {
            [self.mapView removeMapLayer:mapLayer];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
