//
//  StationListTableViewCell.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationListTableViewCell.h"

@implementation StationListTableViewCell

@synthesize stationIDLabel;
@synthesize stationImageView;
@synthesize nameLabel;
@synthesize rubiLabel;
@synthesize visitedDateLabel;

- (void)dealloc {
    // 各コントロールの解放
    [stationIDLabel release], stationIDLabel = nil;
    [stationImageView release], stationImageView = nil;
    [nameLabel release], nameLabel = nil;
    [rubiLabel release], rubiLabel = nil;
    [visitedDateLabel release], visitedDateLabel = nil;
	
    [super dealloc];
}

@end
