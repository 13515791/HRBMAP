//
//  POI.h
//  AGSPadViewer
//
//  Created by Yajun Ma on 14-9-26.
//  Copyright (c) 2014年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POI : NSObject
@property(nonatomic)int index;
@property(nonatomic,strong)NSString* Name;
@property(nonatomic)double X;
@property(nonatomic)double Y;

@end
