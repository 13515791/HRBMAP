//
//  WAWModalViewController.m
//  NMATLAS
//
//  Created by LiangChao on 14-8-28.
//  Copyright (c) 2014年 esri. All rights reserved.
//
#import "WAWModalViewController.h"
#import "AppEvent.h"
#import "AppEventNames.h"
#import <UIKit/UIKit.h>

@interface WAWModalViewController ()

@end

@implementation WAWModalViewController
@synthesize atlasPath=_atlasPath;
//@synthesize passDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImage *img=[[UIImage alloc] initWithContentsOfFile:delegate.currentAtlasPath];
    self.mapIMG.image=img;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
