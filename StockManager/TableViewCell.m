//
//  TableViewCell.m
//  StockManager
//
//  Created by apple_02 on 14/12/11.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil].lastObject;
        
        
        [self.contentView addSubview:view];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) layoutSubviews {
    [super layoutSubviews];
//    self.backgroundView.frame = CGRectMake(9, 0, 302, 44);
//    self.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 44);
}
#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 10;
//    frame.size.width -= 22 * 10;
    [super setFrame:frame];
}
@end
