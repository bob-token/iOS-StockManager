//
//  ConfigViewController.h
//  StockManager
//
//  Created by apple_02 on 14/12/12.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CODE_TAG @"code"
#define PRICE_TAG @"price"
#define VOLUME_TAG @"volume"
#define PERCENT_OF_STOPLOSS_TAG @"percentOfStopLoss"
#define PERCENT_OF_PROFITONLY_TAG @"percentOfProfitOlny"

@interface ConfigViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *lb_price;
@property (strong, nonatomic) IBOutlet UITextField *lb_volume;
@property (strong, nonatomic) IBOutlet UITextField *lb_cost;
@property (strong, nonatomic) IBOutlet UITextField *lb_percentOfStopLoss;
@property (strong, nonatomic) IBOutlet UITextField *percentOfprofitOnly;
@property (strong, nonatomic) IBOutlet UINavigationBar *nb_topbar;
@property (strong, nonatomic) IBOutlet UINavigationItem *barTitle;
- (IBAction)back:(id)sender;
+(NSDictionary*)getCodeConfigInfo:(NSString*)code;
@end
