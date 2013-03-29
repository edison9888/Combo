//
//  LogInViewController.h
//  party
//
//  Created by yilinlin on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FriendViewView.h"
#import "WeiboAccounts.h"
#import "WeiboSignIn.h"
#import "UserQuery.h"

@class WelcomViewController;

//#define kAppKey             @"2629119497"
//#define kAppSecret          @"b940891aad16ae7627de8eaa7322e8c6"
//#define kAppRedirectURI     @"http://weibo.com/ch7e"
@class login,resign,write_infor,write_done,takePhoto,FireView;
@interface LogInViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WeiboSignInDelegate>{
    
    
    //欢迎页
    WelcomViewController* welcom;
    login *loginView;
    resign *resignView;
    write_done* infodoneView;
    write_infor *infowriteView;
    takePhoto *photoView;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView;
    
    UIDatePicker* datepicker;
    UIToolbar *dateToolbar;
    
    NSString *mail;
    NSString *mail_pass;
    UIImage *user_pic;
    NSString *user_nick;
    NSString *user_age;
    NSString *user_sex;
    
    //====================
    //更改微博账号button
    WeiboSignIn *_weiboSignIn;
    UIImage *imageSina;
    NSString *stringNameSina;
    
    NSMutableArray *mutableArray;
    UITableView *tableviewFriend;
    NSNumber *number;
    int numberSum;
    int flogFriend;
    int spot;
    
    NSDictionary *dictory;
    
    NSTimer *timer;
    int move;
    
    NSTimer *timer1;
    int move1;
    
    
}
@property (nonatomic,strong) NSDictionary *dictory;
@property (nonatomic,strong) NSString *mail;
@property (nonatomic,strong) NSString *mail_pass;
@property (nonatomic,strong) UIImage *user_pic;
@property (nonatomic,strong) NSString *user_nick;
@property (nonatomic,strong) NSString *user_age;
@property (nonatomic,strong) NSString *user_sex;

@property (nonatomic,strong) UIToolbar *dateToolbar;
@property (nonatomic,strong) login *loginView;;
@property (nonatomic,strong) resign *resignView;
@property (nonatomic,strong) write_done* infodoneView;
@property (nonatomic,strong) write_infor *infowriteView;

@property (nonatomic,strong) takePhoto *photoView;

@end
