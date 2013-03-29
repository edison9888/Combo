//
//  MapViewController.h
//  party
//
//  Created by yilinlin on 13-1-19.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <MapKit/MapKit.h>
@class CustomAnnotation;
@class CreatBeforeViewController;

@protocol passValueDelegate
-(void)passLat:(float)_lat andLng:(float)_lng;
-(void)passCity:(NSString*)city andLocal:(NSString*)local;
@end
@interface MapViewController : UIViewController<MKMapViewDelegate,UISearchBarDelegate,ASIHTTPRequestDelegate>
{
    int Searchflag;//输入搜索地图的标志位
    int Collectflag;//从活动中创建派对进入地图的标志位
    
    id<passValueDelegate> delegate;
    MKMapView* map;
    CLGeocoder* geocoder;
    UISearchBar* mySearchBar;
    double lat;
    double lng;
    UILabel* label;
    NSMutableString* city;
    NSMutableString* local;
    CreatBeforeViewController *creatbefore;
    
    NSString *type;
    
    int map_Temp;
    
    NSString *c_id;
    NSString *c_title;
}

@property (nonatomic,retain) NSString *c_id;
@property (nonatomic,retain) NSString *c_title;
@property int map_Temp;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSMutableString* city;
@property (strong,nonatomic) NSMutableString* local;

@property (nonatomic,strong)id<passValueDelegate> delegate;
@property (strong,nonatomic) MKMapView* map;
@property (strong,nonatomic) CLGeocoder* geocoder;

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer;
- (void)showDetails;

- (void) initWithlat:(double)clat andlng:(double)clng;



@end
