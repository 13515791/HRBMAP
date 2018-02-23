//
//  SearchResultViewController.h
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-23.
//  Copyright (c) 2014年 Esri. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum {TableType_HistoryRecord,TableType_SearchResult} TableType;

@protocol SearchResultPickerDelegate <NSObject>
@optional
-(void)searchResultPickerIndex:(NSInteger)index forTableType:(NSInteger)TableType;

@end

@interface SearchResultViewController : UIViewController{
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *searchResult;
@property(nonatomic,weak)id<SearchResultPickerDelegate> delegate;
@end
