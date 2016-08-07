//
//  LocationManager.h
//  MapSample
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Constants.h"

// 現在位置情報を管理するクラス
@interface LocationManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *clLocationManager_;
    CLLocationCoordinate2D location;
    CLLocationDirection direction;
    BOOL isUpdatingLocation;
    int locationUpdateFailureCount_;
}

@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, readonly) CLLocationDirection direction;
@property (nonatomic, readonly) BOOL isUpdatingLocation;

+ (LocationManager *)getInstance;
- (BOOL)locationServicesEnabled;
- (void)initialize;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
@end
