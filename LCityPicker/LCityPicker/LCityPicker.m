//
//  LCityPicker.m
//  LCityPicker
//
//  Created by 龙青磊 on 2016/11/10.
//  Copyright © 2017年 龙青磊. All rights reserved.
//

#import "LCityPicker.h"

#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]

#define EZCityPickerH 200
#define EZCityPickerToolViewH 46

#define EZState  @"state"   //省
#define EZCities @"cities"  //市数组key
#define EZCity   @"city"    //市数组key

@interface LCityPicker()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    NSArray      *_areaArrays;   //省市地区数组
    NSArray      *_cityArrays;   //市数组
    
    NSString     *_selectedStateString;  //选中后的省数据
    NSString     *_selectedCityString;   //选中后的市数据
}

@end

@implementation LCityPicker


#pragma mark - 创建
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, kWinH, kWinW, kWinH)];
    if (self) {
        
        [self initPickerNeedInfo];
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - 初始化
- (void)initPickerNeedInfo{//从plist文件中获取选择器需要的数据
    
    // 初始化省市数组
    _areaArrays = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    
    // 初始化市数组
    _cityArrays = _areaArrays[0][EZCities];
    
    // 初始化时，把默认选择最初状态赋值给选中后的字符串
    _selectedStateString = _areaArrays[0][EZState];
    _selectedCityString = _cityArrays[0][EZCity];
    
}

- (void)initSubviews{//初始化选择器需要的所有控件
    
    // 1.设置当前View(蒙板)属性
    [self setCurrentViewAttrubute];
    
    // 2.创建选择器
    [self creartPickerView];
    
    // 3.创建工具条
    [self creatPickerToolView];
    
}

#pragma mark - 展示/移除在window上
- (void)showInWindow{
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -kWinH);
    } completion:^(BOOL finished) {
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    }];
}

- (void)setCurrentViewAttrubute{//设置View的相关属性
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick:)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)creartPickerView{//创建PickerView
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kWinH - EZCityPickerH, kWinW, EZCityPickerH)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch ( component ) {
        case 0:{
            return _areaArrays.count;
            break;
        }
        case 1:{
            
            return _cityArrays.count;
            break;
        }
        default:{
            
            return 0;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch ( component ) {
        case 0:{
            return _areaArrays[row][EZState];
            break;
        }
        case 1:{
            
            return _cityArrays[row][EZCity];
            break;
        }
        default:{
            
            return nil;
        }
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    switch ( component ) {
        case 0:{
            
            _cityArrays = _areaArrays[row][EZCities];
            
            _selectedStateString = _areaArrays[row][EZState];
            _selectedCityString  = _cityArrays[0][EZCity];
            
            [pickerView selectRow:row inComponent:0 animated:YES];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [pickerView reloadAllComponents];
            });
            
            break;
        }
        case 1:{
            
            _selectedCityString  = _cityArrays[row][EZCity];
            
        }
        default:{
            
            return ;
        }
    }
}

- (void)creatPickerToolView{//创建PickerView的工具条
    
    UIView *constaintView = [[UIView alloc] init];
    constaintView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    constaintView.layer.borderWidth = 1;
    constaintView.frame = CGRectMake(-2, kWinH - EZCityPickerH - EZCityPickerToolViewH, kWinW + 2, EZCityPickerToolViewH);
    constaintView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self addSubview:constaintView];
    
    UIButton *buttonFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFinish.frame = CGRectMake(kWinW - 80, 0, 60, EZCityPickerToolViewH);
    buttonFinish.backgroundColor = [UIColor clearColor];
    [buttonFinish setTitleColor:RGBCOLOR(255, 153, 67) forState:UIControlStateNormal];
    [buttonFinish setTitle:@"完成" forState:UIControlStateNormal];
    [buttonFinish addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    [constaintView addSubview:buttonFinish];
    
    UIButton *buttonCanle = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCanle.frame = CGRectMake(15, 0, 60, EZCityPickerToolViewH);
    buttonCanle.backgroundColor = [UIColor clearColor];
    [buttonCanle setTitleColor:RGBCOLOR(255, 153, 67) forState:UIControlStateNormal];
    [buttonCanle setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCanle addTarget:self action:@selector(canleAction:) forControlEvents:UIControlEventTouchUpInside];
    [constaintView addSubview:buttonCanle];
}

#pragma mark - 按钮点击时间
- (void)finishAction:(UIButton *)btn{//完成按钮点击
    
    NSString *cityValue = [NSString stringWithFormat:@"%@%@",_selectedStateString,_selectedCityString];
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(didFinishStringValue:)] ) {
        [self.delegate didFinishStringValue:cityValue];
    }
    
    [self removeFromWindow];
    
}

- (void)canleAction:(UIButton *)btn{//取消按钮点击事件
    [self removeFromWindow];
}

- (void)removeFromWindow{
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapDidClick:(UITapGestureRecognizer *)tapGesture{//点击View
    [self removeFromWindow];
}

@end
