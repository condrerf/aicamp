//
//  PhotoStationListViewController.h
//  MichiNoEki
//
//  Created by  on 11/08/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoStationSelectViewController.h"
#import "IndicatorViewController.h"

@interface PhotoStationListViewController : UITableViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, PhotoStationSelectViewDelegate, UIActionSheetDelegate> {
    UIBarButtonItem *shootingButton;
    UIBarButtonItem *actionButton;
    IndicatorViewController *indicatorViewController_;
    UIImagePickerController *imagePickerController_;
    int imagePickerViewHeight_;
    NSArray *photoCounts_;
    UIImage *takenPhoto_;
    NSMutableArray *photoFilePaths_;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *shootingButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;

- (IBAction)shootingButtonTouchUp;
- (IBAction)actionButtonTouchUp;

@end
