//
//  StationRoute.h
//  MichiNoEki
//
//  Created by  on 11/09/16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouteObject.h"
#import "StationData.h"

// 駅の経路データ
@interface StationRoute : NSObject {
    RouteObject *routeObject;
    StationData *sourceStationData;
    StationData *destinationStationData;
}

@property (nonatomic, readonly) RouteObject *routeObject;
@property (nonatomic, retain) StationData *sourceStationData;
@property (nonatomic, retain) StationData *destinationStationData;

- (id)initWithSourceLocation:(CLLocationCoordinate2D)sourceLocation destinationLocation:(CLLocationCoordinate2D)destinationLocation;
- (CLLocationCoordinate2D)startLocationWithStepIndex:(int)stepIndex;
- (NSString *)informationWithStepIndex:(int)stepIndex;

@end
