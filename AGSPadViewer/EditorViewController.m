//
//  EditorViewController.m
//  AGSPadViewer
//
//  Created by LiangChao on 14-9-10.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import "EditorViewController.h"

@implementation EditorViewController
@synthesize editorViewController= _editorViewController;
@synthesize delegate=_delegate;
@synthesize infos = _infos;

@synthesize featureType = _featureType;
@synthesize featureTemplate = _featureTemplate;
@synthesize featureLayer = _featureLayer;
@synthesize featureTemplatesTableView = _featureTemplatesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) addTemplatesForLayersInMap:(AGSMapView*)mapView
{
    for (AGSLayer* layer in mapView.mapLayers)
    {
        if([layer isKindOfClass:[AGSFeatureLayer class]])
        {
            [self addTemplatesFromSource:(id<AGSGDBFeatureSourceInfo>)layer renderer:((AGSFeatureLayer*)layer).renderer];
        }
        else if ([layer isKindOfClass:[AGSFeatureTableLayer class]])
        {
            [self addTemplatesFromSource:(AGSGDBFeatureTable*)((AGSFeatureTableLayer*)layer).table renderer:((AGSFeatureTableLayer*)layer).renderer ];
        }
    }
}

- (void) addTemplatesFromSource:(id<AGSGDBFeatureSourceInfo>)source renderer:(AGSRenderer *)renderer {
    
    //Instantiate the array to hold all templates from this layer
    if(!self.infos)
        self.infos = [[NSMutableArray alloc] init];
    
    if(source.types!=nil && source.types.count){
        //For each type
        for (AGSFeatureType* type in source.types) {
            //For each template in type
            for (AGSFeatureTemplate* template in type.templates) {
                
                FeatureTemplatePickerInfo* info =
                [[FeatureTemplatePickerInfo alloc] init];
                info.source = source;
                info.renderer = renderer;
                info.featureTemplate = template;
                info.featureType = type;
                
                //Add to  array
                [self.infos addObject:info];
                
            }
        }
    }
    //If layer contains only templates (no feature types)
    else if (source.templates!=nil) {
        //For each template
        for (AGSFeatureTemplate* template in source.templates) {
            
            FeatureTemplatePickerInfo* info =
            [[FeatureTemplatePickerInfo alloc] init];
            info.source = source;
            info.renderer = renderer;
            info.featureTemplate = template;
            info.featureType = nil;
            
            //Add to array
            [self.infos addObject:info];
        }
        // if layer contains feature types
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Templates";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.infos count];
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
    
    //Set its label, image, etc for the template
    EditorViewController* info = [self.infos objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:12.0];
	cell.textLabel.text = info.featureTemplate.name;
    cell.imageView.image =[ info.renderer swatchForFeatureWithAttributes:info.featureTemplate.prototypeAttributes geometryType:info.source.geometryType size:CGSizeMake(20, 20)];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(editorViewController:didSelectFeatureTemplate:forLayer:)])
    {
        FeatureTemplatePickerInfo* info = [self.infos objectAtIndex:indexPath.row];
        //[self.delegate ]
        [self.delegate editorViewController:self.editorViewController didSelectFeatureTemplate:info.featureTemplate forLayer:info.source];
    }
    
    //Unselect the cell
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

- (IBAction)dismiss:(id)sender
{
    //Notify the delegate that user tried to dismiss the view controller
	if ([self.delegate respondsToSelector:@selector(editorViewControllerWasDismissed:)])
    {
		[self.delegate editorViewControllerWasDismissed:self];
	}
}
@end
