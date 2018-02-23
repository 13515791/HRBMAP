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
#import "BaseWidget.h"
#import "AppEvent.h"
#import "AppEventNames.h"
#import "UIView+PSSizes.h"
#import "BaseDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BaseWidget
@synthesize  widgetId		= _widgetId;
@synthesize  widgetLabel	= _widgetLabel;
@synthesize  widgetTitle	= _widgetTitle;
@synthesize  widgetIcon		= _widgetIcon;
@synthesize  bundleName     = _bundleName;
@synthesize  mapView		= _mapView;
@synthesize  viewerConfig	= _viewerConfig;
@synthesize  widgetConfig	= _widgetConfig;
@synthesize  configUrl      = _configUrl;
@synthesize  detailsViewController = _detailsViewController;
@synthesize  isAutoInactive = _isAutoInactive;
@synthesize  headerView = _headerView;
@synthesize  contentView = _contentView;
@synthesize  bottomToolBar  = _bottomToolBar;

-(void)dealloc
{
	self.configUrl = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if( orientation == UIInterfaceOrientationPortrait||orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.view.frame = CGRectMake(0,0,748,1024);
    }
    else{
        self.view.frame = CGRectMake(0,0,1004,768);
    }
      */
    if (iOSVersion >=7.0) {
        self.view.frame = CGRectMake(0,5,WIDGET_LEFT_VIEW_WIDTH,WIDGET_LEFT_VIEW_HEIGHT);
        self.navigationController.view.height = WIDGET_LEFT_VIEW_HEIGHT-5;
    }else{
        self.view.frame = CGRectMake(0,5,WIDGET_LEFT_VIEW_WIDTH,WIDGET_LEFT_VIEW_HEIGHT);
        self.navigationController.view.height = WIDGET_LEFT_VIEW_HEIGHT-5;
    }
    self.navigationController.view.width = WIDGET_LEFT_VIEW_WIDTH;
    self.navigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = WIDGET_BACKGROUNDCOLOR;
    self.view.userInteractionEnabled = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,45)];
    //HeaderView:Title Label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.width-10, 35)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.widgetTitle;
    label.font = WIDGET_TITLEFONT;
    label.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:label];
    //HeaderView:Dividing line
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.width, 1.5)];
    topLine.backgroundColor = [UIColor greenColor];
    topLine.alpha = 0.5;
    [_headerView addSubview:topLine];
    [self.view addSubview:_headerView];
    //ContentView:
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(1.5, 47,self.view.width-3.0,WIDGET_LEFT_VIEW_HEIGHT -50)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentView];
    self.view.layer.cornerRadius = 8;
}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.view.width = WIDGET_LEFT_VIEW_WIDTH;
    NSLog(@"width=%f,height=%f",self.view.width,self.view.height);
    [super viewWillAppear:animated];
}

-(BOOL) isActived
{
	return _isActived;
}
-(void)active
{
	_isActived = YES;
    [AppEvent dispatchEventWithName:TOOLBAR_ACTIVE object:self userInfo:
		 [NSDictionary dictionaryWithObjects:
		  [NSArray arrayWithObjects:[NSNumber numberWithInt:self.widgetId],nil]
									 forKeys:[NSArray arrayWithObjects:@"widgetId",nil]
		  ]]; 
	//[self resizeUI];
}

- (void)resizeUI{
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if( orientation == UIInterfaceOrientationPortrait||orientation == UIInterfaceOrientationPortraitUpsideDown){
        double height = 1004.0;
        if (iOSVersion >=7.0) {
            height = 1024.0;
        }
        self.view.frame = CGRectMake(0, 0, self.view.width, height);
        _contentView.frame = CGRectMake(0, 46,self.view.width,height - 90);
        _bottomToolBar.frame = CGRectMake(0, height -45, self.view.frame.size.width, 45);
    }
    else{
        double height = 748.0;
        if (iOSVersion >=7.0) {
            height = 768.0;
        }
        self.view.frame = CGRectMake(0, 0, self.view.width, height);
        _contentView.frame = CGRectMake(0, 46,self.view.width,height - 90);
        _bottomToolBar.frame = CGRectMake(0, height -45, self.view.frame.size.width, 45);
    }
}
-(void)inactive
{
	_isActived = NO;
    [AppEvent dispatchEventWithName:TOOLBAR_INACTIVE object:self userInfo:
     [NSDictionary dictionaryWithObjects:
      [NSArray arrayWithObjects:[NSNumber numberWithInt:self.widgetId],nil]
                                 forKeys:[NSArray arrayWithObjects:@"widgetId",nil]
      ]];
}

-(void) create
{
   // self.detailsViewController = [[[BaseDetailsViewController alloc] init] autorelease];
}
-(void) setConfigUrl:(NSString *)configUrl
{
	if (_configUrl !=configUrl) {
		_configUrl = nil;
		_configUrl = configUrl;
		NSString * strXML = nil;
		NSError *error = nil;
		if (_configUrl) {
			NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:self.bundleName ofType:@"bundle"]];
			NSString * strPath = [bundle pathForResource:[self.configUrl stringByDeletingPathExtension] ofType:[self.configUrl pathExtension]];
			NSStringEncoding encoding;
			strXML = [NSString stringWithContentsOfFile:strPath usedEncoding:&encoding error:&error];
		}
		self.widgetConfig = strXML;
	}
}
/*
-(NSString *) readConfigXML
{
	NSString * strXML = nil;
	NSError *error = nil;
	if (self.widgetConfigUrl) {
		NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:self.widgetBundleName ofType:@"bundle"]];
		NSString * strPath = [bundle pathForResource:[self.widgetConfigUrl stringByDeletingPathExtension] ofType:[self.widgetConfigUrl pathExtension]];
		NSStringEncoding encoding;
		strXML = [NSString stringWithContentsOfFile:strPath usedEncoding:&encoding error:&error];
	}
	return strXML;
}
 */
-(void) showDetails
{
    [AppEvent dispatchEventWithName:SHOW_DETIALS_VIEW object:self userInfo:
     [NSDictionary dictionaryWithObjects:
      [NSArray arrayWithObjects:[NSNumber numberWithInt:self.widgetId],nil]
                                 forKeys:[NSArray arrayWithObjects:@"widgetID",nil]
      ]];
}
-(void) hideDetails
{
    [AppEvent dispatchEventWithName:HIDE_DETIALS_VIEW object:self userInfo:
     [NSDictionary dictionaryWithObjects:
      [NSArray arrayWithObjects:[NSNumber numberWithInt:self.widgetId],nil]
                                 forKeys:[NSArray arrayWithObjects:@"widgetID",nil]
      ]];
}
-(void) showMessageBox:(NSString *)message
{
	if (message == nil ) {
		[AppEvent dispatchEventWithName:HIDE_MESSAGE_BOX object:self userInfo:nil];
		
	}
	else {
		[AppEvent dispatchEventWithName:SHOW_MESSAGE_BOX object:self userInfo:
		 [NSDictionary dictionaryWithObjects:
		  [NSArray arrayWithObjects:message,[NSNumber numberWithInt:self.widgetId],nil]
									 forKeys:[NSArray arrayWithObjects:@"message",@"widgetID",nil]
		  ]]; 
	}
}
-(void) showLoadingView:(BOOL) isShow withMessage:(NSString *) message
{
	if (isShow) {
		[AppEvent dispatchEventWithName:SHOW_LOADING_VIEW object:self userInfo:
		 [NSDictionary dictionaryWithObjects:
		  [NSArray arrayWithObjects:message,[NSNumber numberWithInt:self.widgetId],nil]
									 forKeys:[NSArray arrayWithObjects:@"message",@"widgetID",nil]
		  ]]; 
	}
	else {
		[AppEvent dispatchEventWithName:HIDE_LOADING_VIEW object:self userInfo:
		 [NSDictionary dictionaryWithObjects:
		  [NSArray arrayWithObjects:message,[NSNumber numberWithInt:self.widgetId],nil]
									 forKeys:[NSArray arrayWithObjects:@"message",@"widgetID",nil]
		  ]];
	}
}
-(void) showAppError:(NSString *) error
{
	[AppEvent dispatchEventWithName:APP_ERROR object:self userInfo:nil]; 
}
// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation ==  UIInterfaceOrientationPortrait ||toInterfaceOrientation ==  UIInterfaceOrientationPortraitUpsideDown ) {
        double height = 1004.0;
        if (iOSVersion >=7.0) {
            height = 1024.0;
        }
        _contentView.frame = CGRectMake(0, 46,self.view.width,height - 90);
        _bottomToolBar.frame = CGRectMake(0, height -45, self.view.frame.size.width, 45);
    }
    else{
        double height = 748.0;
        if (iOSVersion >=7.0) {
            height = 768.0;
        }
        _contentView.frame = CGRectMake(0, 46,self.view.width,WIDGET_LEFT_VIEW_HEIGHT);
        _bottomToolBar.frame = CGRectMake(0, height -45, self.view.frame.size.width, 45);
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

@end
