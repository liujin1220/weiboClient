//
//  NearbyWeiboMapViewController.h
//  微妮
//
//  Created by 刘锦 on 14/12/1.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SelectedWeiboName.h"
#import "userModel.h"
@class WeiboAnnotation;
@class WeiboAnnotationView;
@class UserInfoData;
@interface NearbyWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@end
