//
//  StationDataListWithoutDetail.m
//  MichiNoEki
//
//  Created by  on 11/10/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StationDataListWithoutDetail.h"
#import "Constants.h"
#import "ConfigurationData.h"
#import "Database.h"

@implementation StationDataListWithoutDetail

@synthesize orderType;
@synthesize stationDataList;

// 自身のインスタンス
static StationDataListWithoutDetail *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (StationDataListWithoutDetail *)getInstance {
    // インスタンスが生成されていない場合は生成
	@synchronized(self) {
		if (!instance) {
            instance = [[self alloc] init];
        }
	}
    
    return instance;
}

#pragma mark - 初期化・終端処理

- (id) init {
    self = [super init];
    
    if (self) {
        // 順序の種類と、その種類に応じた順序の駅データの集合を取得
        orderType = [ConfigurationData getInstance].stationListOrderType;
        stationDataList = [[[Database getInstance] selectStationDataListWithoutDetailWithStationListOrderType:orderType] retain];
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [stationDataList release], stationDataList = nil;
    
    [super dealloc];
}

// 指定されたIDの駅データを返す
- (StationData *)stationDataWithStationID:(int)stationID {
    for (StationData *stationData in stationDataList) {
        if (stationData.stationID == stationID) return stationData;
    }
    
    return nil;
}


// 駅一覧の順序の設定データの値に応じてデータを整列する
- (void)sort {
    // 保存された順序の種類が50音順の場合はひらがな、駅のID順の場合は駅のIDの変数を整列のキーに設定
    NSString *sortKey = ([ConfigurationData getInstance].stationListOrderType == StationListOrderTypeStationID) ? STATION_DATA_STATION_ID_VARIABLE_NAME
                                                                                                                : STATION_DATA_RUBI_VARIABLE_NAME;
    
    // 整列後の駅データの集合を取得
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    NSArray *sortDescriptorArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSArray *stationDataListTemp = [[stationDataList sortedArrayUsingDescriptors:sortDescriptorArray] retain];
    [sortDescriptorArray release];
    [sortDescriptor release];
    
    // 駅データの集合を整列後のものに置換
    [stationDataList release];
    stationDataList = [stationDataListTemp retain];
    
    // 順序の種類を格納
    orderType = [ConfigurationData getInstance].stationListOrderType;
}

@end
