//
//  ChinaAtlasWidget.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-8-26.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWidget.h"
#import "sqlite3.h"
#import "AppDelegate.h"
#import "AGSPadViewController.h"

@interface ChinaAtlasWidget : BaseWidget<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *MyDatabase;
    UITableView *CityTableView;
    //BOOL *isView;
    NSString *isView;
    AGSMapView *mapv;
    /*
    UIPickerView *Province;
    UITableView *City;
    NSArray *cArrayLiao;
     */
}
@property(nonatomic,retain)NSArray *CityList;
//@property(nonatomic,retain)NSArray *PArrayList;
@property(nonatomic,retain)NSMutableArray *PArrayList;
//@property(nonatomic,retain)NSArray *CArrayList;
@property(nonatomic,retain)NSMutableArray *CArrayList;

@property(nonatomic,strong) NSArray *datasetPoint;
@property(nonatomic,strong) NSArray *datasetLine;
@property(nonatomic,strong) NSArray *datasetPolygon;
@property (nonatomic,strong) AGSPadViewController *agspadview;
@end
