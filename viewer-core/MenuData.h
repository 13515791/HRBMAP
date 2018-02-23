//
//  MenuData.h
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuData : NSObject
@property(nonatomic,strong)NSString * iconName;
@property(nonatomic,strong)NSString * details;
-(id) initWithIconName:(NSString*)iconName details:(NSString*)details;
@end
