////////////////////////////////////////////////////////////////////////////////
//
//Copyright (c) 2011-2012 Esri
//
//All rights reserved under the copyright laws of the United States.
//You may freely redistribute and use this software, with or
//without modification, provided you include the original copyright
//and use restrictions.  See use restrictions in the file:
//<install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////

#import "AddBookmarkViewController.h"
#import "ArcGIS/ArcGIS.h"
//消息名
#define kBookmark_ExtendChange @"bk_ExtendChange"

@implementation AddBookmarkViewController
@synthesize tableView = _tableView;
@synthesize extent = _extent;
@synthesize delegate = _delegate;
@synthesize wkid = _wkid;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //监听主页面推送过来的消息执行reRoadTableView函数刷新显示
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reRoadTableView)
                                                name:kBookmark_ExtendChange
                                              object:nil];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)makeSubCell:(UITableViewCell *)aCell withTitle:(NSString *)title
             value:(NSString *)value
{
	CGRect tRect = CGRectMake(20,5, 60, 40);
	UILabel *lbl = [[UILabel alloc] initWithFrame:tRect];
    lbl.font = WIDGET_CONTENTFONT;
	[lbl setText:title];
	[lbl setBackgroundColor:[UIColor clearColor]];
    [aCell addSubview:lbl];
    
	CGRect tEdtRect = CGRectMake(160,15, 220, 40);
	UITextField *edtField= [[UITextField alloc] initWithFrame:tEdtRect];
	[edtField setBackgroundColor:[UIColor clearColor]];    
	edtField.autocorrectionType = UITextAutocorrectionTypeNo;
	edtField.autocapitalizationType= UITextAutocapitalizationTypeNone;
    edtField.placeholder =@"书签名称";

	[aCell addSubview:edtField];
	_nameTextFiled = edtField;
    
}
//返回表格有几个组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rtn=0;
	if (section == 0) {
		rtn = 1;
	}
	else {
		rtn = 4;
	}
	
	return rtn;
}
//更新空间范围数据显示，主程序推送当前的地图范围给窗体
-(void)updateSpatialCell:(double)xmin ymin:(double)ymin xmax:(double)xmax ymax:(double)ymax
{
    //更新空间范围刷新表格
    _extent = [[AGSMutableEnvelope alloc]initWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:[AGSSpatialReference spatialReferenceWithWKID:_wkid]];
    [_tableView reloadData];
    
}
//接受到消息后执行的函数
-(void)reRoadTableView
{
    [self.tableView reloadData];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (indexPath.section == 0) {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            [self makeSubCell:cell withTitle:@"名称:" value:@""];
		}
	}
	else {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
			
		}
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"X最小值:";
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%lf",_extent.xmin];
				break;
			case 1:
				cell.textLabel.text = @"Y最小值:";
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%lf",_extent.ymin];
				break;
			case 2:
				cell.textLabel.text = @"X最大值:";
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%lf",_extent.xmax];
				break;
			case 3:
				cell.textLabel.text = @"Y最大值:";
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%lf",_extent.ymax];
				break;
			default:
				break;
		}
	}
    cell.textLabel.font = WIDGET_CONTENTFONT;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Section title is the region name	
	NSString *rtnTitle=@"";
	if (section==0) {
		rtnTitle=@"书签名称";
	}
	else {
		rtnTitle=@"空间范围";
	}
	return rtnTitle;
}
//验证数据库中是否存在
-(IBAction) done:(id)sender
{
	if (_nameTextFiled.text == nil || [_nameTextFiled.text isEqualToString:@""]) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" 
														 message:@"请输入书签名称" 
														delegate:self 
											   cancelButtonTitle:@"确定" 
											   otherButtonTitles:nil];
		
		[alert show];
	}
	else
	{
		if ([self.delegate respondsToSelector:@selector(AddBookmarkDone:withName:)]) 
		{
			[self.delegate AddBookmarkDone:self withName:_nameTextFiled.text];
		}
	}
}

-(IBAction) cancel:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(AddBookmarkCancel:)]) 
	{
		[self.delegate AddBookmarkCancel:self ];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	self.delegate = nil;
}
@end
