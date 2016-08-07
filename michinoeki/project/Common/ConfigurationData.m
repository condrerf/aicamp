//
//  ConfigurationData.m
//  MichiNoEki
//
//  Created by  on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationData.h"
#import "Constants.h"

@implementation ConfigurationData

@synthesize stationListOrderType;
@synthesize notifiesStation;
@synthesize avoidsTollRoad;
@synthesize routingCount;
@synthesize savesToNearestStationAutomatically;

// 自身のインスタンス
static ConfigurationData *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (ConfigurationData *) getInstance {
    // インスタンスが生成されていない場合は生成
	@synchronized(self) {
		if (!instance) {
            instance = [[self alloc] init];
        }
	}
	
    return instance;
}

#pragma mark - 初期化・終端処理

- (id)init {
    self = [super init];
    
    if (self) {
        // NSUserDefaultsのデータを取得
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        // データを取得できなかった場合(初回起動)
        if (![defaults objectForKey:NOTIFIES_STATION_KEY]) {
            // 初期値を設定
            stationListOrderType = STATION_LIST_ORDER_TYPE_DEFAULT_VALUE;
            notifiesStation = NOTIFIES_STATION_DEFAULT_VALUE;
            avoidsTollRoad = AVOIDS_TOLL_ROAD_DEFAULT_VALUE;
            routingCount = ROUTING_COUNT_DEFAULT_VALUE;
            savesToNearestStationAutomatically = SAVES_TO_NEAREST_STATION_AUTOMATICALLY_DEFAULT_VALUE;
            // 取得できた場合
        } else {
            // 登録値を設定
            stationListOrderType = [defaults integerForKey:STATION_LIST_ORDER_TYPE_KEY];
            notifiesStation = [defaults boolForKey:NOTIFIES_STATION_KEY];
            avoidsTollRoad = [defaults boolForKey:AVOIDS_TOLL_ROAD_KEY];
            routingCount = [defaults integerForKey:ROUTING_COUNT_KEY];
            savesToNearestStationAutomatically = [defaults boolForKey:SAVES_TO_NEAREST_STATION_AUTOMATICALLY_KEY];
        }
    }
    
    return self;
}

// 設定データを保存する
- (void)save {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:stationListOrderType forKey:STATION_LIST_ORDER_TYPE_KEY];
    [defaults setBool:notifiesStation forKey:NOTIFIES_STATION_KEY];
    [defaults setBool:avoidsTollRoad forKey:AVOIDS_TOLL_ROAD_KEY];
    [defaults setInteger:routingCount forKey:ROUTING_COUNT_KEY];
    [defaults setBool:savesToNearestStationAutomatically forKey:SAVES_TO_NEAREST_STATION_AUTOMATICALLY_KEY];
    [defaults synchronize];
}

@end
