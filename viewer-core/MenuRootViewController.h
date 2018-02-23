//
//  MenuRootViewController.h
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuData;
@class MenuRootViewController;
@protocol MenuRootDelegate <NSObject>

-(void) menuSelectedChanged:(MenuRootViewController*)menuRootVC selectedIndex:(int)selectedIndex;

@end
@interface MenuRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_menuTableView;
    NSMutableArray *_menuContents;
    id<MenuRootDelegate> __weak _delegate;
    int                 _selectedIndex;
    UIImageView *_logoView;
}
@property(nonatomic,weak)id<MenuRootDelegate> delegate;
-(void) addMenuData:(MenuData *)menuData;
-(void) addMenuDatas:(NSArray *)menuDatas;
@end
