//
//  WorldAtlasWidget.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-8-18.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "WorldAtlasWidget.h"
#import "AppEvent.h"
#import "AppEventNames.h"
#import <UIKit/UIKit.h>
#import "TBXML.h"

@implementation WorldAtlasWidget
-(void) create
{
    [super create];
	self.isAutoInactive = YES;
    
}

-(void) active
{
    [super active];
}

-(void) inactive
{
	[super inactive];	
}
@synthesize delegate=_delegate;
@synthesize dataArrayA,dataArrayB,dataArrayC,dataArrayD,dataArrayE,dataArrayF,dataArrayG,dataArrayH,dataArrayJ,dataArrayK,dataArrayL,dataArrayM,dataArrayN,dataArrayP,dataArrayR,dataArrayS,dataArrayT,dataArrayW,dataArrayX,dataArrayY,dataArrayZ;
@synthesize indexArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSArray *arrayWorld=[[NSArray alloc] initWithObjects:@"世界地形",@"世界政区",nil];
    NSArray *arrayA=[[NSArray alloc] initWithObjects:@"阿尔巴尼亚",@"阿尔及利亚",@"阿富汗",@"阿根廷",@"阿拉伯联合酋长国",@"阿曼",@"阿塞拜疆",@"埃及",@"埃塞俄比亚",@"爱尔兰",@"爱沙尼亚",@"安道尔",@"安哥拉",@"奥地利",@"澳大利亚",nil];
    NSArray *arrayB=[[NSArray alloc] initWithObjects:@"巴布亚新几内亚",@"巴哈马",@"巴基斯坦",@"巴拉圭",@"巴勒斯坦",@"巴林",@"巴拿马",@"巴西",@"白俄罗斯",@"百慕大群岛",@"保加利亚",@"贝宁",@"比利时",@"冰岛",@"波黑共和国",@"波兰",@"玻利维亚",@"伯利兹",@"博茨瓦纳",@"不丹",@"布基纳法索",@"布隆迪",@"秘鲁",nil];
    NSArray *arrayC=[[NSArray alloc] initWithObjects:@"朝鲜",@"赤道几内亚",nil];
    NSArray *arrayD=[[NSArray alloc] initWithObjects:@"丹麦",@"德国",@"东帝汶",@"多哥",@"多米尼加",nil];
    NSArray *arrayE=[[NSArray alloc] initWithObjects:@"俄罗斯",@"俄罗斯西部",@"厄瓜多尔",@"厄立特里亚",nil];
    NSArray *arrayF=[[NSArray alloc] initWithObjects:@"法国",@"法罗群岛",@"法属圭亚那",@"梵蒂冈",@"菲律宾",@"芬兰",nil];
    NSArray *arrayG=[[NSArray alloc] initWithObjects:@"冈比亚",@"刚果",@"刚果民主共和国",@"哥伦比亚",@"哥斯达黎加",@"格恩西岛",@"格林纳达",@"格陵兰岛",@"格鲁吉亚",@"古巴",@"圭亚那",nil];
    NSArray *arrayH=[[NSArray alloc] initWithObjects:@"哈萨克斯坦",@"韩国",@"荷兰",@"洪都拉斯",nil];
    NSArray *arrayJ=[[NSArray alloc] initWithObjects:@"吉尔吉斯斯坦",@"几内亚",@"几内亚比绍",@"加拿大",@"加纳",@"加蓬",@"柬埔寨",@"捷克共和国",@"津巴布韦",nil];
    NSArray *arrayK=[[NSArray alloc] initWithObjects:@"喀麦隆",@"卡塔尔",@"科摩罗",@"科特迪瓦",@"科威特",@"克罗地亚",nil];
    NSArray *arrayL=[[NSArray alloc] initWithObjects:@"罗马尼亚",@"拉脱维亚",@"莱索托",@"老挝",@"黎巴嫩",@"立陶宛",@"利比里亚",@"利比亚",@"列支敦士登",@"留尼汪岛",@"卢森堡",@"卢旺达",nil];
    NSArray *arrayM=[[NSArray alloc] initWithObjects:@"马达加斯加",@"马尔代夫",@"马达加斯加",@"马拉维",@"马来西亚",@"马里",@"马其顿",@"毛里求斯",@"毛里塔尼亚",@"美国",@"美国东部",@"美国西部",@"蒙古",@"孟加拉国",@"缅甸",@"摩尔多瓦",@"摩洛哥",@"摩纳哥",@"莫桑比克",@"墨西哥",@"纳米比亚",nil];
    NSArray *arrayN=[[NSArray alloc] initWithObjects:@"纳米比亚",@"南非",@"南苏丹",@"尼泊尔",@"尼加拉瓜",@"尼日尔",@"尼日利亚",@"挪威",nil];
    NSArray *arrayP=[[NSArray alloc] initWithObjects:@"葡萄牙",nil];
    NSArray *arrayR=[[NSArray alloc] initWithObjects:@"日本",@"瑞典",@"瑞士",nil];
    NSArray *arrayS=[[NSArray alloc] initWithObjects:@"世界政区",@"世界地形",@"萨尔瓦多",@"塞尔维亚和黑山",@"塞拉利昂",@"塞内加尔",@"塞浦路斯",@"塞舌尔",@"沙特阿拉伯",@"圣多美和普林西比",@"圣马利诺",@"斯里兰卡",@"斯洛伐克",@"斯洛文尼亚",@"斯威士兰",@"苏丹",@"苏里南",@"所罗门群岛",@"索马里",@"纳米比亚",nil];
    NSArray *arrayT=[[NSArray alloc] initWithObjects:@"太平洋主要岛屿",@"塔吉克斯坦",@"泰国",@"坦桑尼亚",@"突尼斯",@"土耳其",@"土库曼斯坦",nil];
    NSArray *arrayW=[[NSArray alloc] initWithObjects:@"危地马拉",@"委内瑞拉",@"文莱达鲁萨兰国",@"乌干达",@"乌克兰",@"乌拉圭",@"乌兹别克斯坦",nil];
    NSArray *arrayX=[[NSArray alloc] initWithObjects:@"西班牙",@"西撒哈拉",@"希腊",@"新加坡",@"新西兰",@"匈牙利",@"叙利亚",nil];
    NSArray *arrayY=[[NSArray alloc] initWithObjects:@"亚美尼亚",@"也门",@"伊拉克",@"伊朗",@"以色列",@"意大利",@"印度",@"印度尼西亚",@"英国",@"约旦",@"越南",nil];
    NSArray *arrayZ=[[NSArray alloc] initWithObjects:@"赞比亚",@"乍得",@"智利",@"中非共和国",@"中国",@"意大利",nil];
    NSArray *indexArrayContent=[[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z",nil];
    
    //self.dataArrayWorld=arrayWorld;
    self.dataArrayA=arrayA;
    self.dataArrayB=arrayB;
    self.dataArrayC=arrayC;
    self.dataArrayD=arrayD;
    self.dataArrayE=arrayE;
    self.dataArrayF=arrayF;
    self.dataArrayG=arrayG;
    self.dataArrayH=arrayH;
    self.dataArrayJ=arrayJ;
    self.dataArrayK=arrayK;
    self.dataArrayL=arrayL;
    self.dataArrayM=arrayM;
    self.dataArrayN=arrayN;
    self.dataArrayP=arrayP;
    self.dataArrayR=arrayR;
    self.dataArrayS=arrayS;
    self.dataArrayT=arrayT;
    self.dataArrayW=arrayW;
    self.dataArrayX=arrayX;
    self.dataArrayY=arrayY;
    self.dataArrayZ=arrayZ;
    //self.dataArrayY=arrayY;
    
    //给数组赋值
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:21];
    self.indexArray = array;
    [indexArray addObjectsFromArray:indexArrayContent];
    
    //添加世界国家列表
    worldTableView=[[UITableView alloc] initWithFrame:self.contentView.bounds];
    worldTableView.backgroundColor = [UIColor clearColor];
    worldTableView.delegate = self;
    worldTableView.dataSource = self;
    [self.contentView addSubview:worldTableView];
}

//设置Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [indexArray objectAtIndex:section];
    return key;
}

//设置表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 21;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return dataArrayA.count;
    }
    else if(section==1)
    {
        return dataArrayB.count;
    }
    else if(section==2)
    {
        return dataArrayC.count;
    }
    else if(section==3)
    {
        return dataArrayD.count;
    }
    else if(section==4)
    {
        return dataArrayE.count;
    }
    else if(section==5)
    {
        return dataArrayF.count;
    }
    else if(section==6)
    {
        return dataArrayG.count;
    }
    else if(section==7)
    {
        return dataArrayH.count;
    }
    else if(section==8)
    {
        return self.dataArrayJ.count;
    }
    else if(section==9)
    {
        return self.dataArrayK.count;
    }
    else if(section==10)
    {
        return self.dataArrayL.count;
    }
    else if(section==11)
    {
        return self.dataArrayM.count;
    }
    else if(section==12)
    {
        return self.dataArrayN.count;
    }
    else if(section==13)
    {
        return self.dataArrayP.count;
    }
    else if(section==14)
    {
        return self.dataArrayR.count;
    }
    else if(section==15)
    {
        return self.dataArrayS.count;
    }
    else if(section==16)
    {
        return self.dataArrayT.count;
    }
    else if(section==17)
    {
        return self.dataArrayW.count;
    }
    else if(section==18)
    {
        return self.dataArrayX.count;
    }
    else if(section==19)
    {
        return self.dataArrayY.count;
    }
    else if(section==20)
    {
        return self.dataArrayZ.count;
    }
    else
    {
        return 0;
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
    if(indexPath.section==0)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayA objectAtIndex:indexPath.row];
    else if(indexPath.section==1)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayB objectAtIndex:indexPath.row];
    else if(indexPath.section==2)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayC objectAtIndex:indexPath.row];
    else if(indexPath.section==3)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayD objectAtIndex:indexPath.row];
    else if(indexPath.section==4)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayE objectAtIndex:indexPath.row];
    else if(indexPath.section==5)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayF objectAtIndex:indexPath.row];
    else if(indexPath.section==6)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayG objectAtIndex:indexPath.row];
    else if(indexPath.section==7)
        //设置单元格的字符串内
        cell.textLabel.text=[self->dataArrayH objectAtIndex:indexPath.row];
    else if(indexPath.section==8)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayJ objectAtIndex:indexPath.row];
    else if(indexPath.section==9)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayK objectAtIndex:indexPath.row];
    else if(indexPath.section==10)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayL objectAtIndex:indexPath.row];
    else if(indexPath.section==11)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayM objectAtIndex:indexPath.row];
    else if(indexPath.section==12)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayN objectAtIndex:indexPath.row];
    else if(indexPath.section==13)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayP objectAtIndex:indexPath.row];
    else if(indexPath.section==14)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayR objectAtIndex:indexPath.row];
    else if(indexPath.section==15)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayS objectAtIndex:indexPath.row];
    else if(indexPath.section==16)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayT objectAtIndex:indexPath.row];
    else if(indexPath.section==17)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayW objectAtIndex:indexPath.row];
    else if(indexPath.section==18)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayX objectAtIndex:indexPath.row];
    else if(indexPath.section==19)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayY objectAtIndex:indexPath.row];
    else if(indexPath.section==20)
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayZ objectAtIndex:indexPath.row];
    else
        //设置单元格的字符串内容
        cell.textLabel.text=[self->dataArrayA objectAtIndex:indexPath.row];
    return cell;
}


//获取选中值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UITableViewCell *Call = [tableView cellForRowAtIndexPath:indexPath];
    NSString *calltext=Call.textLabel.text;
    NSString *tpkRound=[self NetGISerstateName:calltext];
    delegate.worldTpkPath=tpkRound;
    NSString* pListPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString* path = NSHomeDirectory();
    NSString *filePath = [pListPath stringByAppendingPathComponent:tpkRound];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        
    }
    @try
    {
        //移除baselayer

        delegate.currentMapName=calltext;
        
        AGSLayer *baseLayer=[self.mapView baseLayer];
        [self.mapView removeMapLayer:baseLayer];
        AGSLocalTiledLayer* layer = [AGSLocalTiledLayer localTiledLayerWithPath:filePath];

        [self.mapView insertMapLayer:layer withName:@"世界地图集" atIndex:0];
        AGSEnvelope *ae=layer.fullEnvelope;
        //self.mapView.spatialReference=layer.spatialReference;
        [self.mapView zoomToEnvelope:ae animated:true];
        
        AGSEnvelope *mapenv=[[AGSEnvelope alloc] initWithXmin:9793569.1332 ymin:4067831.5632 xmax:14996346.2055 ymax:7564571.89 spatialReference:self.mapView.spatialReference];
        [self.mapView zoomToEnvelope:layer.fullEnvelope animated:true];
        [self.mapView zoomToEnvelope:mapenv animated:true];
        
        [self.mapView setMinScale:20000000];
        [self.mapView setMaxScale:2641654.627735];
        
        [self showDrawInfo];
    }
    @catch (NSException *exception)
    {
        
    }
    
   
}

//获取XML国家对应的地图集TPK包
- (NSString *)NetGISerstateName:(NSString *)stateName
{
    NSString *xmlData=self.widgetConfig;
    [TBXML alloc];
    TBXML *tbxml=[TBXML tbxmlWithXMLString:xmlData];
    TBXMLElement *rootXMLElement = tbxml.rootXMLElement;
    TBXMLElement *statesElement = [TBXML childElementNamed:@"states" parentElement:rootXMLElement];
    NSString *tpkFilePath;

    TBXMLElement *state=[TBXML childElementNamed:@"state" parentElement:statesElement];
    while (state)
    {
        NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:state];
        tpkFilePath=[TBXML textForElement:state];
        if([[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString: stateName] == YES)
        {
            break;
        }
        state = [TBXML nextSiblingNamed:@"state" searchFromElement:state];
    }
    return tpkFilePath;
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
    [self.mapView addMapLayer:graphicLayer withName:kLAYERNAME_DRAWGRAPHIC];
    }
}

//数据库路径
- (NSString *)DBfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"NMAtlas.sqlite"];
}
@end
