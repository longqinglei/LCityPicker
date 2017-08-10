//
//  ViewController.m
//  LCityPicker
//
//  Created by 龙青磊 on 2016/11/10.
//  Copyright © 2017年 龙青磊. All rights reserved.
//

#import "ViewController.h"
#import "LCityPicker.h"

@interface ViewController ()<LCityPickerDelegate>
{
    LCityPicker *picker;
}

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    picker = [[LCityPicker alloc]init];
    picker.delegate = self;
    [self.view addSubview:picker];
}

- (IBAction)choseCity:(UIButton *)sender {
    [picker showInWindow];
}

- (void)didFinishStringValue:(NSString *)stringVaule{
    [self.button setTitle:stringVaule forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
