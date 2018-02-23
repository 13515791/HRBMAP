//
//  AppDelegate.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-4-15.
//  Copyright (c) 2013年 Esri. All rights reserved.
//
//  Edited by MaY on 14-4-5.
//  Copyright (c) 2014年 esriChina. All rights reserved.
//

#import "AppDelegate.h"
#import "AGSPadViewController.h"
@interface AppDelegate(){
    NSString *_logPath;
}
@end
@implementation AppDelegate
@synthesize currentMapName,currentAtlasPath;
@synthesize drawGraphicLayer;

@synthesize datasetPoint;
@synthesize datasetLine;
@synthesize datasetPolygon;
@synthesize isShowDrawInfo=_isShowDrawInfo;
@synthesize worldTpkPath=_worldTpkPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    self.viewController = [[AGSPadViewController alloc] initWithNibName:@"AGSPadViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
-(void)logAppStatus:(NSString *)status{
    if (!_logPath){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        _logPath = [path stringByAppendingPathComponent:@"appLog.txt"];
    }
    
    NSFileHandle *logFileHandle = [NSFileHandle fileHandleForWritingAtPath:_logPath];
    if (logFileHandle){
        [logFileHandle seekToEndOfFile];
        [logFileHandle writeData:[status dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        // have to create the file...
        [status writeToFile:_logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
- (void)prepareUI
{
    //statue bar
    if (iOSVersion >=7.0) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
    }
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskAll;
//}

@end
