//
//  ViewController.m
//  StockManager
//
//  Created by apple_02 on 14/12/8.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_datasource ==nil) {
        self.datasource = [NSMutableArray arrayWithObjects:@"hello",@"yes", nil];
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
    [_datasource addObject:@"text"];
    [_tableview reloadData];
}

- (IBAction)btStart:(id)sender {
}

- (IBAction)btStop:(id)sender {
}
@end
