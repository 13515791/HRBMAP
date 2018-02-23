//
//  BookmarkToolViewController.m
//  EsriPadViewer
//
//  Created by zhang baocai on 13-5-30.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "BookmarkToolViewController.h"

@interface BookmarkToolViewController ()

@end

@implementation BookmarkToolViewController
@synthesize delegate;
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
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.frame =CGRectMake(10, 20, 180, 30);
    [addButton setBackgroundImage:[UIImage imageNamed:@"button_green.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addButton];
    
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"删除" forState:UIControlStateNormal];
    editButton.frame =CGRectMake(10, 60, 180, 30);
    [editButton setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:editButton];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];

}
-(void) addButtonTouched:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(bookmarkToolAdd:)]) {
        [self.delegate bookmarkToolAdd:self];
    }
}
-(void) editButtonTouched:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(bookmarkToolAdd:)]) {
        [self.delegate bookmarkToolEdit:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
