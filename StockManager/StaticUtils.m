//
//  StaticUtils.m
//  StockManager
//
//  Created by apple_02 on 14/12/16.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "StaticUtils.h"

@implementation StaticUtils
/**
 *  @author bob, 14-12-08 15:12:48
 *
 *  向standardUserDefaults中设置值
 *  注意:不能保存值或key为nil的键值对
 *
 *  @param value 被设置的值
 *  @param key   相关联的key
 *
 */

+(void) standardUserDefaultsSetValue:(id)value forKey:(NSString *)key
{
    if (value != nil && key != nil) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        [ud setObject:value forKey:key];
        
        [ud synchronize];
    }
}
/**
 *  @author bob, 14-12-08 15:12:00
 *
 *  从standardUserDefaults中获取值
 *
 *  @param key 相关联的Key
 *
 *  @return 返回key 的值 或 nil
 */
+(id) standardUserDefaultsGetValueforKey:(NSString *)key
{
    if ( key != nil ) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        return [ud valueForKey:key];
    }
    
    return nil;
}
+(NSString*)removeCharacter:(NSString*)org withInString:(NSString*)string
{
    NSString* str = [org copy];
    if (string && org) {
        for (NSInteger i = 0; i < string.length; i++) {
            char a = [string characterAtIndex:i];
            NSString *s =[NSString stringWithFormat:@"%c",a];
            str = [str stringByReplacingOccurrencesOfString:s withString:@""];
        }
    }
    return str;
}

+(id)getTime:(NSInteger)flag
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSString* format = @"YYYY-MM-dd hh:mm:ss";
    [formatter setDateFormat:format];
    date = [formatter stringFromDate:[NSDate date]];
    switch (flag) {
        case TIME_FORMAT_YYYY_MM_dd_SPACE_hh_mm_ss:
            break;
        case TIME_FORMAT_YYYYMMddhhmmss:
        {
            date = [StaticUtils removeCharacter:date withInString:@":- "];
        }break;
        default:
            break;
    }
    return date;
}

@end
