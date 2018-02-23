//
//  MenuRootViewController.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "MenuRootViewController.h"
#import "UIView+PSSizes.h"
#import "MenuData.h"
#import "MenuTableViewCell.h"



@interface MenuRootViewController ()

@end

@implementation MenuRootViewController
@synthesize delegate =_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(id) init
{
    self = [super init];
    if (self) {
        _menuContents = [[NSMutableArray alloc] initWithCapacity:10];
        [self tableViewInit];
    }
    return self;
}
-(void) tableViewInit
{
    self.view.frame = CGRectMake(0, 0, MENU_WIDTH, MENU_HEIGHT);
    _menuTableView= [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, self.view.origin.y, self.view.width, self.view.height) style:UITableViewStylePlain];
    //_menuTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bannerTop.png"]];
    //_menuTableView.backgroundColor = MENU_BACKGROUNDCOLOR;
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTableView];
    _menuTableView.scrollEnabled = MENU_SLIDING;
    _selectedIndex = -1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   [_menuTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) addMenuData:(MenuData *)menuData
{
    if (_menuContents != nil) {
        [_menuContents addObject:menuData];
    }
}
-(void) addMenuDatas:(NSArray *)menuDatas
{
    if (_menuContents != nil) {
        [_menuContents addObjectsFromArray:menuDatas];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_WIDTH;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuContents count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuTableViewCell";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	MenuData * menuData = [_menuContents objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell applyCellContent:menuData];

    if (iOSVersion >= 7.0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }

    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectedIndex == indexPath.row) {
        MenuTableViewCell * cell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isChecked = !cell.isChecked;
        if (cell.isChecked) {
            //cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"selected.png"]];
        }
        else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    else
    {
        if (_selectedIndex >= 0) {
            //need iOS 6.0
            //NSIndexPath * indx = [NSIndexPath indexPathForItem: (NSInteger)_selectedIndex inSection:(NSInteger)0];
            NSUInteger indx[2] = {0, _selectedIndex};
            NSIndexPath * indxPath = [NSIndexPath indexPathWithIndexes:indx length:2];
            MenuTableViewCell * oldcell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indxPath];
            oldcell.isChecked = NO;
            oldcell.contentView.backgroundColor = [UIColor clearColor];
        }
        MenuTableViewCell * cell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isChecked = YES;
    }
    if ([self.delegate respondsToSelector:@selector(menuSelectedChanged:selectedIndex:)]) {
        [self.delegate menuSelectedChanged:self selectedIndex:indexPath.row];
    }
    _selectedIndex = indexPath.row;

}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation ==  UIInterfaceOrientationPortrait ||toInterfaceOrientation ==  UIInterfaceOrientationPortraitUpsideDown ) {
        self.view.frame = CGRectMake(0, 0, MENU_WIDTH, WIDGET_LEFT_VIEW_HEIGHT);
    }
    else{
        self.view.frame = CGRectMake(0, 0, MENU_WIDTH, WIDGET_LEFT_VIEW_HEIGHT);
    }
}
@end
