
//
//  NearbyWeiboMapViewController.m
//  微妮
//
//  Created by 刘锦 on 14/12/1.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "NearbyWeiboMapViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "BaseRequest.h"

#define KNEARBY @"https://api.weibo.com/2/place/nearby_timeline.json"

@interface NearbyWeiboMapViewController (){
    MKMapView *myMapView;
}
@property(nonatomic,strong)BaseRequest *weiboRequest;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong) NSArray *weiboData;
@end

@implementation NearbyWeiboMapViewController
-(id)init{
    self = [super init];
    if (self) {
        _weiboData = [NSArray array];
    }
    return self;
}
-(void)loadView{
    [super loadView];
    myMapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //将视图添加到根视图
    [self.view addSubview:myMapView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化位置服务
    _locationManager = [[CLLocationManager alloc]init];
    // 设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //设置过滤信息
    [_locationManager setDistanceFilter:1.0];
    //设置代理
    [_locationManager setDelegate:self];
    //iOS8对定位进行了一些修改，其中包括定位授权的方法，CLLocationManager增加了下面的两个方法：
    [_locationManager requestAlwaysAuthorization];
    //开始实时定位
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [_locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"请开启定位功能！");
    }

    //设置代理
    myMapView.delegate = self;
    //设置是否显示用户当前位置
    myMapView.showsUserLocation = YES;
    //设置地图显示类型
    myMapView.mapType = MKMapTypeStandard;
    //是否允许缩放
    myMapView.zoomEnabled = YES;
    myMapView.scrollEnabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - CLLocationManagerDelegate
//成功获取定位数据后将会激发该方法6.0之后新增的位置调用
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    NSLog(@"locations = %@",locations);
    // 获取最后一个定位数据
    CLLocation* location = [locations lastObject];
    //获取经度纬度
    CLLocationCoordinate2D coord2D = location.coordinate;
    //NSLog(@"经度:%f纬度:%f",coord2D.longitude,coord2D.latitude);
    
    //经纬度,地图初始化的时候设置的坐标coord2D
    //显示精度范围，数值越大，范围越大
    MKCoordinateSpan span = {0.1,0.1};
    //显示区域
    MKCoordinateRegion region = {coord2D,span};
    //给地图设置显示区域
    [myMapView setRegion:region animated:YES];
    
    if (self.weiboData!=nil) {
        //数据请求
        [self requestWithLat:coord2D.latitude AndLong:coord2D.longitude];
    }
}
// 定位失败时激发的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"定位失败: %@",error);
}
#pragma mark - Request
-(void)requestWithLat:(float)lat AndLong:(float)lon{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        NSString *requestStr = [NSString stringWithFormat:@"%@?access_token=%@&lat=%f&long=%f",KNEARBY,[userData objectForKey:@"token"],lat,lon];
        //数据请求
        _weiboRequest = [[BaseRequest alloc]initWithURL:requestStr];
        __weak typeof(self) weakSelf = self;
        [_weiboRequest GETRequestWithCompletionHandler:^(NSDictionary *dic){
            //回调数据
            [weakSelf RequestFinished:dic];
        }];
    }else{
        
    }
}

-(void)RequestFinished:(NSDictionary *)dic{
    self.weiboData = [dic objectForKey:@"statuses"];
    for (int i = 0; i < self.weiboData.count; i++) {
        //处理数据
        UserModel *weibo = [[UserModel alloc]init];
        [weibo setContentData:[self.weiboData objectAtIndex:i] WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
        //创建Anatation对象，添加地图上去
        WeiboAnnotation *annotation = [[WeiboAnnotation alloc]initWithWeibo:weibo];
        [myMapView  performSelector:@selector(addAnnotation:) withObject:annotation afterDelay:i*0.05];
    }
}

#pragma mark - MKMapViewDelegate
//返回标注视图（大头针视图）
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    //判断系统的大头针
    if ([annotation isKindOfClass:[mapView.userLocation class]]) {
        return nil;
    }
    static NSString *identifer = @"weiboAnnotation";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifer];
    }
    return annotationView;
}
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (UIView *annotation in views) {
        //0.7----1.2
        //1.2----0.7
        CGAffineTransform transform = annotation.transform;
        annotation.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotation.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            //动画1
            annotation.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotation.alpha = 1;
        }completion:^(BOOL finished){
            //动画2
            [UIView animateWithDuration:0.3 animations:^{
                 annotation.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}
@end
