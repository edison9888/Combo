//
//  write_infor.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface write_infor : UIView<UITextFieldDelegate>{
    UITextField *field1;//用户名
    UITextField *field2;//年龄
    UIButton *button1; //男
    UIButton *button2; //女
    UIButton *button3; //确认
    UIButton *button4; //返回
    
    UILabel *labelName;//填写资料
    
    UIImageView *imgView;
}

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *button4; //返回
@property (nonatomic,strong) UITextField *field1;//用户名
@property (nonatomic,strong) UITextField *field2;//年龄
@property (nonatomic,strong) UIButton *button1; //男
@property (nonatomic,strong) UIButton *button2; //女
@property (nonatomic,strong) UIButton *button3; //确认

@end
