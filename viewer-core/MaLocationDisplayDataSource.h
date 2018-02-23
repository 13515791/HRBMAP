//
//  MaLocationDisplayDataSource.h
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-27.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CorrdTransform.h"
@protocol AGSLocationDisplayDataSource;
@protocol AGSLocationDisplayDataSourceDelegate;
@class CLLocationManager;

@interface MaLocationDisplayDataSource : NSObject <AGSLocationDisplayDataSource,UIAccelerometerDelegate,CLLocationManagerDelegate>{
    NSError *locationError;
}

@property (nonatomic, weak) id<AGSLocationDisplayDataSourceDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
