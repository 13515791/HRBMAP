//
//  MenuTableViewCell.h
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuData.h"
@interface MenuTableViewCell : UITableViewCell
{
    UILabel *_detailLabel;
    UIImageView *_iconImageView;
    UIImage *_iconImageSelected;
    UIImage *_iconImageUnSelected;
    BOOL    _isChecked;
}
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel     *detailLabel;
@property(nonatomic,strong) UIImage     *iconImageSelected;
@property(nonatomic,strong) UIImage     *iconImageUnSelected;
@property(nonatomic,assign) BOOL        isChecked;
-(void) applyCellContent:(MenuData*)menuData;
@end
