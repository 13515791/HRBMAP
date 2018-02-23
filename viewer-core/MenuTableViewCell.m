//
//  MenuTableViewCell.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize detailLabel = _detailLabel;
@synthesize iconImageView = _iconImageView;
@synthesize isChecked = _isChecked;
@synthesize iconImageSelected = _iconImageSelected;
@synthesize iconImageUnSelected = _iconImageUnSelected;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.clipsToBounds = YES;
    if (self) {
        UIView* bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
        //self.selectedBackgroundView = bgView;

        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MENU_CELL_WIDTH, MENU_CELL_WIDTH)];
        [self addSubview:_iconImageView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MENU_CELL_WIDTH, 1)];
        topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //[self.textLabel.superview addSubview:topLine];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MENU_CELL_WIDTH-25, MENU_CELL_WIDTH, 30)];
        _detailLabel.text = @"";
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = MENU_FONT;
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.shadowOffset = CGSizeMake(0, 2);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.05];
        //[self addSubview:_detailLabel];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, MENU_WIDTH, MENU_CELL_WIDTH, 1)];
        bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //[self.textLabel.superview addSubview:bottomLine];
    
        _isChecked = NO;
    }

    return self;
}
-(void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    if (_isChecked) {
        _detailLabel.textColor = [UIColor colorWithRed:70/255.0 green:103/255.0 blue:153/255.0 alpha:1.0];
         _detailLabel.shadowColor = [UIColor colorWithRed:182/255.0 green:213/255.0 blue:127/255.0 alpha:0.1];
        _iconImageView.image = _iconImageSelected;
    }
    else
    {
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.05];
        _iconImageView.image = _iconImageUnSelected;
    }
}
-(void)applyCellContent:(MenuData*)menuData
{
    _detailLabel.text = menuData.details;
    NSString *iconOffFilePath = [[menuData.iconName stringByDeletingPathExtension]stringByAppendingString:@"_Off.png"];
    _iconImageSelected = [[UIImage alloc] initWithContentsOfFile:menuData.iconName];
    _iconImageUnSelected = [[UIImage alloc] initWithContentsOfFile:iconOffFilePath];
    _iconImageView.image = _iconImageUnSelected;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
