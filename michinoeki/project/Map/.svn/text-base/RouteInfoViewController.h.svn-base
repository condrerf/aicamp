//
//  RouteInfoViewController.h
//  MichiNoEki
//
//  Created by  on 11/09/29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationRoute.h"

@protocol RouteInfoViewControllerDelegate;

@interface RouteInfoViewController : UIViewController {
    id<RouteInfoViewControllerDelegate> delegate;
    StationRoute *stationRoute;
    UILabel *fromToLabel;
    UILabel *distanceTimeLabel;
    UILabel *estimatedArrivalTimeLabel;
    UILabel *warningLabel;
    UILabel *infoLabel;
    UILabel *currentStepNumberLabel;
    UILabel *stepCountLabel;
    UIButton *backButton;
    UIButton *forwardButton;
    UIButton *closeButton;
    BOOL isOpening;
    int stepIndex_;
}

@property (nonatomic, assign) id<RouteInfoViewControllerDelegate> delegate;
@property (nonatomic, retain) StationRoute *stationRoute;
@property (nonatomic, retain) IBOutlet UILabel *fromToLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *estimatedArrivalTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *warningLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentStepNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *stepCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *forwardButton;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic) BOOL isOpening;

- (IBAction)viewTouchUp;
- (IBAction)backButtonTouchUp;
- (IBAction)forwardButtonTouchUp;
- (IBAction)closeButtonTouchUp;
- (void)initialize;
- (CLLocationCoordinate2D)currentStepStartLocation;
- (void)updateEstimatedArrivalTime;

@end

// デリゲートプロトコル
@protocol RouteInfoViewControllerDelegate<NSObject>
- (void)RouteInfoViewTouched;
- (void)RouteInfoViewButtonTouched;
- (void)RouteInfoViewClosed;
@end