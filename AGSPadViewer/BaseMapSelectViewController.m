//
//  BaseMapSelectViewController.m
//  AGSPadViewer
//
//  Created by EsriChina_Mobile on 13-7-23.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "BaseMapSelectViewController.h"
#import "AppEvent.h"
#import "AppEventNames.h"

@interface BaseMapSelectViewController (){
    NSArray *_iconArray;
}
- (id)init;
- (void)setImage;
- (void)loadImage;
- (void)viewDetail;
-(void)changeIcon:(id)sender;
-(void)highlightButton:(UIButton *)btn;
-(void)sgViewDissAppear;
-(void)endAnimation;
-(void)didEnd;
@end
#define VIEW_ORIGIN_X 780
//#define VIEW_ORIGIN_Y 10
#define VIEW_ORIGIN_Y 120
#define BUTTOM_MARGIN 10
#define TOP_MARGIN 10
#define MARGIN_X 10
#define MARGIN_Y 10


//-------------------------
// You should change the following two sizes
//    if you want to change the number of a party's icons or icons sizes.
//-------------------------
#define BTN_W_H 48
#define ONE_ROW_ICON 3

//-------------------------
// The number of buttons needs to be the same as the number of [NSDictionary count].
// Under the present circumstances, it is OK to 20 pieces.
//-------------------------
#define BUTTON_COUNT 20

@implementation BaseMapSelectViewController
    NSInteger _iconNumber;
    UIButton *_btn[BUTTON_COUNT];

@synthesize selectBtn = _selectBtn;
@synthesize mapView = _mapView;

-(id) init{
    return [self initWithNibName:nil bundle:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setView:[[UIView alloc] init]];
        _iconNumber = -1;
    }
    return self;
}
-(id)initWithBasemaps:(NSArray *)basemaps
{
    self = [super init];
    if (self)
    {
        _iconArray = basemaps;
        [self loadImage];
        [self viewDetail];
    }
    return self;
}
#pragma self.view

//-------------------------
// self.view setting
//-------------------------
-(void)viewDetail
{
    //x is Row count
    int x = 0;
    
    if([_iconArray count] % ONE_ROW_ICON != 0)
        x = [_iconArray count]/ONE_ROW_ICON + 1;
    else
        x = [_iconArray count]/ONE_ROW_ICON ;
    
    [self.view setAlpha:0.0];
    [self.view setFrame:CGRectMake(self.mapView.frame.size.width - 244, VIEW_ORIGIN_Y, (MARGIN_X+BTN_W_H)*ONE_ROW_ICON+MARGIN_X, BUTTOM_MARGIN + (BTN_W_H+MARGIN_Y)*x)];
    [self.view setClipsToBounds:true];
    [self.view setBackgroundColor:[UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0]];
    //UIImage *backgroundImage = [UIImage imageNamed:@"win01.png"];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    self.view.layer.cornerRadius = 5;
}

#pragma Menu Button

//-------------------------
// Icon load&set
//-------------------------
-(void)loadImage
{
    if (!_iconArray)
    {
        return;
    }
    int index = 0;
    int row = 0;
    int count = 0;
    for (NSArray *tmpStr in _iconArray)
    {
        
        if(count<BUTTON_COUNT)
        {
            _btn[count] = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btn[count] setFrame:CGRectMake((index+1)*MARGIN_X+index*BTN_W_H,TOP_MARGIN+(MARGIN_Y+BTN_W_H)*row, BTN_W_H, BTN_W_H)];
            [_btn[count] setBackgroundImage:[UIImage imageNamed:[tmpStr objectAtIndex:1]] forState:UIControlStateNormal];
            [_btn[count] addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
            [_btn[count] setTag:count];
            [self.view addSubview:_btn[count]];
            
            index++;
            count++;
            
            if(index%ONE_ROW_ICON == 0)
            {
                row++;
                index = 0;
            }
        }
        
    }
    
}


//-------------------------
// Icon change action
//-------------------------
-(void)changeIcon:(id)sender
{
    //switch basemap
    [self performSelector:@selector(switchBasemap:) withObject:sender afterDelay:0.0];
    //
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.1];
}
//-------------------------
// Switch Basemap
//-------------------------
-(void)switchBasemap:(UIButton *)btn
{
    NSArray *basemapSnap = [_iconArray objectAtIndex:btn.tag];
    NSString *layerLabel = [basemapSnap objectAtIndex:0];
    NSString *layerURL = [basemapSnap objectAtIndex:2];
    NSString *layerType = [basemapSnap objectAtIndex:3];
    
    AGSLayer *layer = [self.mapView.mapLayers objectAtIndex:0];
    id baseMaplayer = nil;
    if (self.mapView.mapLayers.count > 0)
    {
        if ([layer.name isEqualToString:layerLabel])
        {
            return;
        }
        else if ([layerType isEqualToString:@"tiled"])
        {
            baseMaplayer = [[AGSTiledMapServiceLayer alloc]initWithURL:[NSURL URLWithString:layerURL]];
        }
        else if([layerType isEqualToString:@"localTiled"])
        {
            NSString *_TPKPath;
            if ([layerURL hasPrefix:@"/"])
            {
                NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                _TPKPath =  [documentsDirectory stringByAppendingPathComponent:layerURL];
            }
            else
            {
                _TPKPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:layerURL];
                
            }
            NSFileManager *fileMng = [[NSFileManager alloc]init];
            if ([fileMng fileExistsAtPath:_TPKPath])
            {
                baseMaplayer = [AGSLocalTiledLayer localTiledLayerWithPath:_TPKPath];
            }
            else
            {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                               message:@"指向的tpk数据不存在！"
                                                              delegate:nil
                                                     cancelButtonTitle:@"返回"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    if (baseMaplayer)
    {
        [self.mapView removeMapLayer:layer];
        [self.mapView insertMapLayer:baseMaplayer withName: layerLabel atIndex:0];
    }
}
//-------------------------
// HighLight Button
//-------------------------
-(void)highlightButton:(UIButton *)btn
{
    for(int i = 0; i < BUTTON_COUNT; i++)
    {
        int x = _btn[i].tag;
        
        if(btn.tag == x)
        {
            _btn[x].highlighted = NO;
            _iconNumber = x;
        }
        else
        {
            _btn[i].highlighted = YES;
            
        }
    }
    //[self performSelector:@selector(didEnd) withObject:nil afterDelay:0.1];
}


#pragma OK Button&Animation

//-------------------------
// Appear sgView animation
//-------------------------
-(void)sgViewAppear
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
    
    [self viewDetail];
    [self.view setAlpha:1.0];
    [UIView commitAnimations];
}

//---------------------------
// DisAppear sgView animation
//---------------------------
-(void)sgViewDissAppear
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    [self.view setAlpha:0.0];
    
    [UIView commitAnimations];
}

//-------------------------
// Tap OK Button Action
//-------------------------
-(void)didEnd
{
    [self sgViewDissAppear];
}


//-------------------------
// After end animaiton
//-------------------------
-(void)endAnimation
{
    
}


#pragma view cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    _selectBtn = nil;
    _mapView = nil;
}
@end
