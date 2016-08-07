//
//  StationListTableViewCell.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationListTableViewCell : UITableViewCell {
    UILabel *stationIDLabel;
	UIImageView *stationImageView;
	UILabel *nameLabel;
    UILabel *rubiLabel;
    UILabel *visitedDateLabel;
}

@property(nonatomic,retain) IBOutlet UILabel *stationIDLabel;
@property(nonatomic,retain) IBOutlet UIImageView *stationImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *rubiLabel;
@property(nonatomic,retain) IBOutlet UILabel *visitedDateLabel;

@end
