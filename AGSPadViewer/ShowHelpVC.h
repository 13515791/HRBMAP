//
//  ShowHelpVC.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-10-18.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowHelpVC;

@protocol ShowHelpVCDelegate <NSObject>

@optional

-(void)ShowHelpVCWasDismissed: (ShowHelpVC *)ShowHelpVCViewController;

@end

@interface ShowHelpVC : UIViewController
{
    
}

@property (nonatomic, weak) id<ShowHelpVCDelegate> delegate;
- (IBAction)closeHelp:(id)sender;

@end
