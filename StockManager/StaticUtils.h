//
//  StaticUtils.h
//  StockManager
//
//  Created by apple_02 on 14/12/16.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define    TIME_FORMAT_YYYY_MM_dd_SPACE_hh_mm_ss 0
#define    TIME_FORMAT_YYYYMMddhhmmss 1
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define OS_VERSION_FLOAT_VAL [[[UIDevice currentDevice] systemVersion] floatValue]

@interface StaticUtils : NSObject
+(void) standardUserDefaultsSetValue:(id)value forKey:(NSString *)key;
+(id) standardUserDefaultsGetValueforKey:(NSString *)key;
+(id)getTime:(NSInteger)flag;
+(void)removeAllLocalNotification;
+(void)showLocalNotification:(NSTimeInterval)timeInterval info:(NSString*)info;
+(void)viber;
+(BOOL)isLaunchedInBackground;
+(void)NotifyUser:(NSString*)info;
+(UIView *)getFirstResponder:(UIView*)parent;
@end
