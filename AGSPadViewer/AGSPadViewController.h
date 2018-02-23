//
//  EsriPadViewController.h
//  AGSPadViewer
//
//  Created by zhang baocai on 13-4-15.
//  Copyright (c) 2013年 Esri. All rights reserved.
//
//  Edited by MaY on 14-4-5.
//  Copyright (c) 2014年 esriChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "BaseMapSelectViewController.h"
#import "AppDelegate.h"
#import "sqlite3.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"
#import "EditorViewController.h"
#import "EditController.h"
#import "SelectAttachment.h"
#import "SearchResultViewController.h"
#import "ShowMessageViewController.h"
#import "WorldAtlasWidget.h"
#import "ShowHelpVC.h"

@class ConfigManager;
@class WidgetsManager;


@interface AGSPadViewController : UIViewController<UISearchBarDelegate,AGSMapViewLayerDelegate,UIAlertViewDelegate,EditorViewControllerDelegate,AGSMapViewTouchDelegate,AGSCalloutDelegate,AGSPopupsContainerDelegate,EditControllerDelegate,SearchResultPickerDelegate,ShowMessageViewControllerDelegate,WorldAtlasWidgetDelegate,ShowHelpVCDelegate>
{
    AGSMapView *_mapView;
    ConfigManager * _configManager;
	WidgetsManager *_widgetsManager;
    BaseMapSelectViewController *_sg;
    UIImageView *_northArrow;
    sqlite3 *MyDatabase;
    BOOL isDistanceClick;
    BOOL isEditBtnClick;
    BOOL isImage;
    NSMutableArray *_layerNames;
    AGSGraphic* _newFeature;
    AGSPopupsContainerViewController *_popupsVC;
    AGSSketchGraphicsLayer *_sgl;
    UISearchBar *_searchBar;
    UIButton *_helpBtn;
    UIButton *_collectDataBtn;
}
-(void)showDrawInfo;
- (UIImage *)createImageWithColor: (UIColor *) color;
- (NSString *)MapfilePath;
- (NSString *)DBfilePath;
-(void)ShowMessageViewControllerWasDismissed: (ShowMessageViewController *)showMessageViewController;
-(void)DistanceUnitMap:(id)sender;
-(BOOL)prefersStatusBarHidden;
@property (nonatomic, strong) AGSMapView *mapView;
@property (nonatomic, strong) UIButton *basemapBtn;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic) UIImageView *northArrow;
@property (nonatomic, strong) CLLocationManager *locManager;
//添加搜索框
@property (nonatomic, strong) UISearchBar *searchBar;
//显示详细信息
@property (nonatomic,strong) UIButton *showMessage;
@property (nonatomic,strong) UIImageView *rightLogo;
@property (nonatomic,strong) UIImageView *leftLogo;

//测距功能
@property (nonatomic, strong) UIButton *distanceUnitBtn;
@property (nonatomic, strong) AGSSketchGraphicsLayer *UnitsketchLayer;
//测量面积按钮
@property (nonatomic,strong) UIButton *areaUnitBtn;
//编辑按钮
@property(nonatomic,strong) UIButton *editorBtn;
@property(nonatomic,strong) UIButton *cleanBtn;
@property (nonatomic, strong) EditorViewController* editViewController;
@property (nonatomic,strong) EditController *editVC;
@property (nonatomic,strong) SelectAttachment *selectVC;
@property (nonatomic, strong) AGSSketchGraphicsLayer *editketchLayer;
@property (nonatomic,strong) AGSGraphicsLayer *editGraphicLayer;
//@property (nonatomic, strong) NSMutableArray* infos;
@property (nonatomic, strong) AGSFeatureLayer *activeFeatureLayer;
@property (nonatomic, strong) AGSPopupsContainerViewController *popupsVC;
@property (nonatomic,strong) NSString *graphicID;
@property (nonatomic,strong) NSString *graphicAttachments;
@property (nonatomic,strong) ShowMessageViewController *showVC;
@property(nonatomic,strong) WorldAtlasWidget *worldWidget;
@property(nonatomic,strong) ShowHelpVC *showHelpViewController;
@end
