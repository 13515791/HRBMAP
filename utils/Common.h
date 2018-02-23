//
//  Common.h
//  CUC2013
//
//  Created by  on 12-6-25.
//  Copyright (c) 2013年 esrichina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

@interface Common : NSObject
{}

+ (BOOL) connectedToNetwork;
+ (NSString *)getPath:(NSString *)dbName;
+ (unsigned long long) getFileSize:(NSString*) fileName;
+ (NSString *)generateUuidString;
+ (NSString*)getDateStr:(NSString *)format;
+ (NSString*)getDateStr:(NSDate *)date format:(NSString *)format;
+ (NSString*)getDateStr:(NSString *)dateString inputFormat:(NSString *)informat outputFormat:(NSString *)outformat;
+ (NSDate *)getDate:(NSString *)dateString format:(NSString *)format;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+ (UIColor *) colorWithHexString: (NSString *) hexString;
@end
