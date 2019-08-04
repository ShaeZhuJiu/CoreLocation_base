//
//  ViewController.m
//  Location
//
//  Created by 谢鑫 on 2019/8/4.
//  Copyright © 2019 Shae. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lngTextFied;
@property (weak, nonatomic) IBOutlet UITextField *latTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (nonatomic,strong) CLLocationManager *locationManager;
//点击获取地址的经纬度
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *lngTextField1;
@property (weak, nonatomic) IBOutlet UITextField *latTextField1;
@property(nonatomic,strong)CLGeocoder *geocoder;
//获取经度纬度的地址
@property (weak, nonatomic) IBOutlet UITextField *lngTextField2;
@property (weak, nonatomic) IBOutlet UITextField *latTextField2;
@property (weak, nonatomic) IBOutlet UITextField *addressField2;
@property (weak, nonatomic) IBOutlet UITextField *nameField2;
@property(nonatomic,strong)CLGeocoder *geocoder2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
#pragma -mark getter -
- (CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter=1000.0f;//设备移动后获取位置信息的最小距离
        _locationManager.delegate=self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}
# pragma -mark delegate-
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.lngTextFied.text=[NSString stringWithFormat:@"%3.5f",self.locationManager.location.coordinate.longitude];//获取经度
    self.latTextField.text=[NSString stringWithFormat:@"%3.5f",self.locationManager.location.coordinate.latitude];//获取纬度
    self.heightTextField.text=[NSString stringWithFormat:@"%3.5f",self.locationManager.location.altitude];//获取高度
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"E:%@",error);
}

#pragma -mark 点击获取位置的经纬度 -
- (CLGeocoder *)geocoder{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}
- (IBAction)clicked:(UIButton *)sender {
    //判断用户输入地址的有效性
    NSString *address  = self.addressField.text;
    if ([address length] == 0) {
        return;
    }
    [self.geocoder geocodeAddressString:self.addressField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有返回信息
        if ([placemarks count] > 0) {
            // placemarks数组中第一个为地标信息
            CLPlacemark *placemark = placemarks[0];
            //获得相应的经纬度
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            //显示到对应的label上面
            self.latTextField1.text = [NSString stringWithFormat:@"%3.5f",coordinate.latitude];
            self.lngTextField1.text = [NSString stringWithFormat:@"%3.5f",coordinate.longitude];
        }
    }];
}
#pragma -mark 获取经纬度的地址 -
- (CLGeocoder *)geocoder2{
    if (_geocoder2==nil) {
        _geocoder2=[[CLGeocoder alloc]init];
    }
    return _geocoder2;
}

- (IBAction)clicked2:(UIButton *)sender {
    double latitude=[self.latTextField2.text doubleValue];
    double longitude=[self.lngTextField2.text doubleValue];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count]>0) {
            //返回描述信息
            CLPlacemark *placemark=placemarks[0];
            //获取所需信息
            NSString *country=placemark.country;
            NSString *area=placemark.administrativeArea;
            NSString *city=placemark.locality;
            NSString *street=placemark.thoroughfare;
            //在textView上显示
            self.addressField2.text=[NSString stringWithFormat:@"%@ %@ %@ %@",country,area,city,street];
            self.nameField2.text=placemark.name;
        }
    }];
}
@end
