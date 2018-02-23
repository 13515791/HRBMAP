//
//  MaLocationDisplayDataSource.m
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-27.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "MaLocationDisplayDataSource.h"
#import <ArcGIS/ArcGIS.h>

@implementation MaLocationDisplayDataSource
@synthesize locationManager = _locationManager;
@synthesize delegate = _delegate;
-(id)init{
    self = [super init];
    self.locationManager.delegate = self;
    return self;
}

//定位时候调用
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    AGSLocation *loc = [AGSLocation locationWithCLLocation:newLocation];
    AGSPoint *pnt = loc.point;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = pnt.y;
    coordinate.longitude = pnt.x;
    CLLocationCoordinate2D d = [CorrdTransform GPSLocToGoogleLoc:coordinate];
    AGSPoint *pntNew = [AGSPoint pointWithX:d.longitude y:d.latitude spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    loc.point = pntNew;
    if ([self.delegate respondsToSelector:@selector(locationDisplayDataSource:didUpdateWithLocation:)]) {
        [self.delegate locationDisplayDataSource:self didUpdateWithLocation:loc];
    }
}

//定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    locationError = error;
    if ([self.delegate respondsToSelector:@selector(locationDisplayDataSource:didFailWithError:)]) {
        [self.delegate locationDisplayDataSource:self didFailWithError:locationError];
    }
}

-(BOOL)isStarted{
    if (!_locationManager) {
        return NO;
    }
    return YES;
}

-(NSError *)error{
    return locationError;
}
-(void)start{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];//初始化定位器
        [_locationManager setDelegate: self];//设置代理
        [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];//设置精确度
    }
    [_locationManager startUpdatingLocation];//开启位置更新
}

/**
 Stops the datasource. The framework will call this when @c AGSLocationDisplay::stopDataSource is invoked. You should not call this directly.
 @agssince{10.1.1, 10.2}
 */
-(void)stop{
    [_locationManager stopUpdatingLocation];//开启位置更新
    
    _locationManager = nil;
}


@end
