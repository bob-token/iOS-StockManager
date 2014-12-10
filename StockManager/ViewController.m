//
//  ViewController.m
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

#define ALERT_ID_DELETE 1
#define ALERT_ID_ADD    2

#define BOBLOG NSLog

@interface ViewController ()

@end

@implementation MYAlertView
- (void) dealloc
{
    self.userData = nil;
}

@end

@implementation ViewController

- (void)dealloc
{
    self.datasource = nil;
    self.codeArray = nil;
    [self btStop:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_datasource ==nil) {
        self.datasource = [[NSMutableArray alloc] initWithCapacity:3];
    }
    if (_codeArray == nil) {
        _codeArray = [[NSMutableArray alloc] initWithCapacity:3];
        [_codeArray addObject:@"sh600000"];
    }
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableview addGestureRecognizer:longPressGr];
}
-(void)success:(AFHTTPRequestOperation *)operation result:(id) responseObject {
    
    NSLog(@"JSON: %@", responseObject);
    
};

-(void)updateCodeInfo:(NSString*) code{
    if ([self codeIsValid:code]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
        NSString* baseurl = @"http://hq.sinajs.cn/?_=1314426110204&list=";
        NSString* url = [baseurl stringByAppendingString:code];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000 );
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//        manager.responseSerializer.stringEncoding = enc;
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", [ [NSString alloc] initWithData:responseObject encoding:enc] );
            
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
                [_datasource removeObjectAtIndex:[alert.userData integerValue]];
                [_tableview reloadData];
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
    [cell.textLabel setText:_datasource[indexPath.row]];
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
    if (code.length != 8) return NO;
    
    
    return YES;
}

@end
