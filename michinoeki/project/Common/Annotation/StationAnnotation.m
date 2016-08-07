//
//  StationAnnotation.m
//  MichiNoEki
//
//  Created by  on 11/08/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"
#import "Constants.h"

@implementation StationAnnotation

@synthesize stationData;

// 指定された駅データを使用して初期化する
- (id)initWithStationData:(StationData *)_stationData {
    NSString *title = [NSString stringWithFormat:STATION_ANNOTATION_TITLE_FORMAT, _stationData.stationID, _stationData.name];
    self = [super initWithCoordinate:_stationData.location title:title];

    if (self) {
        // 駅データを格納
        stationData = [_stationData retain];
    }
    
    return self;
}

// 終端処理
- (void)dealloc {
    // 各オブジェクトの解放
    [stationData release], stationData = nil;
    
    [super dealloc];
}

@end
