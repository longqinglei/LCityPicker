//
//  LCityPicker.h
//  LCityPicker
//
//  Created by 龙青磊 on 2016/11/10.
//  Copyright © 2017年 龙青磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCityPicker;

@protocol LCityPickerDelegate <NSObject>

/**  选择完成后返回选择数据   */
- (void)didFinishStringValue:(NSString *)stringVaule;

@end

@interface LCityPicker : UIView

@property (nonatomic, assign)id<LCityPickerDelegate> delegate;

- (void)showInWindow;

@end
