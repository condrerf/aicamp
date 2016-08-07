//
//  PhotoListViewController.h
//  MichiNoEki
//
//  Created by  on 11/08/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationData.h"
#import "IndicatorViewController.h"

@interface PhotoListViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    UIScrollView *scrollView;
    UIView *photoListView;
    UILabel *noPhotoLabel;
    UILabel *exportInformationLabel;
    UILabel *deleteInformationLabel;
    StationData *stationData_;
    IndicatorViewController *indicatorViewController_;
    UIBarButtonItem *actionButton_;
    UIBarButtonItem *exportButton_;
    UIBarButtonItem *deleteButton_;
    NSMutableArray *exportTargetPhotoFilePaths_;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *photoListView;
@property (nonatomic, retain) IBOutlet UILabel *noPhotoLabel;
@property (nonatomic, retain) IBOutlet UILabel *exportInformationLabel;
@property (nonatomic, retain) IBOutlet UILabel *deleteInformationLabel;

- (id)initWithStationID:(int)stationID;

@end
