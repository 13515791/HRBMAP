//
//  ShowMessageViewController.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-27.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "sqlite3.h"

@class ShowMessageViewController;

@protocol ShowMessageViewControllerDelegate <NSObject>

@optional

-(void)ShowMessageViewControllerWasDismissed: (ShowMessageViewController *)showMessageViewController;

//-(void)SelectAttachmentController:(ShowMessageViewController*) SelectAttachment didSelect:(NSString*) sourceType;

@end

@interface ShowMessageViewController : UIViewController<UIScrollViewDelegate,UIPopoverControllerDelegate>
{
    sqlite3 *MyDatabase;
}
@property (strong, nonatomic) IBOutlet UITableView *pictureList;
@property (strong, nonatomic) IBOutlet UIImageView *imageShow;
@property (strong, nonatomic) IBOutlet UIScrollView *ViewScroll;

- (IBAction)closeMessage:(id)sender;
-(void)showMessage:(NSString *)message;
@property (nonatomic, weak) id<ShowMessageViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *baseMapName;
@property (nonatomic,strong) NSArray *files;
@property (nonatomic,strong) UIPopoverController *pop;
@property (nonatomic,strong) NSString *imgPathShow;
@end
