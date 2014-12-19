
//
//  ConfigViewController.m
//  StockManager
//
//  Created by apple_02 on 14/12/12.
//  Copyright (c) 2014年 bob. All rights reserved.
//

#import "ConfigViewController.h"
#import "StaticUtils.h"
#import "ViewController.h"


@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:(NSBundle*)nibNameOrNil];
    if (self) {
        self.lb_price = [[UITextField alloc] init];
        self.lb_volume = [[UITextField alloc] init];
        [self.view addSubview:self.lb_price];
        [self.view addSubview:self.lb_volume];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self loadConfig];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void)actionTap:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSString*)getCode
{
    if (_barTitle.title != nil) {
        if ([StockInfoHelper codeIsValid:_barTitle.title]) {
            return _barTitle.title;
        }
    }
    return nil;
}
- (void)saveConfig
{
    
    if ([self getCode] != nil) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[self getCode] forKey:CODE_TAG];
        [dic setValue:_lb_price.text forKey:PRICE_TAG];
        [dic setValue:_lb_volume.text forKey:VOLUME_TAG];
        [dic setValue:_lb_percentOfStopLoss.text forKey:PERCENT_OF_STOPLOSS_TAG];
        [dic setValue:_percentOfprofitOnly.text forKey:PERCENT_OF_PROFITONLY_TAG];
        [StaticUtils standardUserDefaultsSetValue:dic forKey:[self getCode]];
    }
}

+(NSDictionary*)getCodeConfigInfo:(NSString*)code
{
    if (code != nil) {
        return [StaticUtils standardUserDefaultsGetValueforKey:code];
    }
    return nil;
}

-(void)loadConfig
{
    if ([self getCode] != nil) {
        NSDictionary* dic = [StaticUtils standardUserDefaultsGetValueforKey:[self getCode]];
        if (dic != nil) {
            _lb_price.text = [dic valueForKey:PRICE_TAG];
            _lb_volume.text = [dic valueForKey:VOLUME_TAG];
           float cost = [[dic valueForKey:PRICE_TAG] floatValue]*[[dic valueForKey:VOLUME_TAG] floatValue];
            _lb_cost.text = [NSString stringWithFormat:@"%.2f",cost];
            _lb_percentOfStopLoss.text = [dic valueForKey:PERCENT_OF_STOPLOSS_TAG];
            _percentOfprofitOnly.text = [dic valueForKey:PERCENT_OF_PROFITONLY_TAG];
            if (_lb_percentOfStopLoss.text.length == 0) {
                _lb_percentOfStopLoss.text = @"0.05";
            }
            if (_percentOfprofitOnly.text.length == 0) {
                _percentOfprofitOnly.text = @"0.05";
            }
        }
    }
}

- (IBAction)back:(id)sender {
    
    [self saveConfig];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
