//
//  BookmarkToolViewController.h
//  EsriPadViewer
//
//  Created by zhang baocai on 13-5-30.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookmarkToolViewController;
@protocol BookmarkToolDelegate <NSObject>
-(void)bookmarkToolAdd:(BookmarkToolViewController *) bookmarkToolViewController ;
-(void)bookmarkToolEdit:(BookmarkToolViewController *) bookmarkToolViewController ;
@end
@interface BookmarkToolViewController : UIViewController
{
    id<BookmarkToolDelegate> __weak delegate;
}
@property(nonatomic,weak)id<BookmarkToolDelegate>  delegate;
@end
