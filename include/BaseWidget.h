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
#import "IBaseWidget.h"
#import "ConfigEntity.h"

@interface BaseWidget : UIViewController <IBaseWidget>{
	long          _widgetId;
    NSString	* _widgetLabel;
	NSString	* _widgetTitle;
	NSString	* _widgetIcon;
	NSString    * _configUrl;
	NSString    * _bundleName;
	AGSMapView	* _mapView;
	ConfigEntity* _viewerConfig;
	BOOL          _isActived;
	NSString    * _widgetConfig;
    BOOL          _isAutoInactive;
    UIViewController * _detailsViewController;
    UIView      *_headerView;
    UIView      *_contentView;
	UIToolbar   * _bottomToolBar;
}
-(BOOL) isActived;
-(void) showMessageBox:(NSString *)message;
-(void) showLoadingView:(BOOL) isShow withMessage:(NSString *) message;
-(void) showAppError:(NSString *) error;
-(void) showDetails;
-(void) hideDetails;
@property (nonatomic, assign) long			  widgetId;
@property (nonatomic, strong) NSString		* widgetLabel;
@property (nonatomic, strong) NSString		* widgetTitle;
@property (nonatomic, strong) NSString		* widgetIcon;
@property (nonatomic, strong) NSString      * configUrl;
@property (nonatomic, strong) NSString      * bundleName;
@property (nonatomic, strong) NSString      * widgetConfig;
@property (nonatomic, strong) AGSMapView	* mapView;
@property (nonatomic, strong) ConfigEntity  * viewerConfig;
@property (nonatomic, assign) BOOL          isAutoInactive;
@property (nonatomic, strong) UIViewController * detailsViewController;
@property (nonatomic, strong) UIView        *headerView;
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIToolbar     *bottomToolBar;
@end
