//
//  SearchResultViewController.m
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "SearchResultViewController.h"
#import "POI.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 15, 300, 500) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View methods
//one section in this table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!_searchResult){
        return 1;
    }
    return _searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!_searchResult){
        static NSString *NodataCellIdentifier = @"NodataCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NodataCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NodataCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView.alpha = 0.5;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.textLabel.text = @"没有结果";
        cell.textLabel.alpha = 0.7;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    POI *poi = (POI *)[_searchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.Name;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(searchResultPickerIndex:forTableType:)]) {
        [self.delegate searchResultPickerIndex:indexPath.row forTableType:TableType_SearchResult];
    }
}
@end
