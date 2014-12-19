//
//  StaticUtils.h
//  StockManager
//
//  Created by apple_02 on 14/12/16.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticUtils : NSObject
+(void) standardUserDefaultsSetValue:(id)value forKey:(NSString *)key;
+(id) standardUserDefaultsGetValueforKey:(NSString *)key;

@end
