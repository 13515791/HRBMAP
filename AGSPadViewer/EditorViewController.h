//
//  EditorViewController.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-10.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "LoadingView.h"

@class EditorViewController;
@protocol EditorViewControllerDelegate <NSObject>

@optional

-(void)editorViewControllerWasDismissed: (EditorViewController *) editorViewController;

-(void)editorViewController:(EditorViewController*) editorViewController didSelectFeatureTemplate:(AGSFeatureTemplate*)template forLayer:(id<AGSGDBFeatureSourceInfo>)layer;

@end

@interface EditorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    id<EditorViewControllerDelegate> __weak _delegate;
    LoadingView* _loadingView;
    EditorViewController* _editorViewController;
    NSMutableArray* _infos;
}
- (void) addTemplatesForLayersInMap:(AGSMapView*)mapView;

@property (nonatomic, strong) EditorViewController* editorViewController;
@property (nonatomic, weak) id<EditorViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* infos;
@property (nonatomic, strong) id<AGSGDBFeatureSourceInfo> source;
@property (nonatomic, strong) AGSRenderer* renderer;
@property (nonatomic, strong) AGSFeatureTemplate* featureTemplate;
@property (nonatomic, strong) AGSFeatureType* featureType;
@property (nonatomic, weak) AGSFeatureLayer* featureLayer;
@property (strong, nonatomic) IBOutlet UITableView *featureTemplatesTableView;
- (IBAction)dismiss:(id)sender;


@end

/** A value object to hold information about the feature type, template and layer */
@interface FeatureTemplatePickerInfo : NSObject
{
    
}

@property (nonatomic, strong) AGSFeatureType* featureType;
@property (nonatomic, strong) AGSFeatureTemplate* featureTemplate;
@property (nonatomic, strong) id<AGSGDBFeatureSourceInfo> source;
@property (nonatomic, strong) AGSRenderer* renderer;

@end
