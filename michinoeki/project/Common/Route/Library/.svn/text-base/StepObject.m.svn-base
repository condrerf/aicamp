//
//  StepObject.m
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StepObject.h"


@implementation StepObject

@synthesize travelMode;
@synthesize startLocationLat,startLocationLng;
@synthesize endLocationLat,endLocationLng;
@synthesize polylinePoints,polylineLevels;
@synthesize durationValue,durationText;
@synthesize htmlInstructions;
@synthesize distanceValue,distanceText;
@synthesize polyLines;

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (id)init
{
    if((self = [super init]))
    {
    }
    
    return self;
}

- (void)dealloc
{
    [travelMode release],travelMode = nil;
    [polylinePoints release],polylinePoints = nil;
    [polylineLevels release],polylineLevels = nil;
    [durationValue release],durationValue = nil;
    [durationText release],durationText = nil;
    [htmlInstructions release],htmlInstructions = nil;
    [distanceValue release],distanceValue = nil;
    [distanceText release],distanceText = nil;
    [polyLines release],polyLines = nil;
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- methods --
//--------------------------------------------------------------//

- (void)setupPolyLine
{
    NSMutableString* encoded = [NSMutableString stringWithString:polylinePoints];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    polyLines = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [polyLines addObject:loc];
        
        [loc release];
        [latitude release];
        [longitude release];
    }
}

- (MKPolyline *)polyline
{
    CLLocationCoordinate2D points[[polyLines count]];
    for (int i = 0;i<[polyLines count];i++)
    {
        CLLocation* loc = [polyLines objectAtIndex:i];
        points[i] = [loc coordinate];
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:points count:[polyLines count]];
    
    return polyline;
}

@end
