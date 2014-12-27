//
//  ViewController.m
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "TableViewCell.h"
#import "ConfigViewController.h"
#import "StaticUtils.h"


#define ALERT_ID_DELETE 1
#define ALERT_ID_ADD    2

#define BOBLOG NSLog

#define CODES_SAVE_KEY @"codes"

#define TABLEVIEW_CELL_REUSE_ID @"TableViewCell"

@interface ViewController ()

@end

@implementation MYAlertView
- (void) dealloc
{
    self.userData = nil;
}

@end

@implementation StockInfo

-(id)initWithCode:(NSString*)code
{
    if(self = [super init]){
        self.code = code;
        return self;
    }
    return nil;
}

-(float)getPercent
{
    if ([self isValide]) {
        return (self.nowPrice - self.closePrice)*100/self.closePrice;
    }
    return 0;
}
-(float)getCurDealCostRate
{
    if ([self isValide]) {
        return _nowPrice*_volume/_value;
    }
    return 0;
}

-(BOOL)isValide
{
    if (self.nowPrice > 0) {
        return YES;
    }
    return NO;
}

@end

@implementation StockInfoHelper
-(id)initWithCode:(NSString *)code
{
    if (self = [self init]) {
        StockInfo * f = [[StockInfo alloc] initWithCode:code];
        if (f) {
            self.stock = f;
            return self;
        }
    }
    return nil;
}
-(id)initWithStockInfo:(StockInfo*)stock
{
    if (self = [self init]) {
        self.stock = stock;
        return self;
    }
    return nil;
}
+(NSString*)buildCode:(NSString*)codeid{
    
    if(codeid != nil){
        codeid=[ codeid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if(codeid.length > 5){
            char first = [codeid characterAtIndex:0];
            
            NSString* prefix=nil;
            
            switch(first){
                case '6':
                    prefix=@"sh";
                    break;
                case '3':
                case '0':
                    prefix=@"sz";
                    break;
                default:
                    BOBLOG(@"BuildCodeError:invalid code !");
            }
            return [prefix stringByAppendingString:codeid];
        }
    }
    return nil;
}
+ (BOOL)codeIsValid:(NSString*)code
{
    if (code == nil) return NO;
    if (code.length != 6) return NO;
    
    return YES;
}
+(BOOL)isSHStock:(NSString*)code
{
    if ([StockInfoHelper codeIsValid:code]) {
        NSString* buildcode = [StockInfoHelper buildCode:code];
        
        if([buildcode characterAtIndex:1] == 'h')
            return YES;
    }
    return NO;
}

-(BOOL) isBought
{
    if ([_stock isValide]  ) {
        NSDictionary* dic = [ConfigViewController getCodeConfigInfo:_stock.code];
        float buyPrice = [[dic valueForKey:PRICE_TAG] floatValue];
        NSInteger total = [[dic valueForKey:VOLUME_TAG] integerValue];
        if (buyPrice > 0 && total > 0) {
            return YES;
        }
    }
    return NO;
}

-(float) getCost
{
    float buyPrice = [[self getBoughtDetail:PRICE_TAG] floatValue];
    NSInteger total = [[self getBoughtDetail:VOLUME_TAG] integerValue];
    return buyPrice*total;
}
-(id)getBoughtDetail:(NSString*)detailTag
{
    NSDictionary* dic = [ConfigViewController getCodeConfigInfo:_stock.code];
    if (dic && detailTag) {
        return [dic valueForKey:detailTag];
    }
    return nil;
}
-(id)getBoughtDetail:(NSString*)detailTag default:(id)value
{
    return [ConfigViewController getCodeConfigDetail:_stock.code detailTag:detailTag default:value];
}


/**
 *  @author bob, 14-12-19 12:12:30
 *
 *  计算额的增量平均值除以量的增量平均值
 *
 *  @return 计算结果或0
 */
-(float)getAverageVaRateVm
{
    if (_volumeAverage && _valueAverage) {
        return _valueAverage/_volumeAverage;
    }
    return 1;
}
-(float)getLastVaRateVm
{
    if (_valueLastIncreaseRate && _volumeLastIncreaseRate) {
        return _valueLastIncreaseRate/_volumeLastIncreaseRate;
    }
    return 1;
}

-(float) CalcCurIncomeRate
{
    float curIncome = [self CalcCurIncome];
    float cost = [self getCost];
    if (curIncome != 0 && cost != 0) {
        return curIncome/cost;
    }
    return 0;
}
-(BOOL)isMonitoring
{
    return [ConfigViewController codeIsMonitoring:_stock.code];
}
-(float) CalcCurIncome
{
    if ([_stock isValide] && [self isMonitoring]) {
        float curPrice = _stock.nowPrice;
        float buyPrice = [[self getBoughtDetail:PRICE_TAG] floatValue];
        NSInteger total = [[self getBoughtDetail:VOLUME_TAG] integerValue];
        return [StockInfoHelper CalcIncome:_stock.code buyprice:buyPrice sellprice:curPrice total:total];
    }

    return 0;
}
+(float) CalcIncome:(NSString*) code buyprice:(float) buyprice sellprice:(float)sellprice total:(NSInteger) total
{
    float yinhuatax=(float) 0.001;
    float servicechange=(float) 0.002;
    if(code !=nil){
        float income=(sellprice-buyprice)*total-(yinhuatax+servicechange)*sellprice;
        if([StockInfoHelper isSHStock:code]){
            income=income-1;
        }
        return income;
    }
    return 0;
}
-(NSString*)constructCodeDisplayInfo
{

    if (_stock && [_stock isValide]) {
        float tpercent = [_stock getPercent];
        float tnowPrice = _stock.nowPrice;
        float tmax = _stock.maxPrice;
        float tmin = _stock.minPrice;
        NSInteger tKVolume = _stock.volume/1000;
        return [NSString stringWithFormat:@"%.2f(%.2f) %.2f(x) %.2f(n) %ld(K)",tnowPrice,tpercent,tmax,tmin,(long)tKVolume];
    }
    if (_stock) {
        return @"...";
    }
    
    return nil;
}
-(void)calcVolumeAverageRate
{
    if (_stock && [_stock isValide]) {
        if (_stock.volume != 0 && _lastVolume != 0) {
            if (_stock.volume != _lastVolume) {
                float tmp = (float)_stock.volume/_lastVolume -1;
                _volumeLastIncreaseRate = tmp;
                _volumeAverage = (tmp+_volumeAverage)/2 ;
            }
        }
        self.lastVolume = _stock.volume;
    }
}
-(void)calcValueAverageRate
{
    if (_stock && [_stock isValide]) {
        if (_stock.value!= 0 && _lastValue!= 0) {
            if (_stock.value!= _lastValue) {
                float tmp = (float)_stock.value/_lastValue -1;
                _valueLastIncreaseRate = tmp;
                _valueAverage = (tmp+_valueAverage)/2;
            }
        }
        self.lastValue = _stock.value;
    }
}

@end
@implementation ViewController

- (void)dealloc
{
    self.datasource = nil;
    self.codeArray = nil;
}

-(void)loadCodes
{
    NSArray* array = [StaticUtils standardUserDefaultsGetValueforKey:CODES_SAVE_KEY];
    if (array == nil || array.count ==0) {
        return;
    }
    
    self.codeArray = [NSMutableArray arrayWithArray:array];
    if (_codeArray != nil && _codeArray.count > 0) {
        [_datasource removeAllObjects];
        for (NSString *code in _codeArray) {
            StockInfoHelper* fh =[[StockInfoHelper alloc] initWithCode:code];
            [_datasource addObject:fh];
        }
        [_tableview reloadData];
    }
}

-(void)saveCodes
{
    [ StaticUtils standardUserDefaultsSetValue:self.codeArray forKey:CODES_SAVE_KEY];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (!_bStarting) {
        [self refresh];
        [self btStart:self];
    }
}
- (void)updateAllIncome
{
    float total = 0;
    for (StockInfoHelper* fh in _datasource) {
        total += [fh CalcCurIncome];
    }
    self.bar.title = [NSString stringWithFormat:@"%.2f",total ];
}
#define status_bar_height 100
- (void)viewDidLoad {
    [super viewDidLoad];
//   [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_tableview registerClass:TableViewCell.class forCellReuseIdentifier:TABLEVIEW_CELL_REUSE_ID];
    // Do any additional setup after loading the view, typically from a nib.
    if (_datasource ==nil) {
        self.datasource = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    [self loadCodes];
    if (_codeArray == nil) {
        _codeArray = [[NSMutableArray alloc] initWithCapacity:3];
//        [_codeArray addObject:@"600000"];
    }
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableview addGestureRecognizer:longPressGr];
}
-(StockInfo*)parseResult:(NSString*)code result:(NSString*)result
{
    if (code != nil && result != nil && result.length > 50) {
        StockInfo* info = [[StockInfo alloc] init];
        NSInteger len = result.length;
        NSRange rg;
        rg.length = len-2 - 21;
        rg.location = 21;
        NSString * r = [result substringWithRange:rg];
        info.code = code;
        NSArray* inf = [r componentsSeparatedByString:@","];
        int index = 0;
//        info.Code = inf[index++];
        info.Name = inf[index++];
        info.OpenPrice = [inf[index++] floatValue];
        info.ClosePrice = [inf[index++] floatValue];
        info.NowPrice = [inf[index++] floatValue];
        info.MaxPrice = [inf[index++] floatValue];
        info.MinPrice = [inf[index++] floatValue];
        info.OneBuyPrice = [inf[index++] floatValue];
        info.OneSellPrice = [inf[index++] floatValue];
        info.Volume = [inf[index++] integerValue];
        info.value = [inf[index++] integerValue];
        info.buyOneVolume = [inf[index++] integerValue];
        info.buyTwoVolume = [inf[index++] integerValue];
        info.buyThirdVolume = [inf[index++] integerValue];
        info.buyFourVolume = [inf[index++] integerValue];
        info.buyFiveVolume = [inf[index++] integerValue];
        info.sellOneVolume = [inf[index++] integerValue];
        info.sellTwoVolume = [inf[index++] integerValue];
        info.sellThirdVolume = [inf[index++] integerValue];
        info.sellFourVolume = [inf[index++] integerValue];
        info.sellFiveVolume = [inf[index++] integerValue];
        info.date = inf[31];
        info.time = inf[32];
        return info;
    }
    return nil;
}

-(id)getObjInTableViewSourceBy:(NSString*)code
{
    NSInteger index = [self getCodeIndexInCodeArray:code];
    if (index != -1) {
        return _datasource[index];
    }
    return nil;
}
-(NSInteger)getCodeIndexInTabViewSource:(NSString*)code
{
    __block NSInteger index = -1;
    if (code != nil && _datasource!= nil && _datasource.count > 0) {
        [_datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            StockInfoHelper* e = obj;
            if([code isEqualToString:e.stock.code]){
                *stop = YES;
                index = idx;
            }
        }];
    }
    return  index;
}

-(NSInteger)getCodeIndexInCodeArray:(NSString*)code
{
    __block NSInteger index = -1;
    if (code != nil &&_codeArray!= nil &&_codeArray.count > 0) {
        [_codeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([code isEqualToString:obj]){
                *stop = YES;
                index = idx;
            }
        }];
    }
    return  index;
}

-(void)checkUserCondition:(StockInfoHelper*)fh
{
    if (fh && [fh.stock isValide] ) {
        
        fh.warnningType = 0;
        
        if (![fh isMonitoring]) {
            return;
        }
        float profit = [[fh getBoughtDetail:PERCENT_OF_PROFITONLY_TAG] floatValue];
        float loss = [[fh getBoughtDetail:PERCENT_OF_STOPLOSS_TAG] floatValue];
        float vaRateVm_max =[[fh getBoughtDetail:MAX_VAULE_RATE_VOLUME_INCREASE_TAG default:[NSNumber numberWithFloat: 1.030]] floatValue];
        float vaRateVm_min =[[fh getBoughtDetail:MIN_VAULE_RATE_VOLUME_INCREASE_TAG default:[NSNumber numberWithFloat: 0.990]] floatValue];
        float valuePerVol_min = vaRateVm_min;
        float valuePerVol_max = vaRateVm_max;
        BOOL notify = NO;
        
        if ([fh CalcCurIncomeRate] > profit || [fh CalcCurIncomeRate] < loss*-1) {
            notify = YES;
        }
        if([fh getAverageVaRateVm] > valuePerVol_max || [fh getAverageVaRateVm] < valuePerVol_min){
            notify = YES;
            fh.warnningType = 2;
        }
        if (notify) {
            NSString* info = fh.stock.name;
            [StaticUtils NotifyUser:[info stringByAppendingFormat:@" %.2f %.2f",[fh CalcCurIncomeRate]*100,[fh CalcCurIncome]]];
        }
        
        if ([fh CalcCurIncomeRate] > profit) {
            fh.warnningType = 1;
        }
        if ([fh CalcCurIncomeRate] < loss*-1) {
            fh.warnningType = -1;
        }
    }
}
-(void)parseCodeInfo:(NSString*)code info:(NSString*)info
{
    StockInfo* f = [self parseResult:code result:info];
    if (f != nil) {
        
        StockInfoHelper* fh =  [self getObjInTableViewSourceBy:code];
        
        if (fh == nil) {
            fh = [[StockInfoHelper alloc] initWithStockInfo:f];
            [_datasource addObject:fh];
        }
        fh.stock = f;
        
        [fh calcValueAverageRate];
        [fh calcVolumeAverageRate];
        [self checkUserCondition:fh];
        [self updateAllIncome];
        [_tableview reloadData];
    }
}


-(NSString*)getCodeInfoUrl:(NSString*) strCode
{
    if ([StockInfoHelper codeIsValid:strCode]) {
        NSString* code = [StockInfoHelper buildCode:strCode];
        NSString* baseurl = @"http://hq.sinajs.cn/?_=1314426110204&list=";
        NSString* url = [baseurl stringByAppendingString:code];
        return url;
    }
    return nil;
}
-(void)updateCodeInfo:(NSString*) strCode{
    if ([StockInfoHelper codeIsValid:strCode]) {
        NSString* url = [self getCodeInfoUrl:strCode];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000 );
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//        manager.responseSerializer.stringEncoding = enc;
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", [ [NSString alloc] initWithData:responseObject encoding:enc] );
            [self parseCodeInfo:strCode info:[ [NSString alloc] initWithData:responseObject encoding:enc]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];
        
    }
}

-(void)updateInfo
{
    for (NSString* code in self.codeArray) {
        [self updateCodeInfo:code];
    }
    BOBLOG(@"updateInfo");
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableview];
        NSIndexPath * indexPath = [self.tableview indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        //add your code here
        NSString* msg = @"确定删除";
        MYAlertView* alert = [[MYAlertView alloc] initWithTitle:@"警告" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
        alert.userData = [NSNumber numberWithInteger:indexPath.row];
        alert.typeId = ALERT_ID_DELETE;
        
        [alert show];
    }
}
-(BOOL)codeIsAdded:(NSString*)code
{
    if (code != nil) {
        return [self getCodeIndexInCodeArray:code] != -1;
    }
    return NO;
}
-(void)alert:(NSString*)title message:(NSString*)msg
{
    MYAlertView* alert = [[MYAlertView alloc] initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    MYAlertView* alert = (MYAlertView*)alertView;
    
    switch (alert.typeId) {
        case ALERT_ID_ADD:
        {
            if (buttonIndex == 1) {
                NSString* code = [alert textFieldAtIndex:0].text;
                if ([StockInfoHelper codeIsValid:code] ) {
                    if (![self codeIsAdded:code]) {
                        [_codeArray addObject:code];
                        [self saveCodes];
                        StockInfoHelper* fh = [[StockInfoHelper alloc] initWithCode:code];
                        [_datasource addObject:fh];
                        [_tableview reloadData];
                    }
//                    [self alert:nil message:@"添加成功"];
                }else{
                    [self alert:@"警告" message:@"输入不正确"];
                }
            }
        }break;
        case ALERT_ID_DELETE:
        {
            if (buttonIndex == 1) {
                
                NSInteger index = [alert.userData integerValue];
                
                if (index < _datasource.count) {
                    StockInfoHelper* fh = _datasource[index];
                    NSInteger codeIndex = [self getCodeIndexInCodeArray:fh.stock.code];
                    if (codeIndex != -1) {
                        [_codeArray removeObjectAtIndex:codeIndex];
                    }
                    [_datasource removeObjectAtIndex:index];
                    [_tableview reloadData];
                    [self saveCodes];
                }
            }
        }break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StockInfoHelper* o =  _datasource[indexPath.row];
    ConfigViewController* c = [[ConfigViewController alloc] initWithNibName:nil bundle:nil];
    [c.barTitle setTitle:o.stock.code];
    [self presentViewController:c animated:YES completion:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockInfoHelper* fh = (StockInfoHelper*)_datasource[indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL_REUSE_ID];

    cell.lb_code.text =@"";
    cell.name.text = @"";
    cell.lb_info.text =@"";
    cell.lb_calc.text = @"";
    if ([ConfigViewController codeIsShowInfo:fh.stock.code]) {
        cell.lb_code.text = fh.stock.code;
        if ([ConfigViewController codeIsShowName:fh.stock.code]){
            cell.name.text = fh.stock.name;
        }else {
            cell.name.text = @"";
        }
        
        cell.lb_info.text = fh.constructCodeDisplayInfo;
        //    [cell.lb_info setFont:[UIFont fontWithName:nil size:16.0]];
        cell.lb_calc.text = [NSString stringWithFormat:@"%.3f %.3f(ua/ma) %.3f(lua/lma)",[fh.stock getCurDealCostRate], [fh getAverageVaRateVm], [fh getLastVaRateVm]];
        if ([fh isBought]) {
            cell.name.text =  [cell.name.text stringByAppendingString:[NSString stringWithFormat:@"(%.2f%%)(%.2f)",[fh CalcCurIncomeRate]*100,[fh CalcCurIncome]]];
        }
    }
    UIColor *bgcolor = [UIColor clearColor];
    if (fh.warnningType == 1) {
        bgcolor = [UIColor redColor];
    }else if (fh.warnningType == -1){
        bgcolor = [UIColor greenColor];
    }else if (fh.warnningType == 2){
        bgcolor = [UIColor yellowColor];
    }
    cell.backgroundColor = bgcolor;
    
    BOBLOG(@"%f",cell.selectedBackgroundView.frame.size.width);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    if(targetContentOffset->y == 0)
        [self refresh];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (_datasource !=nil) {
        return [_datasource count];
    }
    return 0;
    
}

- (IBAction)btAdd:(id)sender {
    
    MYAlertView* alert = [[MYAlertView alloc] initWithTitle:@"请输入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    alert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    alert.typeId = ALERT_ID_ADD;
    [alert show];
    
}
- (IBAction)btStart:(id)sender {
    _bStarting = !_bStarting;
    if (_bStarting) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
        [_bt_monitor setTitle:@"stop" forState:UIControlStateNormal];
        BOBLOG(@"updateTimer started!");
    }else{
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        [_bt_monitor setTitle:@"start" forState:UIControlStateNormal];
        BOBLOG(@"updateTimer stoped!");
    }

}

- (void)refresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInfo];
    });
}

- (void)backgroundFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
{
    [self updateInfo];
//    completionHandler(UIBackgroundFetchResultNoData);
}
@end
