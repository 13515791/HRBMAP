//
//  Common.m
//  CUC2013
//
//  Created by  on 12-6-25.
//  Copyright (c) 2013年 esrichina. All rights reserved.
//

#import "Common.h"

@implementation Common

+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+(unsigned long long) getFileSize:(NSString*) fileName{
    //获取APP的Document目录   
    NSFileManager* fileManager =[NSFileManager defaultManager];
    NSError* error;
    NSDictionary* dict=  [fileManager attributesOfItemAtPath:[self getPath:fileName] error:&error];  
    return [dict fileSize];
}

+ (NSString *)getPath:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:dbName];
}
+(NSString*)getDateStr:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; 
    [formatter setTimeZone:timeZone];                 
    NSDate *dateNow = [NSDate date]; 
    [formatter setDateFormat :format];// @"yyyy-M-d H:m"
    NSString* dateStr =[formatter stringFromDate:dateNow];
    return  dateStr;
}
+(NSString*)getDateStr:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; 
    [formatter setTimeZone:timeZone];                  
    [formatter setDateFormat :format];// @"yyyy-M-d H:m"
    NSString* dateStr =[formatter stringFromDate:date];
    return  dateStr;
}
+(NSString*)getDateStr:(NSString *)dateString inputFormat:(NSString *)informat outputFormat:(NSString *)outformat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; 
    [formatter setTimeZone:timeZone];                  
    [formatter setDateFormat :informat];// @"yyyy-M-d H:m"
    NSDate *date = [NSDate date];
    date = [formatter dateFromString:dateString];
    [formatter setDateFormat :outformat];// @"yyyy年M月d日 H小时m分"
    NSString* dateStr =[formatter stringFromDate:date];
    return  dateStr;
}
+(NSDate *)getDate:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; 
    [formatter setTimeZone:timeZone];                  
    [formatter setDateFormat :format];// @"yyyy-M-d H:m"
    NSDate *date = [NSDate date];
    date = [formatter dateFromString:dateString];
    return date;
}



// return a new autoreleased UUID string
+ (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}
#pragma -
#pragma UIColor Maker
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length

{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}

+ (UIColor *) colorWithHexString: (NSString *) hexString

{
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red = [self colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            
            blue = [self colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            
            red = [self colorComponentFrom: colorString start: 1 length: 1];
            
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            
            blue = [self colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red = [self colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            
            blue = [self colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case8: // #AARRGGBB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            
            red = [self colorComponentFrom: colorString start: 2 length: 2];
            
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            
            blue = [self colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            [NSException raise:@"Invalid color value"format: @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}
//搜索框里面在添加的时候会有UIsearchtextfield ，这里面必须把这个设置去掉，才不会出现阴影kuang
- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
