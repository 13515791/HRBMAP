//
//  NonRotatingUIImagePickerController.m
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-28.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "NonRotatingUIImagePickerController.h"

@interface NonRotatingUIImagePickerController ()

@end

@implementation NonRotatingUIImagePickerController

// Disable Landscape mode.
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
