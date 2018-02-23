////////////////////////////////////////////////////////////////////////////////
//
//Copyright (c) 2011-2012 Esri
//
//All rights reserved under the copyright laws of the United States.
//You may freely redistribute and use this software, with or
//without modification, provided you include the original copyright
//and use restrictions.  See use restrictions in the file:
//<install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "ConfigEntity.h"
#import "MBProgressHUD.h"
#import "ThumbImageView.h"
#import "QuadCurveMenu.h"

@class PSStackedViewController;
@interface WidgetsManager : UIView<ThumbImageViewDelegate,QuadCurveMenuDelegate,MBProgressHUDDelegate> {
	BOOL			_isUp;
	NSMutableArray* _widgets;
	AGSMapView    * _mapView;
	int             _selectedWidgetIndex;
	UIView        * _widgetView;
	UIView        * _widgetMessageBox;
	MBProgressHUD * _widgetLoadingView;
    PSStackedViewController *_stackController;
	
}
@property (nonatomic) int selectedWidgetIndex;
- (id)initWithConfig:(ConfigEntity *)config andMapView:(AGSMapView*) mapView;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration ;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation ;
@end
