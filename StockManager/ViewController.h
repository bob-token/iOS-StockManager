//
//  ViewController.h
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@interface ViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *bt_monitor;
@property (nonatomic, assign) BOOL bStarting;

- (IBAction)btAdd:(id)sender;
- (IBAction)btStart:(id)sender;
- (void)backgroundFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@property (nonatomic, retain)NSMutableArray* datasource;
@property (nonatomic, retain)NSMutableArray* codeArray;
@property (nonatomic,retain)NSTimer* updateTimer;

@end

@interface MYAlertView : UIAlertView
@property (strong, nonatomic) id userData;
@property (nonatomic, assign)NSInteger typeId;

@end

@interface StockInfo : NSObject

@property (nonatomic,strong)NSString* code;
@property (nonatomic,strong)NSString* name;
@property (nonatomic, assign)float openPrice;
@property (nonatomic, assign)float closePrice;
@property (nonatomic, assign)float nowPrice;
@property (nonatomic, assign)float maxPrice;
@property (nonatomic, assign)float minPrice;
@property (nonatomic, assign)float oneBuyPrice;
@property (nonatomic, assign)float oneSellPrice;
@property (nonatomic, assign)NSInteger volume;
@property (nonatomic, assign)NSInteger value;
@property (nonatomic, assign)NSInteger buyOneVolume;
@property (nonatomic, assign)NSInteger buyTwoVolume;
@property (nonatomic, assign)NSInteger buyThirdVolume;
@property (nonatomic, assign)NSInteger buyFourVolume;
@property (nonatomic, assign)NSInteger buyFiveVolume;
@property (nonatomic, assign)NSInteger sellOneVolume;
@property (nonatomic, assign)NSInteger sellTwoVolume;
@property (nonatomic, assign)NSInteger sellThirdVolume;
@property (nonatomic, assign)NSInteger sellFourVolume;
@property (nonatomic, assign)NSInteger sellFiveVolume;
@property (nonatomic, strong)NSString* date;
@property (nonatomic, strong)NSString* time;
-(id)initWithCode:(NSString*)code;
-(float)getPercent;
-(BOOL)isValide;
@end

@interface StockInfoHelper : NSObject
@property (nonatomic, strong)StockInfo* stock;
@property (nonatomic,assign)NSInteger lastVolume;
@property (nonatomic,assign)float volumeAverage; //量的增量平均值
@property (nonatomic,assign)float volumeLastIncreaseRate; //量的最后增量比
@property (nonatomic,assign)NSInteger lastValue;
@property (nonatomic,assign)float valueAverage;//额的增量平均值
@property (nonatomic,assign)float valueLastIncreaseRate;//额的最后增量比

+(BOOL)isSHStock:(NSString*)code;
+ (BOOL)codeIsValid:(NSString*)code;
-(id)initWithCode:(NSString*)code;
-(id)initWithStockInfo:(StockInfo*)stock;
-(void)calcVolumeAverageRate;
-(void)calcValueAverageRate;
-(NSString*)constructCodeDisplayInfo;
@end