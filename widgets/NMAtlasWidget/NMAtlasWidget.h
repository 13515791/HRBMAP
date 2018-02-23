//
//  NMAtlasWidget.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-9.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWidget.h"
#import "sqlite3.h"
#import "AppDelegate.h"

@interface NMAtlasWidget : BaseWidget<UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *MyDatabase;
    UITableView *NMtableView;
    NSString *isView;
    AGSMapView *mapv;
}
@property(nonatomic,retain)NSMutableArray *CityList;
@property(nonatomic,retain)NSMutableArray *CountyList;
@end
