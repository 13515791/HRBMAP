//
//  ImageViewController.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-27.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageVC;
-(void)imageSource :(UIImage *)image;
@end
