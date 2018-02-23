//
//  UIImageView+AGSNorthArrow.m
//  AGSCommonPatternsSample
//
//  Created by Nicholas Furness on 2/14/14.
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "UIImageView+AGSNorthArrow.h"
#import <objc/runtime.h>

#define kMapViewKey @"trackingMapView"
#define kAngleKey @"rotationAngle"
#define kTimerKey @"timer"
#define kAnimatingKey @"animating"

@interface UIImageView (AGSNorthArrowInternal)
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation UIImageView (AGSNorthArrow)
#pragma mark - Property setters/getters
-(void)setMapViewForNorthArrow:(AGSMapView *)mapView
{
    AGSMapView *oldMapView = self.mapViewForNorthArrow;
    if (oldMapView) {
        [oldMapView removeObserver:self forKeyPath:kAngleKey];
        [oldMapView removeObserver:self forKeyPath:kAnimatingKey];
    }

    // Ensure we are configured properly
    self.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeScaleAspectFit;

    // Keep a weak reference to our AGSMapView
    objc_setAssociatedObject(self, kMapViewKey, mapView, OBJC_ASSOCIATION_ASSIGN);
    
    if (mapView) {
        // Show North
        [self setNorthArrowAngle:mapView.rotationAngle];

        // Track rotation, either through interaction or animating with AGSMapView::setRotationAngle
        [mapView addObserver:self forKeyPath:kAngleKey options:NSKeyValueObservingOptionNew context:nil];
        [mapView addObserver:self forKeyPath:kAnimatingKey options:NSKeyValueObservingOptionNew context:nil];
    } else {
        [self setNorthArrowAngle:0];
    }
}

-(AGSMapView *)mapViewForNorthArrow
{
    return objc_getAssociatedObject(self, kMapViewKey);
}

-(void)setTimer:(NSTimer *)timer
{
    if (timer) {
        // Strong reference
        objc_setAssociatedObject(self, kTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        // Weak reference to nil
        objc_setAssociatedObject(self, kTimerKey, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

-(NSTimer *)timer
{
    return objc_getAssociatedObject(self, kTimerKey);
}

#pragma mark - KVO Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kAngleKey]) {
        [self setNorthArrowAngle:(double)[object rotationAngle]];
    } else if ([keyPath isEqualToString:kAnimatingKey]) {
        if (self.mapViewForNorthArrow.animating) {
            // If we're animating, let's update the north arrow as we animate
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0
                                                          target:self
                                                        selector:@selector(checkRotation:)
                                                        userInfo:nil repeats:YES];
        } else if (self.timer) {
            // Finished animating. Stop updating on a timer.
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

#pragma mark - Update North Arrow
-(void)checkRotation:(NSTimer*)timer
{
    [self setNorthArrowAngle:self.mapViewForNorthArrow.rotationAngle];
}

-(void)setNorthArrowAngle:(double)mapAngle
{
    self.transform = CGAffineTransformMakeRotation(-M_PI * mapAngle / 180);
}
@end
