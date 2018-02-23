//
//  SelectAttachment.h
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectAttachment;
@protocol SelectAttachmentDelegate <NSObject>

@optional

-(void)SelectAttachmentControllerWasDismissed: (SelectAttachment *) SelectAttachmentController;

-(void)SelectAttachmentController:(SelectAttachment*) SelectAttachment didSelect:(NSString*) sourceType;

@end

@interface SelectAttachment : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (strong, nonatomic) IBOutlet UITableView *ContentList;
@property (nonatomic, weak) id<SelectAttachmentDelegate> delegate;
@property (strong,nonatomic) NSArray *ConntentList;
@property (nonatomic, strong) SelectAttachment* SelectAttController;
@end
