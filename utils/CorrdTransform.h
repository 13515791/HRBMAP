//
//  CorrdTransform.h
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-24.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef struct {
	double latitude;
	double longitude;
} LocationCoordinate;

@interface CorrdTransform : NSObject

// 百度坐标转谷歌坐标
+ (void)transformatBDLat:(CGFloat)fBDLat BDLng:(CGFloat)fBDLng toGoogleLat:(CGFloat *)pfGoogleLat googleLng:(CGFloat *)pfGoogleLng;
+ (CLLocationCoordinate2D)getGoogleLocFromBaiduLocLat:(CGFloat)fBaiduLat lng:(CGFloat)fBaiduLng;

//// 谷歌坐标转百度坐标
+ (CLLocationCoordinate2D)getBaiduLocFromGoogleLocLat:(CGFloat)fGoogleLat lng:(CGFloat)fGoogleLng;

// GPS坐标转谷歌坐标
+ (CLLocationCoordinate2D)GPSLocToGoogleLoc:(CLLocationCoordinate2D)objGPSLoc;

+ (double)GPSToNavMapLocX:(double) x ;
+ (double)GPSToNavMapLocY:(double) y;
@end