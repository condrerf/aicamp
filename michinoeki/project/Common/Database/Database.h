//
//  Database.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseBase.h"
#import "StationData.h"
#import "ConfigurationData.h"

// データベースクラス
@interface Database : DatabaseBase

+ (Database *)getInstance;

- (NSArray *)selectStationDataListWithoutDetailWithStationListOrderType:(StationListOrderType)stationListOrderType;
- (NSDate *)selectVisitedDateOfStationID:(int)stationID;
- (void)updateVisitedDateOfStationID:(int)stationID;
- (StationData *)selectStationDataWithDetailOfStationID:(int)stationID;

@end
