//
//  PhotoStationListTableCell.m
//  MichiNoEki
//
//  Created by  on 11/08/29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoStationListTableCell.h"

@implementation PhotoStationListTableCell

@synthesize stationImageView;
@synthesize nameLabel;
@synthesize photoCountLabel;

- (void)dealloc {
    // 各コントロールの解放
    [stationImageView release], stationImageView = nil;
    [nameLabel release], nameLabel = nil;
    [photoCountLabel release], photoCountLabel = nil;
	
    [super dealloc];
}

@end
