//
//  NMAtlasWidget.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-9.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "NMAtlasWidget.h"

@implementation NMAtlasWidget
@synthesize CityList=_CityList;
@synthesize CountyList=_CountyList;

-(void) create
{
    [super create];
	self.isAutoInactive = YES;
    [self LoadCity];
}

-(void) active
{
    [super active];
}

-(void) inactive
{
	[super inactive];
}

-(void)LoadCity
{
    isView=@"City";
    _CityList=[[NSMutableArray alloc] init];
    //数据库查询
    if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
    {
        NSString *SqlStr=[NSString stringWithFormat:@"select DISTINCT CityName from tttt"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //test=[[NSArray alloc] init];
                char *MC = (char *)sqlite3_column_text(statement, 0);
                NSString *MCStr = [[NSString alloc] initWithUTF8String:MC];
                [_CityList addObject:MCStr];
            }
        }
        //关闭数据库
        sqlite3_close(MyDatabase);
    }
}

-(NMAtlasWidget *) initLoadCity:(NSMutableArray*) aCityList :(NSString*)Pname :(NSString *) view :(AGSMapView *) dd
{
    //self = [super init];
    self=[super init];
    if (self)
    {
        mapv=dd;
        _CountyList = [aCityList copy];
        isView=[view copy];
        //[self LoadCity:Pname];
        
        _CountyList=[[NSMutableArray alloc] init];
        
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            NSString *SqlStr=[NSString stringWithFormat:@"select * from tttt where CityName='%@'",Pname];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *CityName = (char *)sqlite3_column_text(statement, 1);
                    NSString *CityNameStr = [[NSString alloc] initWithUTF8String:CityName];
                    char *CountyName = (char *)sqlite3_column_text(statement, 2);
                    NSString *CountyNameStr = [[NSString alloc] initWithUTF8String:CountyName];
                    char *AtlasPath = (char *)sqlite3_column_text(statement, 3);
                    NSString *AtlasPathStr = [[NSString alloc] initWithUTF8String:AtlasPath];
                    char *ImgPath = (char *)sqlite3_column_text(statement, 4);
                    NSString *ImgPathStr = [[NSString alloc] initWithUTF8String:ImgPath];
                    
                    NSArray *CityItem=[[NSArray alloc] init];
                    CityItem=[NSArray arrayWithObjects:CityNameStr,CountyNameStr,AtlasPathStr, ImgPathStr,nil];
                    [_CountyList addObject:CityItem];
                }
            }
            //关闭数据库
            sqlite3_close(MyDatabase);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NMtableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    NMtableView.backgroundColor = [UIColor clearColor];
    NMtableView.delegate = self;
    NMtableView.dataSource = self;
    [self.contentView addSubview:NMtableView];
    
    if([isView isEqualToString:@"County"]==YES)
    {
        UIToolbar *headerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
        // Add them to the toolbar.
        [headerToolbar setItems:[NSArray arrayWithObjects:cancelButton, nil]];
        [self.view addSubview:headerToolbar];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([isView isEqualToString:@"City"]==YES)
    {
        return [_CityList count];
    }
    else
    {
        return [_CountyList count];
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
        cell.textLabel.font = WIDGET_CONTENTFONT;
        cell.backgroundColor = WIDGET_CONTENTCELLBACKGROUNDCOLOR;
    }
    
    if([isView isEqualToString:@"County"]==YES)
    {
        NSArray *cityArray=[[NSArray alloc] initWithArray:[_CountyList objectAtIndex:indexPath.row]];
        cell.textLabel.text=[cityArray objectAtIndex:1];
    }
    else
    {
        cell.textLabel.text=[_CityList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMAtlasWidget *contentViewController = nil;
    NSString *CityName=[_CityList objectAtIndex:indexPath.row];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([isView isEqualToString:@"City"]==YES)
    {
        contentViewController=[[[NMAtlasWidget alloc] init] initLoadCity:_CityList :CityName:@"County":self.mapView ];
        [[self navigationController] pushViewController:contentViewController animated:NO];
    }
    else
    {
        NSArray *cityItem=[[NSArray alloc] initWithArray:[_CountyList objectAtIndex:indexPath.row]];
        NSString *CityName=[cityItem objectAtIndex:1];
        delegate.currentMapName=CityName;
        NSString *AtlasPath=[cityItem objectAtIndex:2];
        
        //移除baselayer
        AGSLayer *baseLayer=[mapv baseLayer];
        [mapv removeMapLayer:baseLayer];
        
        NSString * doc=[self AtlasfilePath];
        NSString *filePath=[NSString stringWithFormat:@"%@%@",doc, AtlasPath];
        AGSLocalTiledLayer* layer = [AGSLocalTiledLayer localTiledLayerWithPath:filePath];
        [mapv insertMapLayer:layer withName:@"内蒙地图集" atIndex:0];
        AGSEnvelope *mapenv=[[AGSEnvelope alloc] initWithXmin:9793569.1332 ymin:4067831.5632 xmax:14996346.2055 ymax:7564571.89 spatialReference:mapv.spatialReference];
        [mapv zoomToEnvelope:layer.fullEnvelope animated:true];
        [mapv zoomToEnvelope:mapenv animated:true];

        [mapv setMinScale:20000001];
        [mapv setMaxScale:2641654.627735];
        
        [self showDrawInfo];
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

//显示查询结果
-(void)showDrawInfo
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegate.isShowDrawInfo==YES)
    {
        /*
    NSArray *mapLayers=[mapv mapLayers];
    
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *maplayer=mapLayers[i];
        NSLog(@"layer name=%@",maplayer.name);
        if([maplayer isKindOfClass:[AGSGraphicsLayer class]]==YES)
        {
            [mapv removeMapLayer:maplayer];
        }
    }
    */
    [mapv removeMapLayerWithName:kLAYERNAME_DRAWGRAPHIC];
        
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
