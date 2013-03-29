//
//  write_done.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface write_done :  UIView<UITextFieldDelegate>{
    UILabel *labelName;
    UITextField *field1;//用户名
    UITextField *field2;//年龄
    UIButton *button1; //男
    UIButton *button2; //女
    UIButton *button3; //确认
    UIButton *button4;
    
    UIImageView *imgView;
}

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITextField *field1;//
@property (nonatomic,strong) UITextField *field2;//
@property (nonatomic,strong) UIButton *button1; //男
@property (nonatomic,strong) UIButton *button2; //女
@property (nonatomic,strong) UIButton *button3; //确认
@property (nonatomic,strong) UIButton *button4;

@end
