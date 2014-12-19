//
//  TableViewCell.h
//  StockManager
//
//  Created by apple_02 on 14/12/11.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lb_code;
@property (strong, nonatomic) IBOutlet UILabel *lb_info;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *lb_calc;

@end
