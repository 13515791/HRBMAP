//
//  WorldAtlasWidget.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-8-18.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWidget.h"
#import "AppDelegate.h"
#import "sqlite3.h"

@class WorldAtlasWidget;
@protocol WorldAtlasWidgetDelegate <NSObject>
@optional
-(void)WorldShowDrawInfo;
@end

@interface WorldAtlasWidget : BaseWidget<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *worldTableView;
    UITableView *stateTableView;
    sqlite3 *MyDatabase;
}

- (NSString *) NetGISerstateName:(NSString *) stateName;
//设置索引标题
@property(nonatomic,retain)NSMutableArray *indexArray;
@property(nonatomic,weak)id<WorldAtlasWidgetDelegate> delegate;
//设置每个section下的cell内容
@property(nonatomic,retain)NSArray *dataArrayWorld;
@property(nonatomic,retain)NSArray *dataArrayA;
@property(nonatomic,retain)NSArray *dataArrayB;
@property(nonatomic,retain)NSArray *dataArrayC;
@property(nonatomic,retain)NSArray *dataArrayD;
@property(nonatomic,retain)NSArray *dataArrayE;
@property(nonatomic,retain)NSArray *dataArrayF;
@property(nonatomic,retain)NSArray *dataArrayG;
@property(nonatomic,retain)NSArray *dataArrayH;
@property(nonatomic,retain)NSArray *dataArrayJ;
@property(nonatomic,retain)NSArray *dataArrayK;
@property(nonatomic,retain)NSArray *dataArrayL;
@property(nonatomic,retain)NSArray *dataArrayM;
@property(nonatomic,retain)NSArray *dataArrayN;
@property(nonatomic,retain)NSArray *dataArrayP;
@property(nonatomic,retain)NSArray *dataArrayR;
@property(nonatomic,retain)NSArray *dataArrayS;
@property(nonatomic,retain)NSArray *dataArrayT;
@property(nonatomic,retain)NSArray *dataArrayW;
@property(nonatomic,retain)NSArray *dataArrayX;
@property(nonatomic,retain)NSArray *dataArrayY;
@property(nonatomic,retain)NSArray *dataArrayZ;
@property (nonatomic,strong) NSArray *wordDataList;

@end
