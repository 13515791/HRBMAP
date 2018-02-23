//
//  EditController.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "EditController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>


@interface EditController ()

@end

@implementation EditController

@synthesize delegate=_delegate;
@synthesize attachmentPOP=_attachmentPOP;
@synthesize selectAtt=_selectAtt;
@synthesize getPhote=_getPhote;
@synthesize AttList=_AttList;
@synthesize descriptionText=_descriptionText;
@synthesize descriptMessage=_descriptMessage;
@synthesize isUpdata=_isUpdata;
@synthesize imgVC=_imgVC;
@synthesize graphicID=_graphicID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    _selectAtt = [storyboard instantiateViewControllerWithIdentifier:@"addAttachment"];
    self.selectAtt.delegate=self;
    //_AttList=[[NSMutableArray alloc] init];
    
    self.AttachmentTableView.layer.borderWidth=1.0;
    self.AttachmentTableView.layer.cornerRadius=5.0;
    
    //16,82,509,167
    _descriptionText=[[UITextView alloc] initWithFrame:CGRectMake(16, 82, 509, 167)];
    _descriptionText.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:.2].CGColor;
    _descriptionText.layer.borderWidth =1.0;
    _descriptionText.layer.cornerRadius =5.0;
    _descriptionText.delegate=self;
    _descriptionText.text=self.descriptMessage;
    [self.view addSubview:_descriptionText];
    
    //self.delToolsbar.hidden=YES;
    if(self.isUpdata==nil)
    {
         self.delToolsbar.hidden=YES;
        _AttList=[[NSMutableArray alloc] init];
    }
    else
    {
        self.delToolsbar.hidden=NO;
    }
}

- (void) addTemplatesForLayersInMap:(AGSGraphic*)grahic
{
    NSDictionary *graphicInfo=[grahic allAttributes];
    NSString *mediaDescription=[graphicInfo valueForKey:@"description"];
    NSString *mediaAttachmentPath=[graphicInfo valueForKey:@"attachmentpath"];
    NSString *grapicid=[graphicInfo valueForKey:@"attid"];
    _graphicID=grapicid;
    _descriptMessage=mediaDescription;
    self.AttList=[[NSMutableArray alloc] init];
    //mediaInfo=[[NSArray alloc] initWithObjects:mediaPath,mediaImg,medialistName,nil];
    
    NSArray *attachment=[mediaAttachmentPath componentsSeparatedByString:@"|"];
    
    NSString *attachmentName;
    NSString *attachPath;
    UIImage *attachImg;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    for(NSInteger i=0;i<attachment.count-1;i++)
    {
        attachPath=attachment[i];
        attachmentName=[attachment[i] lastPathComponent];
        if([[attachment[i] pathExtension] isEqualToString:@"png"]==YES)
        {
            attachImg=[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",paths[0],attachPath]];
        }
        else
        {
            attachImg=[self getImage:[NSString stringWithFormat:@"%@%@",paths[0],attachPath]];
        }
        
        NSArray *mediaInfo=[[NSArray alloc] initWithObjects:attachPath,attachImg,attachmentName,nil];
        [self.AttList addObject:mediaInfo];
    }
    self.delToolsbar.hidden=NO;
    _isUpdata=@"updata";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

#pragma mark - TableView委托
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.AttList.count);
    return self.AttList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a cell
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //static NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section, indexPath.row];//以indexPath来唯一确定cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSArray *mediainfo=[_AttList objectAtIndex:indexPath.row];
    //NSString *mediaPath=[mediainfo objectAtIndex:0];
    UIImage *mediaImg=[mediainfo objectAtIndex:1];
    NSString *mediaName=[mediainfo objectAtIndex:2];
    
    //cell.textLabel.text=mediaName;
    //cell.imageView.image=mediaImg;

    UIImageView *cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60,50)];
    cellImg.image = mediaImg;
    [cell addSubview:cellImg];
    
    UILabel *cellLabel=[[UILabel alloc] init];
    cellLabel.text=mediaName;
    [cellLabel setFrame:CGRectMake(75, 5, cell.frame.size.width-80,50)];
    [cell addSubview:cellLabel];
    [self setNeedsStatusBarAppearanceUpdate];
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"X@2x.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(cell.frame.size.width+140, 10, 40, 40)];
    [button addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    NSArray *subviews = [cell.contentView subviews];
    
    for(id view in subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            [view setTag:[indexPath row]];
            [cell.contentView bringSubviewToFront:view];
        }
    }
    [cell setTag:indexPath.row];
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *mediainfo=[_AttList objectAtIndex:indexPath.row];
    NSString *mediapath=mediainfo[0];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    if([[[NSString stringWithFormat:@"%@%@",paths[0],mediapath] pathExtension] isEqualToString:@"png"]==YES)
    {
        UIImage *image=[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",paths[0],mediapath]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
         _imgVC= [storyboard instantiateViewControllerWithIdentifier:@"ImageView"];
        _attachmentPOP = [[UIPopoverController alloc] initWithContentViewController:_imgVC];
        [_attachmentPOP presentPopoverFromRect:CGRectMake(117, 620, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        _attachmentPOP.delegate=self;
        [self.imgVC imageSource:image];
    }
    else
    {
        MPMoviePlayerViewController *moviePlayer =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",paths[0],mediapath]]];
        moviePlayer.moviePlayer.shouldAutoplay=NO;
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
    }
}

-(void)del:(UIButton *)button
{
    NSArray *visiblecells = [self.AttachmentTableView visibleCells];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    for(UITableViewCell *cell in visiblecells)
    {
        NSLog(@"tag==%ld",(long)cell.tag);
        NSLog(@"button tag==%ld",(long)button.tag);
        if(cell.tag == button.tag)
        {
            NSArray *mediaInfo=[_AttList objectAtIndex:[cell tag]];
            NSString *mediaPath=[mediaInfo objectAtIndex:0];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",paths[0],mediaPath] isDirectory:NO]==YES);
            {
                [fileManager removeItemAtPath:mediaPath error:nil];
            }
            [_AttList removeObjectAtIndex:[cell tag]];
            break;
        }
    }
    [_AttachmentTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //先行删除阵列中的物件
        NSArray *mediaInfo=[_AttList objectAtIndex:indexPath.row];
        NSString *mediaPath=[mediaInfo objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",paths[0],mediaPath] isDirectory:NO]==YES);
        {
            if([_isUpdata isEqualToString:@"updata"]==YES)
            {
                
            }
            else
            {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@",paths[0],mediaPath] error:nil];
            }
        }
        
         [self.AttList removeObjectAtIndex:indexPath.row];

        //删除 UITableView 中的物件，并设定动画模式
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (IBAction)CannelController:(id)sender
{
    //Notify the delegate that user tried to dismiss the view controller
    if ([self.delegate respondsToSelector:@selector(EditControllerWasDismissed:)])
    {
        [self.delegate EditControllerWasDismissed:self];
    }
}

//删除功能
- (IBAction)addAttachment:(UIBarButtonItem *)sender
{
    if(_graphicID!=nil)
    {
        if ([self.delegate respondsToSelector:@selector(delgraphic::)])
        {
            [self.delegate delgraphic:self :_graphicID];
        }
    }
}

-(void)SelectAttachmentController:(SelectAttachment*) SelectAttachment didSelect:(NSString*) sourceType;
{
    NSString *st=sourceType;
    [_attachmentPOP dismissPopoverAnimated:true];

    if([st isEqualToString:@"从相机选择"]==YES)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        _getPhote = [[UIImagePickerController alloc] init];
        _getPhote.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _getPhote.delegate = self;
        _getPhote.allowsEditing = NO;//是否允许编辑
        _getPhote.sourceType = sourceType;
        
        [self presentViewController:_getPhote animated:true completion:nil];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden: YES];
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _getPhote = [[NonRotatingUIImagePickerController alloc] init];
        _getPhote.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        _getPhote.delegate = self;
         _getPhote.allowsEditing = NO;//是否允许编辑
        _getPhote.sourceType = sourceType;
        //[self seth]
        _attachmentPOP = [[UIPopoverController alloc] initWithContentViewController:_getPhote];
        [_attachmentPOP presentPopoverFromRect:CGRectMake(117, 580, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        _attachmentPOP.delegate=self;

    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    [self setNeedsStatusBarAppearanceUpdate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *isPath=[NSString stringWithFormat:@"%@/data/Attachment/%@",paths[0],delegate.currentMapName];
    BOOL existed = [fileManager fileExistsAtPath:isPath];
    
    //判断存在图集属性文件夹
    if(existed==NO)
    {
        //创建该文件夹
        [fileManager createDirectoryAtPath:isPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //系统时间作为文件名称
    NSString* mediaName;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    mediaName = [formatter stringFromDate:[NSDate date]];
    NSString *medialistName;
    UIImage *mediaImg;
    NSString *mediaPath;
    
    //图片处理
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        NSString *uniquePath=[NSString stringWithFormat:@"/data/Attachment/%@/%@.png",delegate.currentMapName,mediaName];
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [UIImagePNGRepresentation(image)writeToFile: [NSString stringWithFormat:@"%@%@",paths[0],uniquePath]  atomically:YES];
        medialistName=[NSString stringWithFormat:@"%@.png",mediaName];
        mediaImg=[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",paths[0],uniquePath]];
        mediaPath=uniquePath;
    }
    //视频处理
    else if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie])
    {
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        mediaPath=[NSString stringWithFormat:@"/data/Attachment/%@/%@.MOV",delegate.currentMapName,mediaName];
        NSData *mediaData = [NSData dataWithContentsOfURL:mediaURL];
        [mediaData writeToFile:[NSString stringWithFormat:@"%@%@",paths[0],mediaPath] atomically:YES];
        medialistName=[NSString stringWithFormat:@"%@.mov",mediaName];
        mediaImg=[self getImage:[NSString stringWithFormat:@"%@%@",paths[0],mediaPath]];
    }
    
    //文件信息存入附件列表
    NSArray *mediaInfo;
    //文件路径

    //缩略图
    
    mediaInfo=[[NSArray alloc] initWithObjects:mediaPath,mediaImg,medialistName,nil];
    [_AttList addObject:mediaInfo];
    [self.AttachmentTableView reloadData];
    [_getPhote dismissViewControllerAnimated:true completion:nil];
    [_attachmentPOP dismissPopoverAnimated:true];
    [self setNeedsStatusBarAppearanceUpdate];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

}
*/

//获取视频缩略图
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

//判断文件夹是否存在
-(BOOL)isDirExist:(NSString *)dirName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *isPath=[NSString stringWithFormat:@"%@/data/Attachment/%@",paths[0],dirName];
    BOOL existed = [fileManager fileExistsAtPath:isPath];
    //NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"/data/Attachment/bgimage.png"];
    return existed;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_getPhote dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)FinishEdit:(id)sender
{
    NSString *description=_descriptionText.text;
    NSMutableArray *attachment=_AttList;
    
    if ([self.delegate respondsToSelector:@selector(EditControllerReturnEditorMessage::::)])
    {
        [self.delegate EditControllerReturnEditorMessage:self :description :attachment :_isUpdata];
    }
}

- (void) allowEditor
{
    self.descriptMessage=@"";
    self.AttList=[[NSMutableArray alloc] init];
}

- (IBAction)addAttachmentbutton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    SelectAttachment *ddd = [storyboard instantiateViewControllerWithIdentifier:@"addAttachment"];
    _attachmentPOP= [[UIPopoverController alloc] initWithContentViewController:ddd ];
    _attachmentPOP.popoverContentSize = CGSizeMake(200 , 88);
    [_attachmentPOP presentPopoverFromRect:self.addattbutton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    _attachmentPOP.delegate=self;
    ddd.delegate=self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

@end
