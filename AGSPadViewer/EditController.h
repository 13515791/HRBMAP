//
//  EditController.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAttachment.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h> 
#import "BaseWidget.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ImageViewController.h"
#import "NonRotatingUIImagePickerController.h"

@class EditController;
@protocol EditControllerDelegate <NSObject>

@optional

-(void)EditControllerWasDismissed: (EditController *) editorViewController;
-(void)EditControllerReturnEditorMessage:(EditController *)editorViewController :(NSString *)descriptText :(NSMutableArray *)attachment :(NSString *)Update;
-(void)delgraphic:(EditController *)editorViewController :(NSString *)graID;

@end

@interface EditController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectAttachmentDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate>
{
    
}

- (void) addTemplatesForLayersInMap:(AGSGraphic*)grahic;
- (void) allowEditor;
- (IBAction)addAttachmentbutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addattbutton;

@property (strong, nonatomic) IBOutlet UIToolbar *delToolsbar;
@property (nonatomic,strong) UITextView *descriptionText;
- (IBAction)FinishEdit:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *AttachmentTableView;
@property (nonatomic, weak) id<EditControllerDelegate> delegate;
- (IBAction)CannelController:(id)sender;
- (IBAction)addAttachment:(id)sender;
@property (nonatomic,strong) SelectAttachment *selectAtt;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AttachmentID;
@property (nonatomic,strong) UIPopoverController *attachmentPOP;
//@property (nonatomic,strong) UIImagePickerController *getPhote;
//@property (nonatomic,strong) NonRotatingUIImagePickerController *getPhote;
@property (nonatomic,strong) UIImagePickerController *getPhote;
@property (nonatomic,strong) NSMutableArray *AttList;
@property (nonatomic,strong) NSString *descriptMessage;
@property (nonatomic,strong) NSString *isUpdata;
@property (nonatomic,strong) ImageViewController *imgVC;
@property (nonatomic,strong) NSString *graphicID;
@end
