//
//  StepObject.h
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StepObject : NSObject 
{
    NSString*       travelMode;
    double          startLocationLat;
    double          startLocationLng;
    double          endLocationLat;
    double          endLocationLng;
    NSString*       polylinePoints;
    NSString*       polylineLevels;
    NSString*       durationValue;
    NSString*       durationText;
    NSString*       htmlInstructions;
    NSString*       distanceValue;
    NSString*       distanceText;
    
    NSMutableArray* polyLines;
}

@property(nonatomic,copy)       NSString*       travelMode;
@property(nonatomic)            double          startLocationLat;
@property(nonatomic)            double          startLocationLng;
@property(nonatomic)            double          endLocationLat;
@property(nonatomic)            double          endLocationLng;
@property(nonatomic,copy)       NSString*       polylinePoints;
@property(nonatomic,copy)       NSString*       polylineLevels;
@property(nonatomic,copy)       NSString*       durationValue;
@property(nonatomic,copy)       NSString*       durationText;
@property(nonatomic,copy)       NSString*       htmlInstructions;
@property(nonatomic,copy)       NSString*       distanceValue;
@property(nonatomic,copy)       NSString*       distanceText;
@property(nonatomic,readonly)   NSMutableArray* polyLines;

- (void)setupPolyLine;
- (MKPolyline *)polyline;

@end
