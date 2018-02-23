//
//  BaseDetailsViewController.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "BaseDetailsViewController.h"
#import "UIView+PSSizes.h"
#import "AppEvent.h"
#import "AppEventNames.h"
@interface BaseDetailsViewController ()

@end

@implementation BaseDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    self.view.width = 644;
    self.view.userInteractionEnabled = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIImageView * rightImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, self.view.height)];
    rightImageView.image= [UIImage imageNamed:@"right_show.png"];
    [self.view addSubview:rightImageView];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.frame =CGRectMake(self.view.width-100, 5, 80, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"button_green.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.width, 2)];
    topLine.backgroundColor = [UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0];
    [self.view addSubview:topLine];

}
-(void)btnTouched:(id)sender
{
    [AppEvent dispatchEventWithName:HIDE_DETIALS_VIEW object:self userInfo:
    [NSDictionary dictionaryWithObjects:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:0],nil]
                                forKeys:[NSArray arrayWithObjects:@"widgetId",nil]
     ]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
