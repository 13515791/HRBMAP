//
//  ChinaAtlasWidget.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-8-26.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "ChinaAtlasWidget.h"
#import "AppEvent.h"
#import "AppEventNames.h"
#import <UIKit/UIKit.h>
#import "TBXML.h"

@implementation ChinaAtlasWidget

@synthesize PArrayList,CArrayList;
@synthesize CityList;
@synthesize datasetPoint=_datasetPoint;
@synthesize datasetLine=_datasetLine;
@synthesize datasetPolygon=_datasetPolygon;
@synthesize agspadview=_agspadview;
-(void) create
{
    [super create];
	self.isAutoInactive = YES;
    [self LoadProvince];
}

-(void) active
{
    [super active];
}

-(void) inactive
{
	[super inactive];
}

-(void)LoadProvince
{
    isView=@"Province";
    PArrayList=[[NSMutableArray alloc] init];
    //数据库查询
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        NSString *SqlStr=[NSString stringWithFormat:@"select DISTINCT ProviceName from CAData"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //test=[[NSArray alloc] init];
                char *MC = (char *)sqlite3_column_text(statement, 0);
                NSString *MCStr = [[NSString alloc] initWithUTF8String:MC];
                [PArrayList addObject:MCStr];
            }
        }
        //关闭数据库
        sqlite3_close(MyDatabase);
    }
}

-(ChinaAtlasWidget *) initLoadProvince:(NSMutableArray*) aParrayList :(NSString *) view
{
    self = [super init];
    if (self)
    {
        isView=[view copy];
        PArrayList = [aParrayList copy];
        [self LoadProvince];
    }
    return self;
}

-(void)LoadCity:(NSString *) ProvinceName
{
    CArrayList=[[NSMutableArray alloc] init];
    //数据库查询
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        NSString *SqlStr=[NSString stringWithFormat:@"select * from CAData where ProviceName='%@'",ProvinceName];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *CityName = (char *)sqlite3_column_text(statement, 1);
                NSString *CityNameStr = [[NSString alloc] initWithUTF8String:CityName];
                char *ProvinceName = (char *)sqlite3_column_text(statement, 2);
                NSString *ProvinceNameStr = [[NSString alloc] initWithUTF8String:ProvinceName];
                char *AtlasPath = (char *)sqlite3_column_text(statement, 3);
                NSString *AtlasPathStr = [[NSString alloc] initWithUTF8String:AtlasPath];
                char *ImgPath = (char *)sqlite3_column_text(statement, 4);
                NSString *ImgPathStr = [[NSString alloc] initWithUTF8String:ImgPath];
                
                NSArray *CityItem=[[NSArray alloc] init];
                CityItem=[NSArray arrayWithObjects:CityNameStr,ProvinceNameStr,AtlasPathStr, ImgPathStr,nil];
                [CArrayList addObject:CityItem];
            }
        }
        //关闭数据库
        sqlite3_close(MyDatabase);
    }
}

-(ChinaAtlasWidget *) initLoadCity:(NSMutableArray*) aCityList :(NSString*)Pname :(NSString *) view :(AGSMapView *) dd
{
    //self = [super init];
    self=[super init];
    if (self)
    {
        mapv=dd;
        CArrayList = [aCityList copy];
        isView=[view copy];
        [self LoadCity:Pname];
    }
    return self;
}

-(ChinaAtlasWidget *) initLoadCity1
{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self LoadProvince];
    //mapv=self.mapView;
    CityTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    CityTableView.backgroundColor = [UIColor clearColor];
    CityTableView.delegate = self;
    CityTableView.dataSource = self;
    [self setExtraCellLineHidden:CityTableView];
    //isView=@"Province";
    
    if([isView isEqualToString:@"City"]==YES)
    {
        UIToolbar *headerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];

        // Add them to the toolbar.
        [headerToolbar setItems:[NSArray arrayWithObjects:cancelButton, nil]];
        [self.view addSubview:headerToolbar];
    }
}



//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    if([isView isEqualToString:@"Province"]==YES)
    {
        if (PArrayList.count == 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 0;
        }
        return [PArrayList count];
    }
    else
    {
        if (CArrayList.count == 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 0;
        }
        return [CArrayList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = WIDGET_CONTENTCELLBACKGROUNDCOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.font = WIDGET_CONTENTFONT;
    }
    
    if([isView isEqualToString:@"City"]==YES)
    {
        NSArray *cityArray=[[NSArray alloc] initWithArray:[CArrayList objectAtIndex:indexPath.row]];
        cell.textLabel.text=[cityArray objectAtIndex:0];
    }
    else
    {
        cell.textLabel.text=[PArrayList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChinaAtlasWidget *contentViewController = nil;
    NSString *PName=[PArrayList objectAtIndex:indexPath.row];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([isView isEqualToString:@"Province"]==YES)
    {
        //[self mapcontrl];
        contentViewController=[[[ChinaAtlasWidget alloc] init] initLoadCity:CArrayList :PName:@"City":self.mapView];
        [[self navigationController] pushViewController:contentViewController animated:NO];
    }
    else
    {
        //AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                
        NSArray *cityItem=[[NSArray alloc] initWithArray:[CArrayList objectAtIndex:indexPath.row]];
        NSString *CityName=[cityItem objectAtIndex:0];
        delegate.currentMapName=CityName;
        NSString *AtlasPath=[cityItem objectAtIndex:2];

        //移除baselayer
        AGSLayer *baseLayer=[mapv baseLayer];
        [mapv removeMapLayer:baseLayer];

        NSString * doc=[self AtlasfilePath];
        NSString *filePath=[NSString stringWithFormat:@"%@%@",doc, AtlasPath];
        AGSLocalTiledLayer* layer = [AGSLocalTiledLayer localTiledLayerWithPath:filePath];
        [mapv insertMapLayer:layer withName:@"中国地图集" atIndex:0];
        AGSEnvelope *ae=layer.fullEnvelope;
        [mapv zoomToEnvelope:ae animated:true];
        
        AGSEnvelope *mapenv=[[AGSEnvelope alloc] initWithXmin:9793569.1332 ymin:4067831.5632 xmax:14996346.2055 ymax:7564571.89 spatialReference:mapv.spatialReference];
        [mapv zoomToEnvelope:layer.fullEnvelope animated:true];
        [mapv zoomToEnvelope:mapenv animated:true];
        
        [mapv setMinScale:20000000];
        [mapv setMaxScale:2641654.627735];
        
        [self showDrawInfo];

    }
}

-(void)getResult:(NSArray *)featuresDataSource
{
    if(featuresDataSource.count>0)
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate.drawGraphicLayer removeAllGraphics];
        
        AGSFeatureSet *featureSet=[[AGSFeatureSet alloc] initWithFeatures:featuresDataSource];
        NSArray *features=[featureSet features];
        
        for(NSInteger i=0;i<features.count;i++)
        {
            AGSGraphic *graphic=features[i];
            if([[graphic attributeForKey:@"地图名称"] isEqualToString:@"内蒙区域全图"]==YES)
            {
                if(featureSet.geometryType==AGSGeometryTypePoint)
                {
                    AGSPictureMarkerSymbol *pt=[AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"marker.png"];
                    [graphic setSymbol:pt];
                    [delegate.drawGraphicLayer addGraphic:graphic];
                }
            }
        }
    }
}

- (void)cancelButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
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

//TableView隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [self.contentView addSubview:tableView];
}

//显示查询结果
-(void)showDrawInfo
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegate.isShowDrawInfo==YES)
    {
    NSArray *mapLayers=[mapv mapLayers];
    
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *maplayer=mapLayers[i];
        if([maplayer.name isEqualToString:kLAYERNAME_DRAWGRAPHIC]==YES)
        {
            [mapv removeMapLayer:maplayer];
        }
    }
    
    AGSGraphicsLayer *graphicLayer=[AGSGraphicsLayer graphicsLayer];
    
    //[self.mapView removeMapLayer:_editGraphicLayer];
    //_editGraphicLayer=[AGSGraphicsLayer graphicsLayer];
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
    [mapv addMapLayer:graphicLayer withName:kLAYERNAME_DRAWGRAPHIC];
    }
}
@end
