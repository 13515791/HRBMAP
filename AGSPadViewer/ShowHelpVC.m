//
//  ShowHelpVC.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-10-18.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "ShowHelpVC.h"

@interface ShowHelpVC ()

@end

@implementation ShowHelpVC

@synthesize delegate=_delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 1024 , 724)];
    scrollerView.scrollEnabled = YES;
    //scrollerView.delegate = self;
    scrollerView.bounces = NO;
    scrollerView.alwaysBounceHorizontal = YES;
    
    UIImageView *imageView=[[UIImageView alloc] init];
    UIImage *helpImg=[UIImage imageNamed:@"HelpImg.png"];
    imageView.image=helpImg;
    [imageView setFrame:CGRectMake(0, 0, 1024, 8000)];
    scrollerView.contentSize = CGSizeMake(1024, 8000);
    [scrollerView addSubview:imageView];
    [self.view addSubview:scrollerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeHelp:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ShowHelpVCWasDismissed:)])
    {
        [self.delegate ShowHelpVCWasDismissed:self];
    }
}
@end
