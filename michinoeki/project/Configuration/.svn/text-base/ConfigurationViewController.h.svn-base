//
//  ConfigurationViewController.h
//  MichiNoEki
//
//  Created by  on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// 設定画面
@interface ConfigurationViewController : UIViewController {
    UISegmentedControl *stationListOrderTypeControl;
    UISegmentedControl *notifiesStationControl;
    UISegmentedControl *avoidsTollRoadControl;
    UISlider *routingCountSlider;
    UILabel *routingCountLabel;
    UISegmentedControl *savesToNearestStationAutomaticallyControl;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *stationListOrderTypeControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *notifiesStationControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *avoidsTollRoadControl;
@property (nonatomic, retain) IBOutlet UISlider *routingCountSlider;
@property (nonatomic, retain) IBOutlet UILabel *routingCountLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *savesToNearestStationAutomaticallyControl;

- (IBAction)stationListOrderTypeControlChanged;
- (IBAction)notifiesStationControlChanged;
- (IBAction)avoidsTollRoadControlChanged;
- (IBAction)routingCountSliderChanged;
- (IBAction)savesToNearestStationAutomaticallyControlChanged;

@end
