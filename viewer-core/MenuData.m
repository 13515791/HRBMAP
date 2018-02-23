//
//  MenuData.m
//  AGSPadViewer
//
//  Created by zhang baocai on 13-5-29.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "MenuData.h"

@implementation MenuData
@synthesize iconName = _iconName;
@synthesize details = _details;
-(id) initWithIconName:(NSString*)iconName details:(NSString*)details
{
    if (self = [super init]) {
        _iconName = iconName;
        _details = details;
    }
    return self;
}
@end
