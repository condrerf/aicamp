//
//  MapViewController.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StationData.h"
#import "Annotation.h"
#import "ScrollRecognizingMapView.h"
#import "MapGestureRecognizer.h"
#import "CurrentLocationButtonMenuTableViewController.h"
#import "StationInfoViewController.h"
#import "RouteButtonMenuTableViewController.h"
#import "RouteInfoViewController.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, MapViewScrollDelegate, MapGestureRecognizerDelegate, MenuTableViewControllerDelegate, RouteInfoViewControllerDelegate> {
    ScrollRecognizingMapView *mapView;
    UILabel *notificationLabel;
    UISegmentedControl *mapTypeSegmentedControl;
    UIBarButtonItem *currentLocationButton;
    CurrentLocationButtonMenuTableViewController *currentLocationButtonMenuTableViewController;
    UIButton *recordVisitInfoButton;
    UIBarButtonItem *routeButton;
    RouteButtonMenuTableViewController *routeButtonMenuTableViewController;
    IndicatorViewController *indicatorViewController_;
    NSTimer *stationAnnotationUpdateTimer_;
    NSTimer *notificationTimer_;
    NSMutableArray *annotationChangedStationDataArray_;
    BOOL isTracking_;
    int visitTargetStationID_;
    NSArray *stationRoutes_;
    int routingSelectedStationID_;
    RouteInfoViewController *routeInfoViewController_;
    UIImageView *currentStepCenterLocationCircleImageView_;
}

@property (nonatomic, retain) IBOutlet ScrollRecognizingMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *notificationLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *currentLocationButton;
@property (nonatomic, retain) IBOutlet CurrentLocationButtonMenuTableViewController *currentLocationButtonMenuTableViewController;
@property (nonatomic, retain) IBOutlet UIButton *recordVisitInfoButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *routeButton;
@property (nonatomic, retain) IBOutlet RouteButtonMenuTableViewController *routeButtonMenuTableViewController;

- (IBAction)mapTypeControlChanged;
- (IBAction)currentLocationButtonTouchUp;
- (IBAction)recordVisitInfoButtonTouchUp;
- (IBAction)routeButtonTouchUp;
- (void)setStationRoutes:(NSArray *)stationRoutes routingType:(RoutingType)routingType;

@end