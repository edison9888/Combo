//
//  CreatBeforeViewController.h
//  party
//
//  Created by mac bookpro on 13-3-12.
//
//

#import <UIKit/UIKit.h>
@class CheckOneViewController;

@interface CreatBeforeViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>{
    CheckOneViewController *friendList;
    UILabel* addrLabel;
    NSString *city;
    NSString *local;
    
    UITextField *phone;
    UITextField *name;
    
    UIToolbar *keyboardToolbar;
    UIDatePicker *DatePicker;
    
    NSDate *time;
    
    NSString *type;
    
    float lat;
    float lng;
    NSString *c_id;
    NSString *c_title;
}
@property (nonatomic,retain) NSString *c_id;
@property (nonatomic,retain) NSString *c_title;

@property  float lat;
@property  float lng;

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *local;

@end
