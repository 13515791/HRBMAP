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
#import "BookmarkWidget.h"
#import "TBXML.h"
#import "UIView+PSSizes.h"
#import "BookmarkToolViewController.h"
#import "AddBookmarkViewController.h"

#define BOOKMARKFILE @"bookmark.txt"
@interface BookmarkWidget()<UITableViewDataSource,UITableViewDelegate,AddBookmarkDelegate,BookmarkToolDelegate>{
	NSMutableArray * _bookmarks;
	NSString *_filePath;
    UITableView *_tableView;
    UIPopoverController *_bPopoverController;
    UIButton * opButton;
    AddBookmarkViewController * addBookmarkVC;
}
@end
@implementation BookmarkWidget
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

    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.contentView addSubview:_tableView];
    
    [self prepareToobbar:0];

    // 注册地图缩放移动事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:)
                                                 name:AGSMapViewDidEndPanningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:)
                                                 name:AGSMapViewDidEndZoomingNotification object:nil];
    addBookmarkVC = [[AddBookmarkViewController alloc] initWithNibName:@"AddBookmarkViewController" bundle:nil];
    
    //遍历maps，获取名称
    NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *lay=[[AGSLayer alloc] init];
        lay=mapLayers[i];
        NSString *name=lay.name;
        NSLog(@"%@", name);
        if([name isEqualToString: @"poiGraphics"] == YES)
        {
            [self.mapView removeMapLayerWithName:name];
        }
    }
}

//地图路径
- (NSString *)MapfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

- (void)respondToEnvChange: (NSNotification*) notification {
    double xmin=self.mapView.visibleAreaEnvelope.xmin;
    double ymin=self.mapView.visibleAreaEnvelope.ymin;
    double xmax=self.mapView.visibleAreaEnvelope.xmax;
    double ymax=self.mapView.visibleAreaEnvelope.ymax;
    [addBookmarkVC updateSpatialCell:xmin ymin:ymin xmax:xmax ymax:ymax];
}
- (void)prepareToobbar:(int)state{
    NSArray *tools = [NSArray array];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (state == 0) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBookmark)];
        tools = @[flexibleSpace,addButton,flexibleSpace,deleteButton,flexibleSpace];
    }else if(state == 1){
        UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完 成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishEditBookmark)];
        tools = @[flexibleSpace,finishButton,flexibleSpace];
    }
    self.bottomToolBar.items = tools;
}
- (void)addBookmark{
    if (!addBookmarkVC) {
        addBookmarkVC = [[AddBookmarkViewController alloc] initWithNibName:@"AddBookmarkViewController" bundle:nil];
    }
    addBookmarkVC.delegate = self;
    addBookmarkVC.extent = [self.mapView.visibleAreaEnvelope mutableCopy];
    [self.navigationController pushViewController:addBookmarkVC animated:YES];
}

- (void)deleteBookmark{
    [_tableView setEditing:YES] ;
    //编辑状态工具栏标题为完成
    [self prepareToobbar:1];
}

- (void)finishEditBookmark{
    [_tableView setEditing:NO] ;
    //重置工具栏
    [self prepareToobbar:0];
}

-(void)btnTouched:(id) sender
{
    UIButton *btn = (UIButton *)sender;
    if([btn.titleLabel.text isEqualToString:@"编辑"])
    {
        if (_bPopoverController == nil) {
            BookmarkToolViewController * btVC = [[BookmarkToolViewController alloc] init];
            btVC.contentSizeForViewInPopover = CGSizeMake(200, 100);
            btVC.delegate = self;
            _bPopoverController = [[UIPopoverController alloc] initWithContentViewController:btVC];
        }
        if ([_bPopoverController isPopoverVisible])
        {
            [_bPopoverController dismissPopoverAnimated:YES];
        }
        else
        {
            UIButton * btn = (UIButton *)sender;
            [_bPopoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionAny) animated:YES];
        }
    }
    else{
        [_tableView setEditing:NO] ;
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

#pragma -mark BookmarkToolDelegate
-(void)bookmarkToolAdd:(BookmarkToolViewController *) bookmarkToolViewController
{
    if (_bPopoverController != nil &&[_bPopoverController isPopoverVisible]) {
        [_bPopoverController dismissPopoverAnimated:YES];
    }
    if (!addBookmarkVC) {
        addBookmarkVC = [[AddBookmarkViewController alloc] initWithNibName:@"AddBookmarkViewController" bundle:nil];
    }
    addBookmarkVC.delegate = self;
    addBookmarkVC.extent = [self.mapView.visibleAreaEnvelope mutableCopy];
    [self.navigationController pushViewController:addBookmarkVC animated:YES];
    
}
-(void)bookmarkToolEdit:(BookmarkToolViewController *) bookmarkToolViewController
{
    if (_bPopoverController != nil &&[_bPopoverController isPopoverVisible]) {
        [_bPopoverController dismissPopoverAnimated:YES];
    }
    [_tableView setEditing:YES] ;
    //编辑状态下按钮标题为完成
    [opButton setTitle:@"完成" forState:UIControlStateNormal];
}

#pragma -mark AddBookmarkDelegate
-(void)AddBookmarkDone:(AddBookmarkViewController *) addBookmarkViewController withName:(NSString*)bookmarkName{
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableDictionary * bookmarkEntity = [[NSMutableDictionary alloc] initWithCapacity:1];
	[bookmarkEntity setObject:bookmarkName forKey:@"name"];
	NSString * strExtent = [NSString stringWithFormat:@"%lf %lf %lf %lf",
							addBookmarkViewController.extent.envelope.xmin,
							addBookmarkViewController.extent.envelope.ymin,
							addBookmarkViewController.extent.envelope.xmax,
							addBookmarkViewController.extent.envelope.ymax];
    
	
	[bookmarkEntity setObject:strExtent forKey:@"extent"];
	
	[_bookmarks addObject:bookmarkEntity];
	[_bookmarks writeToFile:_filePath atomically:YES];
    [_tableView reloadData];
}
-(void)AddBookmarkCancel:(AddBookmarkViewController *) addBookmarkViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [_bookmarks count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookmarkCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = WIDGET_CONTENTFONT;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = WIDGET_CONTENTCELLBACKGROUNDCOLOR;
    }
    cell.textLabel.text = [[_bookmarks objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
}
#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    BookmarkDetailsViewController * bdVC = [[BookmarkDetailsViewController alloc] init];
    bdVC.details = [[_bookmarks objectAtIndex:indexPath.row] objectForKey:@"name"];
    self.detailsViewController = bdVC;
    [bdVC release];
    [self showDetails];
     */
    NSDictionary * dict = [_bookmarks objectAtIndex:indexPath.row];
    NSString *strExtent = [dict objectForKey:@"extent"];
    NSArray *listItems = [strExtent componentsSeparatedByString:@" "];
    AGSEnvelope * extent = [AGSEnvelope
                            envelopeWithXmin:[[listItems objectAtIndex:0] doubleValue]
                            ymin:[[listItems objectAtIndex:1] doubleValue]
                            xmax:[[listItems objectAtIndex:2] doubleValue]
                            ymax:[[listItems objectAtIndex:3] doubleValue]
                            spatialReference:nil];
    [self.mapView zoomToEnvelope:extent animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除数据操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_bookmarks removeObjectAtIndex:indexPath.row];
        if ([_bookmarks writeToFile:_filePath atomically:YES]) {
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];            
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"信息提示"
                                                           message:@"书签删除失败"
                                                          delegate:nil
                                                 cancelButtonTitle:@"完成"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
#pragma mark BaseWidget
-(void) create
{
	[super create];
	/*
	<?xml version="1.0" ?>
	<configuration label="Bookmarks (example)">
    <bookmarks>
	<bookmark name="Contiguous USA">-13934000 2699500 -8034300 6710900</bookmark>
	<bookmark name="San Francisco">-13638000 4541000 -13632000 4551000</bookmark>
    </bookmarks>
	</configuration>
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString* pListPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Bookmark",pListPath];
	//没有的话就创建路径
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
	
	NSString *bookmarkFilePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,BOOKMARKFILE];
	_filePath = bookmarkFilePath;
	if ([fileManager fileExistsAtPath:bookmarkFilePath]) {
		_bookmarks = [[NSMutableArray alloc] initWithContentsOfFile:bookmarkFilePath];
    }
	else {
		_bookmarks = [[NSMutableArray alloc] initWithCapacity:10];	
		[_bookmarks writeToFile:bookmarkFilePath atomically:YES];
		NSString * strXml = self.widgetConfig;
		TBXML * tbxml=[[TBXML alloc] initWithXMLString:strXml];
		TBXMLElement *rootXMLElement = tbxml.rootXMLElement;
		TBXMLElement *bookmarksElement = [TBXML childElementNamed:@"bookmarks" parentElement:rootXMLElement];
		if (bookmarksElement != nil) 
		{
			TBXMLElement * bookmarkElement = bookmarksElement->firstChild;
			while (bookmarkElement) 
			{
				NSMutableDictionary * bookmarkEntity = [[NSMutableDictionary alloc] initWithCapacity:2];
				NSString *strName= [TBXML valueOfAttributeNamed:@"name" forElement:bookmarkElement];
				[bookmarkEntity setObject:strName forKey:@"name"];
				
				NSString *strExtent=[TBXML textForElement:bookmarkElement];
				/*
				NSArray *listItems = [strExtent componentsSeparatedByString:@" "];
				AGSEnvelope * extent = [[AGSEnvelope alloc] 
											initWithXmin:[[listItems objectAtIndex:0] doubleValue] 
											ymin:[[listItems objectAtIndex:1] doubleValue]  
											xmax:[[listItems objectAtIndex:2] doubleValue]  
											ymax:[[listItems objectAtIndex:3] doubleValue]  
											spatialReference:nil];
				 */
				
				[bookmarkEntity setObject:strExtent forKey:@"extent"];			
			//	[extent release];
				
				[_bookmarks addObject:bookmarkEntity];
				
				bookmarkElement = bookmarkElement->nextSibling;
			}
			
		}
		[_bookmarks writeToFile:bookmarkFilePath atomically:YES];
	}
}
-(void) active
{
	[super active];
    
    //初始化地图范围
    AGSLayer *baseLayer=[self.mapView baseLayer];
    [self.mapView removeMapLayer:baseLayer];
    NSString *filePath=[NSString stringWithFormat:@"%@%@",[self MapfilePath], @"/data/切片图层/nmsl.tpk"];
    AGSLocalTiledLayer* layer = [AGSLocalTiledLayer localTiledLayerWithPath:filePath];
    //10731970.0494 4417945.3028 14011863.5886 7101494.5621
    [self.mapView insertMapLayer:layer withName:@"内蒙区域全图" atIndex:0];
    AGSEnvelope *env=[AGSEnvelope envelopeWithXmin:10731970.0494 ymin:4417945.3028 xmax:14011863.5886 ymax:7101494.5621 spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:env animated:true];
    
    [self.mapView setMinScale:18489297.737236];
    [self.mapView setMaxScale:4513.988705];
    
    //遍历maps，获取名称
    NSArray *mapLayers=[self.mapView mapLayers];
    for(NSInteger i=0;i<mapLayers.count;i++)
    {
        AGSLayer *lay=[[AGSLayer alloc] init];
        lay=mapLayers[i];
        NSString *name=lay.name;
        NSLog(@"%@", name);
        if([name isEqualToString: @"poiGraphics"] == YES)
        {
            [self.mapView removeMapLayerWithName:name];
        }
    }
	
}
-(void) inactive
{
	[super inactive];
}
-(void)dealloc
{
	[_bookmarks writeToFile:_filePath atomically:YES];
}
@end
