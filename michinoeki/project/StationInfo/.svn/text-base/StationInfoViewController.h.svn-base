//
//  StationInfoViewController.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationData.h"
#import "StationSelectViewController.h"
#import "IndicatorViewController.h"

// 経路検索の種類
typedef enum {
    RoutingTypeFromCurrentLocation = 0,
    RoutingTypeToSurroundingStations,
    RoutingTypeToArbitraryStation
} RoutingType;

@interface StationInfoViewController : UIViewController<StationSelectViewDelegate> {
    UIScrollView *scrollView;
    UIView *stationInfoView;
    UILabel *descriptionLabel;
    UIImageView *stationImageView;
    UILabel *introductionLabel;
    UILabel *addressCaptionLabel;
    UILabel *addressLabel;
    UILabel *telephoneCaptionLabel;
    UILabel *telephoneLabel;
    UIButton *telephoneButton;
    UILabel *shopHourCaptionLabel;
    UILabel *shopHourLabel;
    UILabel *holidayCaptionLabel;
    UILabel *holidayLabel;
    UILabel *commentLabel;
    UILabel *messageCaptionLabel;
    UILabel *messageLabel;
    UILabel *recommendationCaptionLabel;
    UILabel *recommendationLabel;
    UILabel *routingCaptionLabel;
    UIButton *fromCurrentLocationRouteButton;
    UIButton *surroundingStationsRouteButton;
    UIButton *arbitraryStationRouteButton;
    IndicatorViewController *indicatorViewController_;
    StationData *currentStationData_;
    NSMutableArray *destinationStationDataArray_;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *stationInfoView;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *stationImageView;
@property (nonatomic, retain) IBOutlet UILabel *introductionLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *telephoneCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *telephoneLabel;
@property (nonatomic, retain) IBOutlet UIButton *telephoneButton;
@property (nonatomic, retain) IBOutlet UILabel *shopHourCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *shopHourLabel;
@property (nonatomic, retain) IBOutlet UILabel *holidayCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *holidayLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *recommendationCaptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *recommendationLabel;
@property (nonatomic, retain) IBOutlet UILabel *routingCaptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *fromCurrentLocationRouteButton;
@property (nonatomic, retain) IBOutlet UIButton *surroundingStationsRouteButton;
@property (nonatomic, retain) IBOutlet UIButton *arbitraryStationRouteButton;

- (id)initWithStationID:(int)stationID;
- (IBAction)routeButtonTouchUp;
- (IBAction)telephoneButtonTouchUp;
- (IBAction)surroundingStationsRouteButtonTouchUp;
- (IBAction)arbitraryStationRouteButtonTouchUp;

@end