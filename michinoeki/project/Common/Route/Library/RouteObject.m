//
//  RouteObject.m
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouteObject.h"
#import "StepObject.h"

// ※インポートするファイルを追加
#import "NSString+Extension.h"

#define kStartDelta     0.001f
#define kEndDelta       0.001f
#define kAddDelta       1.7f
#define kMinimumDelta   0.02f

@interface RouteObject (private)
- (NSString *)changeTravelJa:(NSString *)tavel;
@end

@implementation RouteObject

@synthesize status,summary;
@synthesize durationValue,durationText;
@synthesize distanceValue,distanceText;
@synthesize startLocationLat,startLocationLng;
@synthesize endLocationLat,endLocationLng;
@synthesize startAddress,endAddress;
@synthesize steps;
@synthesize southwestLat,southwestLng;
@synthesize northeastLat,northeastLng;

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (id)init
{
    if((self = [super init]))
    {
        steps = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)dealloc
{
    [status release],status = nil;
    [summary release],summary = nil;
    [durationValue release],durationValue = nil;
    [durationText release],durationText = nil;
    [distanceValue release],distanceValue = nil;
    [distanceText release],distanceText = nil;
    [startAddress release],startAddress = nil;
    [endAddress release],endAddress = nil;    
    [steps release],steps = nil;
    
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- override methods --
//--------------------------------------------------------------//

- (NSString *)description
{
    NSMutableString* string = [NSMutableString stringWithCapacity:1];
    [string appendString:[NSString stringWithFormat:@"status %@\n",status]];
    [string appendString:[NSString stringWithFormat:@"summary %@\n",summary]];
    [string appendString:[NSString stringWithFormat:@"durationValue %@\n",durationValue]];
    [string appendString:[NSString stringWithFormat:@"durationText %@\n",durationText]];
    [string appendString:[NSString stringWithFormat:@"distanceValue %@\n",distanceValue]];
    [string appendString:[NSString stringWithFormat:@"distanceText %@\n",distanceText]];
    [string appendString:[NSString stringWithFormat:@"startLocationLat %f\n",startLocationLat]];
    [string appendString:[NSString stringWithFormat:@"startLocationLng %f\n",startLocationLng]];
    [string appendString:[NSString stringWithFormat:@"endLocationLat %f\n",endLocationLat]];
    [string appendString:[NSString stringWithFormat:@"endLocationLng %f\n",endLocationLng]];
    [string appendString:[NSString stringWithFormat:@"startAddress %@\n",startAddress]];
    [string appendString:[NSString stringWithFormat:@"endAddress %@\n",endAddress]];
    [string appendString:[NSString stringWithFormat:@"southwestLat %f\n",southwestLat]];
    [string appendString:[NSString stringWithFormat:@"southwestLng %f\n",southwestLng]];
    [string appendString:[NSString stringWithFormat:@"northeastLat %f\n",northeastLat]];
    [string appendString:[NSString stringWithFormat:@"northeastLng %f\n",northeastLng]];
    
    [string appendString:@"---- steps ----"];
    for (StepObject* stepObj in steps)
    {
        [string appendString:@"---- step ----"];
        [string appendString:[NSString stringWithFormat:@" travelMode %@\n",stepObj.travelMode]];
        [string appendString:[NSString stringWithFormat:@" startLocationLat %f\n",stepObj.startLocationLat]];
        [string appendString:[NSString stringWithFormat:@" startLocationLng %f\n",stepObj.startLocationLng]];
        [string appendString:[NSString stringWithFormat:@" endLocationLat %f\n",stepObj.endLocationLat]];
        [string appendString:[NSString stringWithFormat:@" endLocationLng %f\n",stepObj.endLocationLng]];
        [string appendString:[NSString stringWithFormat:@" polylinePoints %@\n",stepObj.polylinePoints]];
        [string appendString:[NSString stringWithFormat:@" polylineLevels %@\n",stepObj.polylineLevels]];
        [string appendString:[NSString stringWithFormat:@" durationValue %@\n",stepObj.durationValue]];
        [string appendString:[NSString stringWithFormat:@" durationText %@\n",stepObj.durationText]];
        [string appendString:[NSString stringWithFormat:@" htmlInstructions %@\n",stepObj.htmlInstructions]];
        [string appendString:[NSString stringWithFormat:@" distanceValue %@\n",stepObj.distanceValue]];
        [string appendString:[NSString stringWithFormat:@" distanceText %@\n",stepObj.distanceText]];
    }
    
    return string;
}

//--------------------------------------------------------------//
#pragma mark -- private methods --
//--------------------------------------------------------------//

- (NSString *)changeTravelJa:(NSString *)travel
{
    if([travel isEqualToString:@"DRIVING"])
    {
        return @"車";
    }
    else if([travel isEqualToString:@"WALKING"])
    {
        return @"徒歩";
    }
    
    return nil;
}

//--------------------------------------------------------------//
#pragma mark -- methods --
//--------------------------------------------------------------//

- (void)addStep:(StepObject *)stepObj
{
    [steps addObject:stepObj];
}

- (BOOL)getStatus
{
    if([status isEqualToString:@"OK"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)totalRouteText
{
    NSString* route = nil;    
    route = [NSString stringWithFormat:@"%@ %@",distanceText,durationText];
    
    return route;
}

- (NSString *)routeText:(int)index
{
    NSString* route = nil;
    
    if(index == 0)
    {
        StepObject* step = [steps objectAtIndex:index];
        route = [step.htmlInstructions stringByConvertingHTMLToPlainText];
    }
    else
    {
        StepObject* step1 = [steps objectAtIndex:index-1];
        StepObject* step2 = [steps objectAtIndex:index];
        
        NSString* travel = [self changeTravelJa:step1.travelMode];
        NSString* text1 = [NSString stringWithFormat:@"%@で%@移動してから",travel,[step1.distanceText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString* text2 = [step2.htmlInstructions stringByConvertingHTMLToPlainText];
        route = [NSString stringWithFormat:@"%@\n%@",text1,text2];
    }
    
    return route;
}

- (NSString *)endRouteText
{
    StepObject* step = [steps lastObject];
    
    NSString* route = nil;    
    NSString* travel = [self changeTravelJa:step.travelMode];
    NSString* text1 = [NSString stringWithFormat:@"%@で%@移動してから",travel,[step.distanceText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString* text2 = [NSString stringWithFormat:@"%@に到着",[self endAddressText]];
    route = [NSString stringWithFormat:@"%@\n%@",text1,text2];
    
    return route;
}

- (NSString *)startAddressText
{
    NSArray* array = [startAddress componentsSeparatedByString:@","];
    NSString* text = [array lastObject];
    
    return text;
}

- (NSString *)endAddressText
{
    NSArray* array = [endAddress componentsSeparatedByString:@","];
    NSString* text = [array lastObject];
    
    return text;
}

- (MKCoordinateRegion)startCenter
{
    MKCoordinateRegion region;
    // mapの中心点と表示領域
    region.center.latitude = (northeastLat  + southwestLat)  / 2.0f;
    region.center.longitude = (northeastLng + southwestLng) / 2.0;
    region.span.latitudeDelta = fabs(northeastLat  - southwestLat)*kAddDelta;
    region.span.longitudeDelta = fabs(northeastLng - southwestLng)*kAddDelta;
    
    return region;
}

- (MKCoordinateRegion)routeCenter:(int)index
{
    MKCoordinateRegion region;
    if(index == 0)
    {
        region.center.latitude = startLocationLat;
        region.center.longitude = startLocationLng;
        region.span.latitudeDelta = kStartDelta;
        region.span.longitudeDelta = kStartDelta;
    }
    else if(index >= [steps count])
    {
        region.center.latitude = endLocationLat;
        region.center.longitude = endLocationLng;
        region.span.latitudeDelta = kEndDelta;
        region.span.longitudeDelta = kEndDelta;
    }
    else
    {
        StepObject* step = [steps objectAtIndex:index];
        StepObject* stepBack = [steps objectAtIndex:index-1];
        region.center.latitude = step.startLocationLat;
        region.center.longitude = step.startLocationLng;
        double latDelta = fabs(stepBack.startLocationLat  - step.startLocationLat)*kAddDelta;
        double lngDelta = fabs(stepBack.startLocationLng - step.startLocationLng)*kAddDelta;
        region.span.latitudeDelta = latDelta > kMinimumDelta ? kMinimumDelta :latDelta;
        region.span.longitudeDelta = lngDelta > kMinimumDelta ? kMinimumDelta :lngDelta;
    }
    
    return region;
}

- (CLLocationCoordinate2D)routeCoordinate:(int)index
{
    CLLocationCoordinate2D coordinate;
    if(index == 0)
    {
        coordinate.latitude = startLocationLat;
        coordinate.longitude = startLocationLng;
    }
    else if(index >= [steps count])
    {
        coordinate.latitude = endLocationLat;
        coordinate.longitude = endLocationLng;
    }
    else
    {
        StepObject* step = [steps objectAtIndex:index];
        coordinate.latitude = step.startLocationLat;
        coordinate.longitude = step.startLocationLng;
    }
    
    return coordinate;
}

@end
