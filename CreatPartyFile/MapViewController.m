//
//  MapViewController.m
//  party
//
//  Created by yilinlin on 13-1-19.
//
//

#import "MapViewController.h"
#import "CustomAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import "CreatBeforeViewController.h"
#import "ASIHTTPRequest.h"
int flag=0;
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize delegate;
@synthesize c_id;
@synthesize c_title;
@synthesize map_Temp;
@synthesize city;
@synthesize local;
@synthesize Collectflag;
@synthesize map;
@synthesize geocoder;
@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"派对地点";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    flag=0;
    NSMutableString* str=[[NSMutableString alloc]init];
    self.city=str;
    NSMutableString* localstr=[[NSMutableString alloc]init];
    self.local=localstr;
    MKMapView* smap=[[MKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    NSLog(@"%f,%f",[[UIScreen mainScreen] bounds].size.height,self.view.bounds.size.width);
    self.map=smap;
    geocoder=[[CLGeocoder alloc]init];
    self.map.showsUserLocation=YES;
    self.map.userLocation.title=@"我在这里噢";
    self.map.mapType=MKMapTypeStandard;
    self.map.delegate=self;
    
    [self.view addSubview:self.map];
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒作为响应longPress方法
    [map addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
    mySearchBar = [[UISearchBar alloc]
                   initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45 )];
    mySearchBar.delegate = self;
    UIView* segment=[mySearchBar.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    
    UITextField* searchField=[[mySearchBar subviews] lastObject];
    [searchField setReturnKeyType:UIReturnKeySearch];
    mySearchBar.backgroundColor=[UIColor lightGrayColor];
    mySearchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:mySearchBar];
    
    mySearchBar.placeholder=@"搜索或长按地图";
    label=[[UILabel alloc]initWithFrame:CGRectMake(10, mainscreenhight-110,300, 20)];
    
    label.font=[UIFont systemFontOfSize:12];
    
    label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label.layer.cornerRadius=7;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.text=@"";
    [self.view addSubview:label];
    [super viewDidLoad];
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //map的userlocation在这个方法里才开始获得
   NSLog(@"自己的位置::::%f,%f",map.userLocation.coordinate.latitude,map.userLocation.coordinate.longitude);

    if ((flag==0)&&(Collectflag!=1)) {
        float zoomLevel = 0.02;
        MKCoordinateRegion region = MKCoordinateRegionMake(map.userLocation.coordinate,MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [self.map setRegion:[self.map regionThatFits:region] animated:YES];
        flag++;
    }
   
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"lly";
        pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
        {
            pinView = [[MKPinAnnotationView alloc]
                        initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else
    {
        [map.userLocation setTitle:@"我的位置"];
        NSString* locDesc = [NSString stringWithFormat:@"经度%f  纬度:%f", map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude];
        [map.userLocation setSubtitle:locDesc];
    }
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"creatSelectCheck"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 48 , 30);
    [rightButton addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
    
    //pinView.rightCalloutAccessoryView = rightButton;
    pinView.leftCalloutAccessoryView=rightButton;
   
    return pinView;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    UITextField* searchField=[[searchBar subviews] lastObject];
    [searchField resignFirstResponder];
    [NSThread detachNewThreadSelector:@selector(searchPlace) toTarget:self withObject:nil];
    //[self searchPlace:searchBar];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    NSArray* dictArray=[bizDic objectForKey:@"results"];
    NSDictionary* arrDict=[dictArray objectAtIndex:0];
    NSDictionary* geometry=[arrDict objectForKey:@"geometry"];
    NSLog(@"%@",geometry);
    NSDictionary* dict=[geometry objectForKey:@"location"];
    NSLog(@"%@",dict);
    lat=[[dict objectForKey:@"lat"]doubleValue];

    lng=[[dict objectForKey:@"lng"]doubleValue];
    NSLog(@"%lf  %lf",lat,lng);
    
    NSLog(@"搜索地图解析出来的经纬度：：：%f,%f",lat,lng);
    float zoomLevel = 0.02;
    //NSLog(@"%f,%f",map.userLocation.coordinate.latitude,map.userLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng),MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [map setRegion:[map regionThatFits:region] animated:YES];
    
    [self MakeAnnotation];


}


-(void)searchPlace
{
    UITextField* searchField=[[mySearchBar subviews] lastObject];
    NSLog(@"%@",searchField.text);
    NSString *urlStr = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",searchField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    NSURL* url=[NSURL URLWithString:urlStr];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    //[request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
}
- (void)showDetails
{
//    NSLog(@"showDetails button clicked!");
    [delegate passCity:self.city andLocal:self.local];
    [delegate passLat:lat andLng:lng];
//    [self.navigationController popViewControllerAnimated:YES];
    if(map_Temp==1){
        NSLog(@"跳到创建初始界面");
        creatbefore=[[CreatBeforeViewController alloc]init];
        creatbefore.type=self.type;
        creatbefore.city=self.city;
        creatbefore.local=self.local;
        creatbefore.lat=lat;
        creatbefore.lng=lng;
        creatbefore.c_title=self.c_title;
        creatbefore.c_id=c_id;
        
        [self.navigationController pushViewController:creatbefore animated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:map];
    CLLocationCoordinate2D touchMapCoordinate =[map convertPoint:touchPoint toCoordinateFromView:map];
    lat=touchMapCoordinate.latitude;
    lng=touchMapCoordinate.longitude;
    NSLog(@"长按地图获取到的经纬度:%f,%f",lat,lng);
    [self MakeAnnotation];
    
}
-(void)MakeAnnotation
{
    CustomAnnotation* pointAnnotation = nil;
    pointAnnotation = [[CustomAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    CLLocation* location=[[CLLocation alloc]initWithLatitude:lat longitude:lng];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark* placemark=[placemarks objectAtIndex:0];
        if (placemark==nil) {
            NSLog(@"null");
        }
        else{
            NSDictionary* dict=placemark.addressDictionary;
            NSLog(@"%@",dict);
            NSLog(@"%@",[dict objectForKey:@"City"]);
            NSLog(@"%@",[dict objectForKey:@"Country"]);
            NSLog(@"%@",[dict objectForKey:@"CountryCode"]);
            NSLog(@"%@",[dict objectForKey:@"FormattedAddressLines"]);
            NSLog(@"%@",[dict objectForKey:@"Name"]);
            NSLog(@"%@",[dict objectForKey:@"State"]);//1
            NSLog(@"%@",[dict objectForKey:@"Street"]);
            NSLog(@"%@",[dict objectForKey:@"SubLocality"]);//1
            NSLog(@"%@",[dict objectForKey:@"Thoroughfare"]);//1
            //在搜索框显示“搜索或长按地图”
            [city setString:@""];
            //[city appendString:[dict objectForKey:@"State"]];
            [city appendFormat:@"%@",[dict objectForKey:@"City"]];
            if ([city isEqualToString:@"(null)"]) {
                [city setString:@""];
                [city appendFormat:@"%@",[dict objectForKey:@"State"]];
            }
            [local setString:@""];
            [local appendFormat:@"%@%@",[dict objectForKey:@"SubLocality"],[dict objectForKey:@"Thoroughfare"]];
            label.text=[NSString stringWithFormat:@"%@ %@",city,local];
        }
        
    }];
    pointAnnotation.title = @" ";
   // pointAnnotation.subtitle=@" ";
    [map removeAnnotations:self.map.annotations];
    [map addAnnotation:pointAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithlat:(double)clat andlng:(double)clng
{
    lat=clat;
    lng=clng;
    self.Collectflag=1;
}
-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
