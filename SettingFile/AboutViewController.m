//
//  AboutViewController.m
//  AboutView
//
//  Created by 李 萌萌 on 13-1-21.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "AboutViewController.h"
#import "WelcomeViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize tableview;
@synthesize myVersions;
@synthesize mylist;

-(void)back
{
    //[self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initVersions:(NSString *)versions
{

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"COMBO";
    
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
    [self.view addSubview:self.tableview];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"introCOMBO"]];
    }
    if(indexPath.section==1){
        if (indexPath.row!=0) {
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"查看欢迎页";
            cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 15, 10, 15)];
            takeimage.image=[UIImage imageNamed:@"settinggo"];
            [cell.contentView addSubview:takeimage];
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang3"]];
        }
        else
        {
            cell.textLabel.text=@"版本";
            cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
            cell.detailTextLabel.text=@"V1.0.0";
            cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            cell.detailTextLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuangA"]];
        }
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==1){
        UIView* footerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 320, 30)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        label1.text=@"北京玩聚时代网络有限公司";
        label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];

        label1.backgroundColor=[UIColor clearColor];
        [footerview addSubview:label1];
        
        UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 98, 320, 20)];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        label2.text=@"  版权所有";
        label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        label2.textAlignment=NSTextAlignmentCenter;
        [footerview addSubview:label2];
       
        UILabel* label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, 320, 20)];
        label3.backgroundColor=[UIColor clearColor];
        label3.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        label3.text=@"Copyright © 2013 COMBO.";
        label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        label3.textAlignment=NSTextAlignmentCenter;
        [footerview addSubview:label3];
       
        UILabel* label4=[[UILabel alloc]initWithFrame:CGRectMake(0, 140, 320, 20)];
        label4.backgroundColor=[UIColor clearColor];
        label4.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        label4.text=@"All Rights Reserved.";
        label4.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        label4.textAlignment=NSTextAlignmentCenter;
        [footerview addSubview:label4];
        return footerview;
    }
   else
       return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        WelcomeViewController* wel=[[WelcomeViewController alloc]init];
        [self.navigationController pushViewController:wel animated:YES];
       
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
        return 2;
    else
        return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1) return 0;
    else
        return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==1) return 200;
    else
        return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 119;
    }
    return 45;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}






@end
