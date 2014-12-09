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

@end

