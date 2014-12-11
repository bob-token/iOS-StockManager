//
//  ViewController.m
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "AFNetworking.h"

#define ALERT_ID_DELETE 1
#define ALERT_ID_ADD    2

#define BOBLOG NSLog

#define CODES_SAVE_KEY @"codes"


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
    return (self.nowPrice - self.closePrice)*100/self.closePrice;
}

-(BOOL)isValide
{
    if (self.nowPrice > 0) {
        return YES;
    }
    return NO;
}
-(NSString*)constructCodeDisplayInfo
{

    if ([self isValide]) {
        return [NSString stringWithFormat:@"%@:(%.2f)%.2f %d",self.code,[self getPercent],self.nowPrice,self.volume];
    }
    return self.code;
}
@end

@implementation ViewController

- (void)dealloc
{
    [self saveCodes];
    self.datasource = nil;
    self.codeArray = nil;
    [self btStop:self];
}

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

-(void)loadCodes
{
   self.codeArray = [ViewController standardUserDefaultsGetValueforKey:CODES_SAVE_KEY];
    if (_codeArray != nil && _codeArray.count > 0) {
        for (NSString *code in _codeArray) {
            [_datasource addObject:[[StockInfo alloc] initWithCode:code]];
        }
        [_tableview reloadData];
    }
}

-(void)saveCodes
{
    [ViewController standardUserDefaultsSetValue:self.codeArray forKey:CODES_SAVE_KEY];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        int len = result.length;
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
        info.date = inf[31];
        info.time = inf[32];
        return info;
    }
    return nil;
}

-(NSInteger)getCodeIndexInTabViewSource:(NSString*)code
{
    __block NSInteger index = -1;
    if (code != nil && _datasource!= nil && _datasource.count > 0) {
        [_datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([code isEqualToString:((StockInfo*)obj).code]){
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

-(void)parseCodeInfo:(NSString*)code info:(NSString*)info
{
    StockInfo* f = [self parseResult:code result:info];
    if (f != nil) {
        
        NSInteger index =  [self getCodeIndexInTabViewSource:code];
        
        if (index == -1) {
            [_datasource addObject:f];
        }else{
            [_datasource replaceObjectAtIndex:index withObject:f];
        }
        
        [_tableview reloadData];
    }
}

-(NSString*)buildCode:(NSString*)codeid{
    
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

-(void)updateCodeInfo:(NSString*) strCode{
    if ([self codeIsValid:strCode]) {
        NSString* code = [self buildCode:strCode];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
        NSString* baseurl = @"http://hq.sinajs.cn/?_=1314426110204&list=";
        NSString* url = [baseurl stringByAppendingString:code];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    MYAlertView* alert = (MYAlertView*)alertView;
    
    switch (alert.typeId) {
        case ALERT_ID_ADD:
        {
            if (buttonIndex == 1) {
                NSString* code = [alert textFieldAtIndex:0].text;
                if ([self codeIsValid:code]) {
                    
                    [_codeArray addObject:code];
                }else{
                    NSString* msg = @"输入不正确";
                    MYAlertView* alert = [[MYAlertView alloc] initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                    [alert show];
                }
            }
        }break;
        case ALERT_ID_DELETE:
        {
            if (buttonIndex == 1) {
                
                int index = [alert.userData integerValue];
                
                if (index < _datasource.count) {
                    StockInfo* info = _datasource[index];
                    int codeIndex = [self getCodeIndexInCodeArray:info.code];
                    if (codeIndex != -1) {
                        [_codeArray removeObjectAtIndex:codeIndex];
                    }
                    [_datasource removeObjectAtIndex:index];
                    [_tableview reloadData];
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
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define TAB_CELL_ID @"TAB_CELL_ID"
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TAB_CELL_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TAB_CELL_ID];
    }
    [cell.textLabel setText:((StockInfo*)_datasource[indexPath.row]).constructCodeDisplayInfo];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    alert.typeId = ALERT_ID_ADD;
    
    [alert show];
    
}

- (IBAction)btStart:(id)sender {
//    [NSTimer timerWithTimeInterval:30.0 invocation:updateInfo repeats:YES ];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    BOBLOG(@"updateTimer started!");
}

- (IBAction)btStop:(id)sender {
    
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    BOBLOG(@"updateTimer stoped!");
}

- (BOOL)codeIsValid:(NSString*)code
{
    if (code == nil) return NO;
    if (code.length != 6) return NO;
    
    
    return YES;
}
-(void)viber
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
