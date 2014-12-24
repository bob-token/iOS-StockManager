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
#define TIME_TAG @"time"
#define MAX_VAULE_RATE_VOLUME_INCREASE_TAG @"max_valueRateVolume_increase"
#define MIN_VAULE_RATE_VOLUME_INCREASE_TAG @"min_valueRateVolume_increase"

@interface ConfigViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *lb_time;
@property (strong, nonatomic) IBOutlet UITextField *lb_price;
@property (strong, nonatomic) IBOutlet UITextField *lb_volume;
@property (strong, nonatomic) IBOutlet UITextField *lb_cost;
@property (strong, nonatomic) IBOutlet UITextField *lb_percentOfStopLoss;
@property (strong, nonatomic) IBOutlet UITextField *percentOfprofitOnly;
@property (strong, nonatomic) IBOutlet UITextField *priceOfLoss;
@property (strong, nonatomic) IBOutlet UITextField *priceOfProfit;
@property (strong, nonatomic) IBOutlet UINavigationBar *nb_topbar;
@property (strong, nonatomic) IBOutlet UITextField *lb_vaRateVm_max;
@property (strong, nonatomic) IBOutlet UITextField *lb_vaRateVm_min;
@property (strong, nonatomic) IBOutlet UINavigationItem *barTitle;
- (IBAction)back:(id)sender;
- (IBAction)priceEditingEnd:(id)sender;
- (IBAction)volumeEditingEnd:(id)sender;
- (IBAction)stopLossRateEditingEnd:(id)sender;
- (IBAction)profitOnlyRateEditingEnd:(id)sender;
- (IBAction)StopLostPriceEditingEnd:(id)sender;
- (IBAction)profitOnlyPriceEditingEnd:(id)sender;
+(NSDictionary*)getCodeConfigInfo:(NSString*)code;
@end
