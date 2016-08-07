//
//  RouteObject.h
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class StepObject;

@interface RouteObject : NSObject
{
    NSString*       status;
    NSString*       summary;
    NSString*       durationValue;
    NSString*       durationText;
    NSString*       distanceValue;
    NSString*       distanceText;
    double          startLocationLat;
    double          startLocationLng;
    double          endLocationLat;
    double          endLocationLng;
    NSString*       startAddress;
    NSString*       endAddress;
    NSMutableArray* steps;
    double          southwestLat;
    double          southwestLng;
    double          northeastLat;
    double          northeastLng;
}

@property(nonatomic,copy)       NSString*       status;
@property(nonatomic,copy)       NSString*       summary;
@property(nonatomic,copy)       NSString*       durationValue;
@property(nonatomic,copy)       NSString*       durationText;
@property(nonatomic,copy)       NSString*       distanceValue;
@property(nonatomic,copy)       NSString*       distanceText;
@property(nonatomic)            double          startLocationLat;
@property(nonatomic)            double          startLocationLng;
@property(nonatomic)            double          endLocationLat;
@property(nonatomic)            double          endLocationLng;
@property(nonatomic,copy)       NSString*       startAddress;
@property(nonatomic,copy)       NSString*       endAddress;
@property(nonatomic,readonly)   NSMutableArray* steps;
@property(nonatomic)            double          southwestLat;
@property(nonatomic)            double          southwestLng;
@property(nonatomic)            double          northeastLat;
@property(nonatomic)            double          northeastLng;

- (void)addStep:(StepObject *)stepObj;
- (BOOL)getStatus;
- (NSString *)totalRouteText;
- (NSString *)routeText:(int)index;
- (NSString *)endRouteText;
- (NSString *)startAddressText;
- (NSString *)endAddressText;
- (MKCoordinateRegion)startCenter;
- (MKCoordinateRegion)routeCenter:(int)index;
- (CLLocationCoordinate2D)routeCoordinate:(int)index;
@end
