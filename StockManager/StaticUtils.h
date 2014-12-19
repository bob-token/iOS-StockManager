//
//  StaticUtils.h
//  StockManager
//
//  Created by apple_02 on 14/12/16.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    TIME_FORMAT_YYYY_MM_dd_SPACE_hh_mm_ss 0
#define    TIME_FORMAT_YYYYMMddhhmmss 1


@interface StaticUtils : NSObject
+(void) standardUserDefaultsSetValue:(id)value forKey:(NSString *)key;
+(id) standardUserDefaultsGetValueforKey:(NSString *)key;
+(id)getTime:(NSInteger)flag;
@end
