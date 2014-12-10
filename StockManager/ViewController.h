//
//  ViewController.h
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)btAdd:(id)sender;
- (IBAction)btStart:(id)sender;
- (IBAction)btStop:(id)sender;


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
@property (nonatomic, assign)int volume;
@property (nonatomic, assign)int value;
@property (nonatomic, assign)int buyOneVolume;
@property (nonatomic, assign)int buyTwoVolume;
@property (nonatomic, assign)int buyThirdVolume;
@property (nonatomic, assign)int buyFourVolume;
@property (nonatomic, assign)int buyFiveVolue;
@property (nonatomic, assign)int sellOneVolume;
@property (nonatomic, assign)int sellTwoVolume;
@property (nonatomic, assign)int sellThirdVolume;
@property (nonatomic, assign)int sellFourVolume;
@property (nonatomic, assign)int sellFiveVolue;
@property (nonatomic, strong)NSString* date;
@property (nonatomic, strong)NSString* time;

-(float)getPercent;
-(BOOL)isValide;
@end