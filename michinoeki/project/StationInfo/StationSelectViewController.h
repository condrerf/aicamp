//
//  StationSelectViewController.h
//  MichiNoEki
//
//  Created by  on 11/09/30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationData.h"

@protocol StationSelectViewDelegate;

// 駅の選択画面
@interface StationSelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    id<StationSelectViewDelegate> delegate;
    UITableView *stationTableView;
    UIBarButtonItem *cancelButton;
    NSMutableArray *stationDataArray_;
}

@property (nonatomic, assign) id<StationSelectViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *stationTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;

- (id)initWithStationID:(int)stationID;
- (IBAction)cancelButtonTouchUp;

@end

// デリゲートプロトコル
@protocol StationSelectViewDelegate<NSObject>
- (void)stationSelectViewCellSelectedStationData:(StationData *)stationData;
- (void)stationSelectViewCancelButtonTouched;
@end