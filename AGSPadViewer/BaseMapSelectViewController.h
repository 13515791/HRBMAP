//
//  BaseMapSelectViewController.h
//  AGSPadViewer
//
//  Created by EsriChina_Mobile on 13-7-23.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <ArcGIS/ArcGIS.h>

@interface BaseMapSelectViewController : UIViewController<AGSMapViewTouchDelegate>
@property(nonatomic , weak)UIButton *selectBtn;
@property(nonatomic , weak)AGSMapView *mapView;
- (void)sgViewAppear;
- (void)sgViewDissAppear;
- (id)initWithBasemaps:(NSArray *)basemaps;
@end
