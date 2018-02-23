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

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
@class AGSEnvelope;
@class AddBookmarkViewController;
@protocol AddBookmarkDelegate <NSObject>
-(void)AddBookmarkDone:(AddBookmarkViewController *) addBookmarkViewController withName:(NSString*)bookmarkName;
-(void)AddBookmarkCancel:(AddBookmarkViewController *) addBookmarkViewController ;
@end

@interface AddBookmarkViewController : UIViewController {
	UITableView *_tableView;
	AGSMutableEnvelope *_extent;
	id<AddBookmarkDelegate> __weak _delegate;
	UITextField* _nameTextFiled;
    NSUInteger _wkid;
    
}
-(IBAction) done:(id)sender;
-(IBAction) cancel:(id)sender;
-(void)updateSpatialCell:(double)xmin ymin:(double)ymin xmax:(double)xmax ymax:(double)ymax;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AGSMutableEnvelope *extent;
@property (nonatomic, weak) id<AddBookmarkDelegate>  delegate;
@property (nonatomic, assign) NSUInteger wkid;
@end
