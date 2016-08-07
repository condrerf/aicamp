//
//  PhotoStationSelectViewController.h
//  MichiNoEki
//
//  Created by  on 11/09/21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationData.h"

@protocol PhotoStationSelectViewDelegate;

// 写真の保存先の駅の選択画面
@interface PhotoStationSelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    id<PhotoStationSelectViewDelegate> delegate;
    UIButton *nearestStationButton;
    UITableView *stationTableView;
    UIBarButtonItem *cancelButton;
    StationData *nearestStationData_;
}

@property (nonatomic, assign) id<PhotoStationSelectViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *nearestStationButton;
@property (nonatomic, retain) IBOutlet UITableView *stationTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;

- (id)initWithNearestStationID:(int)stationID;
- (IBAction)nearestStationButtonTouchUp;
- (IBAction)cancelButtonTouchUp;

@end

// デリゲートプロトコル
@protocol PhotoStationSelectViewDelegate<NSObject>
- (void)photoStationSelectViewCellSelectedStationID:(int)stationID;
- (void)photoStationSelectViewCancelButtonTouched;
@end