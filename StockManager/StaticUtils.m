//
//  StaticUtils.m
//  StockManager
//
//  Created by apple_02 on 14/12/16.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "StaticUtils.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

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
#pragma mark 移除本地通知，在不需要此通知时记得移除
+(void)removeAllLocalNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
#pragma mark 添加本地通知
+(void)showLocalNotification:(NSTimeInterval)timeInterval info:(NSString*)info{
    
    if (info) {
        //定义本地通知对象
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:timeInterval];//通知触发的时间，单位（秒）
        notification.repeatInterval=2;//通知重复次数
        //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        
        //设置通知属性
        notification.alertBody=info; //通知主体
        notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

+(void)viber
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
+(BOOL)isLaunchedInBackground
{
    UIApplication *application = [UIApplication sharedApplication];
    return UIApplicationStateBackground == application.applicationState;
}
+(void)NotifyUser:(NSString*)info
{
    if ([StaticUtils isLaunchedInBackground]) {
        [StaticUtils showLocalNotification:0 info:info];
    }else{
        [StaticUtils viber];
    }
}
+(UIView *)getFirstResponder:(UIView*)parent
{
    UIView *firstResponder = nil;
    firstResponder = parent;
    for (UIView *view in parent.subviews) //: caused error
    {
        if (view.isFirstResponder)
        {
            firstResponder = view;
            break;
        }
    }
    return firstResponder;
}
@end
