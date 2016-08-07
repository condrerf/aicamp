//
//  StationDataListWithoutDetail.h
//  MichiNoEki
//
//  Created by  on 11/10/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigurationData.h"
#import "StationData.h"

// 駅データ一覧(詳細以外)
@interface StationDataListWithoutDetail : NSObject {
    StationListOrderType orderType;
    NSArray *stationDataList;
}

@property (nonatomic, readonly) StationListOrderType orderType;
@property (nonatomic, readonly) NSArray *stationDataList;

+ (StationDataListWithoutDetail *)getInstance;
- (StationData *)stationDataWithStationID:(int)stationID;
- (void)sort;

@end
