//
//  SelectAttachment.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "SelectAttachment.h"

@interface SelectAttachment ()

@end

@implementation SelectAttachment
@synthesize ConntentList=_ConntentList;
@synthesize delegate=_delegate;
@synthesize SelectAttController=_SelectAttController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   _ConntentList=[[NSArray alloc] initWithObjects:@"从相机选择",@"从相册选择", nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ConntentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.text=[_ConntentList objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(SelectAttachmentController:didSelect:)])
    {
        [_delegate SelectAttachmentController:_SelectAttController didSelect:[_ConntentList objectAtIndex:indexPath.row]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES; 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
