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

#import "WidgetsManager.h"

#import "ThumbImageView.h"
#import "UIView+ModalAnimationHelper.h"
#import "QuadCurveMenu.h"
#import "BaseWidget.h"
#import "ConfigWidgetEntity.h"
#import "AppEventNames.h"
#import "AppEvent.h"
#import "SNPopupView.h"
#import "MenuRootViewController.h"
#import "PSStackedViewController.h"
#import "MenuData.h"


#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

#define THUMB_HEIGHT 150
#define THUMB_V_PADDING 2
#define THUMB_H_PADDING 15
#define CREDIT_LABEL_HEIGHT 20

#define AUTOSCROLL_THRESHOLD 30

@interface WidgetsManager()
- (void) animateToolbarUp: (BOOL) up;
- (void) animateViewUp: (BOOL) up;
- (void) showMessageBox:(NSString*)message;
- (void) hideMessageBox;
- (void) addWidgetToolbarView;
- (BOOL) isWidgetToolbarShow;
- (BOOL) isWidgetMessageBoxShow;
- (void) addThumbScrollView;
- (void) addQuadCurveMenu;
- (void) addWidgetMessageBox;
@end
@implementation WidgetsManager
@synthesize selectedWidgetIndex = _selectedWidgetIndex;
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
   
    for (int i=0; i < [[_stackController viewControllers] count]; i++) {
        UIViewController * vc = [[_stackController viewControllers] objectAtIndex:i];
        CGRect frame = [vc.view convertRect:vc.view.frame toView:self];
        
        if (CGRectContainsPoint(frame, point)) {
        //    NSLog(@"vc.view---%@",NSStringFromCGRect(frame));
            CGPoint nP = [self convertPoint:point toView:vc.view];
        //     NSLog(@"nP--%@",NSStringFromCGPoint(nP));
            return [vc.view hitTest:nP withEvent:(UIEvent *)event];
        }
    }
    CGPoint cP = [self convertPoint:point toView:_mapView];
    //widget view
    if (CGRectContainsPoint(self.frame, cP)) {
        return [super hitTest:point withEvent:(UIEvent *)event];
    }
    //toolbar on mapView
    for (UIView *view in _mapView.subviews) {
        //first view is the active button
        CGPoint nP = [self convertPoint:point toView:view];
        return [view hitTest:nP withEvent:(UIEvent *)event];
    }
   return  _mapView ;
}
 
-(id)initWithConfig:(ConfigEntity *)config andMapView:(AGSMapView*) mapView
{
	self = [super init];
	if (self) {
		_isUp = YES;
		_mapView = mapView;
		_selectedWidgetIndex = -1;
		
		[self setBackgroundColor:[UIColor clearColor]];
		NSArray *widgetConfigs=config.widgetContainer;
		int count = [widgetConfigs count];
		_widgets = [[NSMutableArray alloc] initWithCapacity:count];
		for (int i=0; i<count; i++) {
			ConfigWidgetEntity * configWidgetEntity = [widgetConfigs objectAtIndex:i];
			BaseWidget * widget = [[NSClassFromString(configWidgetEntity.className) alloc] init];
			if (widget != nil) {
				[widget setWidgetId:i];
				[widget setBundleName:configWidgetEntity.bundleName];
                [widget setWidgetLabel:configWidgetEntity.label];
				[widget setWidgetTitle:configWidgetEntity.title];
				[widget setWidgetIcon:configWidgetEntity.icon];
				[widget setConfigUrl:configWidgetEntity.config];
				[widget setMapView:_mapView];
				[widget setViewerConfig:config];

                [widget create];
				[_widgets addObject:widget];
			}			
								   
		}	
		

		[AppEvent addListener:self selector:@selector(toolbarActiveHandle:) name:TOOLBAR_ACTIVE object:nil];
		[AppEvent addListener:self selector:@selector(toolbarUnActiveHandle:) name:TOOLBAR_INACTIVE object:nil];
		[AppEvent addListener:self selector:@selector(appErrorHandle:) name:APP_ERROR object:nil];
		[AppEvent addListener:self selector:@selector(showMessageBoxHandle:) name:SHOW_MESSAGE_BOX object:nil];
		[AppEvent addListener:self selector:@selector(hideMessageBoxHandle:) name:HIDE_MESSAGE_BOX object:nil];
		[AppEvent addListener:self selector:@selector(showLoadingViewHandle:) name:SHOW_LOADING_VIEW object:nil];
		[AppEvent addListener:self selector:@selector(hideLoadingErrorHandle:) name:HIDE_LOADING_VIEW object:nil];
        [AppEvent addListener:self selector:@selector(showDetailsViewHandle:) name:SHOW_DETIALS_VIEW object:nil];
		[AppEvent addListener:self selector:@selector(hideDetailsViewHandle:) name:HIDE_DETIALS_VIEW object:nil];
        [self addPSStackView];
	}
	return self;
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    navigationController.contentSizeForViewInPopover = viewController.contentSizeForViewInPopover;
}
-(void) toolbarActiveHandle:(NSNotification *)notification
{
    NSDictionary * dict= [notification userInfo];
	NSNumber * widgetId = [dict objectForKey:@"widgetId"];
		
    BaseWidget * baseWidget = [_widgets objectAtIndex:[widgetId intValue]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:baseWidget];
    navController.view.width = WIDGET_LEFT_VIEW_WIDTH;
    navController.view.height = WIDGET_LEFT_VIEW_HEIGHT;
    navController.delegate = self;
    [_stackController pushViewController:navController fromViewController:nil animated:YES];

}
-(void) toolbarUnActiveHandle:(NSNotification *)notification
{
   // NSDictionary * dict= [notification userInfo];
	//NSNumber * widgetId = [dict objectForKey:@"widgetId"];
    
   // BaseWidget * baseWidget = [_widgets objectAtIndex:[widgetId intValue]];
    while ([_stackController.viewControllers count]) {
        [_stackController popViewControllerAnimated:YES];
    }

}
-(void) appErrorHandle:(NSNotification *)notification
{
	NSDictionary * dict= [notification userInfo];
	NSString * message = [dict objectForKey:@"message"];
	if (message == nil) {
		message = @"AppError";
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppError" 
													 message:message 
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

-(void) showMessageBoxHandle:(NSNotification *)notification
{
	NSDictionary * dict= [notification userInfo];
	NSString * message = [dict objectForKey:@"message"];
	[self showMessageBox:message];
}

-(void) hideMessageBoxHandle:(NSNotification *)notification
{
	[self hideMessageBox];
}
-(void)showDetailsViewHandle:(NSNotification *)notification
{
    NSDictionary * dict= [notification userInfo];
	NSNumber * widgetId = [dict objectForKey:@"widgetId"];
    
    BaseWidget * baseWidget = [_widgets objectAtIndex:[widgetId intValue]];
    if (baseWidget.detailsViewController != nil) {
        if ([_stackController.viewControllers count] == 2) {
            [_stackController popViewControllerAnimated:NO];
        }
        [_stackController pushViewController:baseWidget.detailsViewController fromViewController:nil animated:YES];
    }
}
-(void)hideDetailsViewHandle:(NSNotification *)notification
{
    /*
    NSDictionary * dict= [notification userInfo];
	NSNumber * widgetId = [dict objectForKey:@"widgetId"];
    
    BaseWidget * baseWidget = [_widgets objectAtIndex:[widgetId intValue]];
    if (baseWidget.detailsViewController != nil) {
        [_stackController popViewControllerAnimated:YES];
    }
     */
    [_stackController popViewControllerAnimated:YES];
}
-(void) showLoadingViewHandle:(NSNotification *)notification
{
	[self.superview addSubview:_widgetLoadingView];
	
	NSDictionary * dict= [notification userInfo];
	NSString * message = [dict objectForKey:@"message"];
	
	_widgetLoadingView.delegate = self;
    _widgetLoadingView.labelText = @"Loading";
    _widgetLoadingView.detailsLabelText = message;
	_widgetLoadingView.square = YES;
	[_widgetLoadingView show:YES];
}

-(void) hideLoadingErrorHandle:(NSNotification *)notification
{
	NSDictionary * dict= [notification userInfo];
	NSString * message = [dict objectForKey:@"message"];
	 _widgetLoadingView.labelText =message;
	[_widgetLoadingView hide:YES afterDelay:2.0];
}

-(void) showMessageBox:(NSString *) messges
{
	if ([self isWidgetToolbarShow]) {
		_widgetMessageBox.frame = CGRectMake(0, 44, 320, 24);
	}
	else
	{
		_widgetMessageBox.frame = CGRectMake(0, 0, 320, 24);
	}
	UILabel * label = (UILabel*)[_widgetMessageBox viewWithTag:12000];
	label.text = messges;
	_widgetMessageBox.alpha = 0.2;
	_widgetMessageBox.hidden = NO;
	[UIView animateWithDuration:1.0
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{_widgetMessageBox.alpha = 1.0;}
					 completion:^(BOOL finished){_widgetMessageBox.hidden =  NO;}
	 ];
	//_widgetMessageBox.hidden = NO;
}
-(void) hideMessageBox
{
	
	_widgetMessageBox.hidden = NO;
	_widgetMessageBox.alpha = 1.0;
	_widgetMessageBox.hidden = NO;
	[UIView animateWithDuration:1.0
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{_widgetMessageBox.alpha = 0.0;}
					 completion:^(BOOL finished){
						 _widgetMessageBox.frame = CGRectMake(0, -24, 320, 24);
						 _widgetMessageBox.hidden =  YES;
					 }
	 ];
}
-(void) makeMBHrogressView
{
	_widgetLoadingView = [[MBProgressHUD alloc] initWithView:self.superview];
}
- (void)drawRect:(CGRect)rect {
	//NSLog(@"draw rect");
//	[self addWidgetToolbarView];
//	[self addWidgetMessageBox];
//	[self addQuadCurveMenu];
//	[self addThumbScrollView];
 //   [self addPSStackView];
//	[self makeMBHrogressView];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   
    for (UIViewController * vc in _stackController.viewControllers) {
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight) {
            vc.view.height = WIDGET_LEFT_VIEW_HEIGHT;
        }
        else{
            vc.view.height = WIDGET_LEFT_VIEW_HEIGHT;
        }
        
        [vc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        
    }
    [_stackController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    for (UIViewController * vc in _stackController.viewControllers) {
         [vc didRotateFromInterfaceOrientation:fromInterfaceOrientation ];
    }
    [_stackController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (UIViewController * vc in _stackController.viewControllers) {
        [vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    [_stackController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
-(void) addWidgetMessageBox
{
	_widgetMessageBox = [[UIView alloc] initWithFrame:CGRectMake(0, -24, 320, 24)];
	_widgetMessageBox.backgroundColor = [UIColor grayColor];
	_widgetMessageBox.layer.masksToBounds = YES;
	_widgetMessageBox.tag=101;
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 24)];
	label.backgroundColor = [UIColor clearColor];
	label.tag = 12000;
	[_widgetMessageBox addSubview:label];
	[self.superview addSubview:_widgetMessageBox];
}
-(BOOL) isWidgetToolbarShow
{
	if (_widgetView.frame.origin.y >=0) {
		return YES;
	}
	return NO;
}
-(BOOL) isWidgetMessageBoxShow
{
	if (_widgetMessageBox.frame.origin.y >=0) {
		return YES;
	}
	return NO;
}
-(void) addPSStackView
{
    MenuRootViewController *menuController = [[MenuRootViewController alloc] init];

    _stackController = [[PSStackedViewController alloc] initWithRootViewController:menuController];
    _stackController.leftInset = MENU_WIDTH;
    _stackController.largeLeftInset = 10. + MENU_WIDTH;
    _stackController.cornerRadius = 5.0;
    _stackController.view.frame = CGRectMake(0, 0, MENU_WIDTH, WIDGET_LEFT_VIEW_HEIGHT);
    
    menuController.delegate = self;
    
    
    // test to disable large inset
    //self.stackController.largeLeftInset = self.stackController.leftInset;
    
	for (BaseWidget *widget in _widgets)
	{
        NSString *name = widget.widgetIcon;
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:widget.bundleName ofType:@"bundle"]];
		NSString * strPath = [bundle pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
		MenuData * memuData = [[MenuData alloc] initWithIconName:strPath details:widget.widgetTitle];
        [menuController addMenuData:memuData];
		
    }
    [self addSubview:_stackController.view];
}
-(void) menuSelectedChanged:(MenuRootViewController*)menuRootVC selectedIndex:(int)selectedIndex
{

    if (_selectedWidgetIndex != selectedIndex) {
        if (_selectedWidgetIndex >=0) {
            BaseWidget * otherWidget = [_widgets objectAtIndex:_selectedWidgetIndex];
            [otherWidget inactive];
        }
        BaseWidget * widget = [_widgets objectAtIndex:selectedIndex];
        
        [widget active];
    }
    else
    {
        BaseWidget * widget = [_widgets objectAtIndex:selectedIndex];
        if ([widget isActived]) {
            [widget inactive];
        }
        else
        {
            [widget active];
        }
    }
    
    _selectedWidgetIndex = selectedIndex;
}

- (void) animateViewUp: (BOOL) up
{
	const int movementDistance = 60; // tweak as needed
	const float movementDuration = 0.3f; // tweak as needed
	
	int movement = (up ? -movementDistance : movementDistance);
	
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	self.frame = CGRectOffset(self.frame, 0, movement);
	//[UIView commitModalAnimations];
}
	 
- (void) animateToolbarUp: (BOOL) up
{
    const int movementDistance = 44; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    _widgetView.frame = CGRectOffset(_widgetView.frame, 0, movement);
    //[UIView commitModalAnimations];

}

@end
