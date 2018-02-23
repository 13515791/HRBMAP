//
//  ShowMessageViewController.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-27.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "ShowMessageViewController.h"

@interface ShowMessageViewController ()

@end

@implementation ShowMessageViewController
@synthesize delegate=_delegate;
@synthesize baseMapName=_baseMapName;
@synthesize files=_files;
@synthesize pop=_pop;
@synthesize imgPathShow=_imgPathShow;

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *messageImg;
    
    NSString *titleImgPath;
    
    if([_baseMapName isEqualToString:@"世界地图集"]==YES)
    {
        NSString *tpkPathStr=delegate.worldTpkPath;
        NSString *imgsPath=[tpkPathStr stringByDeletingLastPathComponent];
        NSFileManager* filemanager=[NSFileManager defaultManager];
        NSArray *mainImgPaths=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/pdf/",documentsDir,imgsPath]];
        
        for(NSInteger i=0;i<mainImgPaths.count;i++)
        {
            if([[mainImgPaths[i] pathExtension] isEqualToString:@"jpg"]==YES)
            {
                //[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/",documentsDir,mapName]
                messageImg=[NSString stringWithFormat:@"%@%@/pdf/%@",documentsDir,imgsPath,mainImgPaths[i]];
            }
        }
        
        NSArray *mainimg2=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/titleImg/",documentsDir,imgsPath]];
        
        for(NSInteger i=0;i<mainimg2.count;i++)
        {
            if([[mainimg2[i] pathExtension] isEqualToString:@"png"]==YES)
            {
                //[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/",documentsDir,mapName]
                titleImgPath=[NSString stringWithFormat:@"%@%@/titleImg/%@",documentsDir,imgsPath,mainimg2[i]];
            }
        }
        
        //messageImg=[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/%@.jpg",documentsDir,mapName,mapName];
        NSString *images=[NSString stringWithFormat:@"%@%@/images/",documentsDir,imgsPath];
        _imgPathShow=images;
        _files = [filemanager subpathsAtPath:images ];
    }
    else if([_baseMapName isEqualToString:@"中国地图集"]==YES)
    {
        //当前地图名称
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSFileManager* filemanager=[NSFileManager defaultManager];
        NSString *tpkPathStr;
        //判断当前图集时候存在详细信息
        
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            //NSString *SqlStr=@"select * from POI_new where MC like";
            NSString *SqlStr=[NSString stringWithFormat:@"select * from CAData where CityName = '%@'",delegate.currentMapName];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *tpkPaht=(char *)sqlite3_column_text(statement, 3);
                    tpkPathStr=[[NSString alloc] initWithUTF8String:tpkPaht];
                }
            }
            //关闭数据库
            sqlite3_close(MyDatabase);
        }
        
        NSString *imgsPath=[tpkPathStr stringByDeletingLastPathComponent];
        NSArray *mainimg=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/pdf/",documentsDir,imgsPath]];
                for(NSInteger i=0;i<mainimg.count;i++)
        {
            if([[mainimg[i] pathExtension] isEqualToString:@"jpg"]==YES)
            {
                messageImg=[NSString stringWithFormat:@"%@%@/pdf/%@",documentsDir,imgsPath,mainimg[i]];
            }
        }
        
        //NSString *titleImgPath1=
        NSArray *mainimg2=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/titleImg/",documentsDir,imgsPath]];

        for(NSInteger i=0;i<mainimg2.count;i++)
        {
            if([[mainimg2[i] pathExtension] isEqualToString:@"png"]==YES)
            {
                //[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/",documentsDir,mapName]
                titleImgPath=[NSString stringWithFormat:@"%@%@/titleImg/%@",documentsDir,imgsPath,mainimg2[i]];
            }
        }
        
        NSString *images=[NSString stringWithFormat:@"%@%@/images/",documentsDir,imgsPath];
        _imgPathShow=images;
        _files = [filemanager subpathsAtPath:images ];
    }
    else if([_baseMapName isEqualToString:@"内蒙地图集"]==YES)
    {
        //当前地图名称
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSFileManager* filemanager=[NSFileManager defaultManager];
        NSString *tpkPathStr;
        //判断当前图集时候存在详细信息
        
        if (sqlite3_open([[self DBfilePath] UTF8String], &MyDatabase) == SQLITE_OK)
        {
            //NSString *SqlStr=@"select * from POI_new where MC like";
            NSString *SqlStr=[NSString stringWithFormat:@"select * from tttt where CountyName = '%@'",delegate.currentMapName];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(MyDatabase, [SqlStr UTF8String], -1, &statement, nil) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    char *tpkPaht=(char *)sqlite3_column_text(statement, 3);
                    tpkPathStr=[[NSString alloc] initWithUTF8String:tpkPaht];
                }
            }
            //关闭数据库
            sqlite3_close(MyDatabase);
        }
        
        NSString *imgsPath=[tpkPathStr stringByDeletingLastPathComponent];
        NSArray *mainimg=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/pdf/",documentsDir,imgsPath]];

        for(NSInteger i=0;i<mainimg.count;i++)
        {
            if([[mainimg[i] pathExtension] isEqualToString:@"jpg"]==YES)
            {
                messageImg=[NSString stringWithFormat:@"%@%@/pdf/%@",documentsDir,imgsPath,mainimg[i]];
            }
        }
        
        NSArray *mainimg2=[filemanager subpathsAtPath:[NSString stringWithFormat:@"%@/%@/titleImg/",documentsDir,imgsPath]];
        
        for(NSInteger i=0;i<mainimg2.count;i++)
        {
            if([[mainimg2[i] pathExtension] isEqualToString:@"png"]==YES)
            {
                //[NSString stringWithFormat:@"%@/data/WorldAtlas/%@/pdf/",documentsDir,mapName]
                titleImgPath=[NSString stringWithFormat:@"%@%@/titleImg/%@",documentsDir,imgsPath,mainimg2[i]];
            }
        }
        
        NSString *images=[NSString stringWithFormat:@"%@%@/images/",documentsDir,imgsPath];
        _imgPathShow=images;
        _files = [filemanager subpathsAtPath:images ];
    }
    
    UIImage *titleimage=[[UIImage alloc] initWithContentsOfFile:titleImgPath];
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(357, 0, 310 , 45)];
    titleImageView.image=titleimage;
    
    
    UIImage *messageImage=[[UIImage alloc] initWithContentsOfFile:messageImg];
    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 800 , 724)];
    
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = NO;
    scrollerView.alwaysBounceHorizontal = YES;
    UIImageView *imageView=[[UIImageView alloc] init];
    [imageView setImage:messageImage];
    //imageView.contentMode=UIViewContentModeScaleAspectFill;
    [imageView setFrame:CGRectMake(0, 0, 800, imageView.image.size.height*0.38)];
    scrollerView.contentSize = CGSizeMake(800, imageView.image.size.height*0.38);
    [self.view addSubview:titleImageView];
    [scrollerView addSubview:imageView];
    [self.view addSubview:scrollerView];
    
    //self.imageShow.image=messageImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeMessage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ShowMessageViewControllerWasDismissed:)])
    {
        [self.delegate ShowMessageViewControllerWasDismissed:self];
    }
}

-(void)showMessage:(NSString *)message
{
    _baseMapName=message;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    NSString *imgfilePath=[NSString stringWithFormat:@"%@%@",_imgPathShow,_files[indexPath.row]];
    
    UIImage *mediaImg=[[UIImage alloc] initWithContentsOfFile:imgfilePath];
    
    UIImageView *cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(22, 5, 180,135)];
    cellImg.image = mediaImg;
    [cell addSubview:cellImg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgfilePath=[NSString stringWithFormat:@"%@%@",_imgPathShow,_files[indexPath.row]];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600,500)];
    imageView.image=[[UIImage alloc] initWithContentsOfFile:imgfilePath];
    UIViewController *ddd=[[UIViewController alloc] init];
    [ddd.view setFrame:CGRectMake(0, 0, 600,500)];
    [ddd.view addSubview:imageView];
    _pop = [[UIPopoverController alloc] initWithContentViewController:ddd];
    _pop.popoverContentSize=CGSizeMake(600, 500);
    [_pop presentPopoverFromRect:self.pictureList.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    _pop.delegate=self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageShow;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageShow.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}

//数据库路径
- (NSString *)DBfilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"NMAtlas.sqlite"];
}
@end
