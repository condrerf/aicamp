//
//  ConfigurationData.h
//  MichiNoEki
//
//  Created by  on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 駅一覧の順序の種類
typedef enum {
    StationListOrderTypeStationID = 0,
    StationListOrderTypeJapaneseSyllabary
} StationListOrderType;

// 設定データ
@interface ConfigurationData : NSObject {
    StationListOrderType stationListOrderType;
    BOOL notifiesStation;
    BOOL avoidsTollRoad;
    int routingCount;
    BOOL savesToNearestStationAutomatically;
}

@property (nonatomic) StationListOrderType stationListOrderType;
@property (nonatomic) BOOL notifiesStation;
@property (nonatomic) BOOL avoidsTollRoad;
@property (nonatomic) int routingCount;
@property (nonatomic) BOOL savesToNearestStationAutomatically;

+ (ConfigurationData *) getInstance;
- (void)save;

@end
