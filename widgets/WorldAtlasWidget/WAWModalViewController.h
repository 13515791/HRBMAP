//
//  WAWModalViewController.h
//  NMATLAS
//
//  Created by LiangChao on 14-8-28.
//  Copyright (c) 2014年 esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "MZFormSheetController.h"
#import "AppDelegate.h"
//#import "BaseWidget.h"
//#import "MapViewController.h"


@interface WAWModalViewController : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *mapIMG;
@property (nonatomic,strong) NSString *atlasPath;
@property (strong, nonatomic) UIImageView *mapImg1;
@end
