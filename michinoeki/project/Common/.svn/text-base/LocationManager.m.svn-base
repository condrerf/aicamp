//
//  LocationManager.m
//  MapSample
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

@synthesize location;
@synthesize direction;
@synthesize isUpdatingLocation;

// 自身のインスタンス
static LocationManager *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (LocationManager *) getInstance {
    // インスタンスが生成されていない場合は生成
	@synchronized(self) {
		if (!instance) {
            instance = [[self alloc] init];
        }
	}
	
    return instance;
}

#pragma mark - 初期化・終端処理

// 初期化
- (id)init {
    self = [super init];

    if (self) {
        // 現在位置の提供クラスを生成
        clLocationManager_ = [[CLLocationManager alloc] init];
        
        // 取得精度と検出距離を共に最高に設定(1度取得したら取得処理を終了するため、2度以上取得する必要がない)
		clLocationManager_.desiredAccuracy = kCLLocationAccuracyBest;
        clLocationManager_.distanceFilter = DBL_MAX;
        
        // 自身をデリゲートに設定
        clLocationManager_.delegate = self;
    }

    return self;
}

// 終端処理
- (void)dealloc {
    // 各オブジェクトの解放
    clLocationManager_.delegate = nil;
    [clLocationManager_ release], clLocationManager_ = nil;
    [instance release], instance = nil;

    [super dealloc];
}

#pragma mark - 判定

// GPS機能が使用できる機種であるかどうかを返す
- (BOOL)locationServicesEnabled {
    // iOS3以下と4以降の双方に対応
    return [CLLocationManager respondsToSelector:@selector(locationServicesEnabled)] ?
        [CLLocationManager locationServicesEnabled] : clLocationManager_.locationServicesEnabled;
}

//// 向きが検出できる機種であるかどうかを返す
//- (BOOL)headingAvailable {
//    // iOS3以下と4以降の双方に対応
//    return [CLLocationManager respondsToSelector:@selector(headingAvailable)] ?
//        [CLLocationManager headingAvailable] : clLocationManager_.headingAvailable;
//}

#pragma mark - 現在位置の更新

// 設定情報の初期化
- (void)initialize {
    location.latitude = 0;
    location.longitude = 0;
    locationUpdateFailureCount_ = 0;
}

// 現在位置の更新を開始する
- (void)startUpdatingLocation {
    // 初期化
    [self initialize];

    // 更新を開始
    [clLocationManager_ startUpdatingLocation];
    isUpdatingLocation = YES;
}

// 現在位置の更新を停止する
- (void)stopUpdatingLocation {
    // 更新を停止
    [clLocationManager_ stopUpdatingLocation];
    isUpdatingLocation = NO;
}

// startUpdatingLocationメソッド実行後、現在位置の取得に成功した場合に実行される処理
- (void)locationManager:(CLLocationManager *)manager
        didUpdateToLocation:(CLLocation *)newLocation
        fromLocation:(CLLocation *)oldLocation {
    
    // 現在位置の取得時間から現在までの時間が規定値以上経過しているか、水平精度が無効または規定値を超えている場合
    if (abs([newLocation.timestamp timeIntervalSinceNow]) > VALID_LOCATION_UPDATE_INTERVAL ||
        (signbit(newLocation.horizontalAccuracy) || newLocation.horizontalAccuracy > MAX_VALID_LOCATION_ACCURACY)) {
        // 現在位置の更新の失敗回数の加算
        locationUpdateFailureCount_++;
        
        // 失敗回数が規定値を超えた場合
        if (locationUpdateFailureCount_ > LOCATION_UPDATE_RETRY_COUNT) {
            // 失敗時のメソッドを実行
            [self locationManager:manager didFailWithError:nil];
        // 超えていない場合
        } else {
            // 再起動(※設定情報と更新中フラグは変更させないため、当クラスの停止・開始メソッドは実行しない)
            [clLocationManager_ stopUpdatingLocation];
            [clLocationManager_ startUpdatingLocation];
        }
        
        // 処理を中断
        return;
    }

    // 現在位置を設定
    location = newLocation.coordinate;
    
    // 向き情報を設定
    direction = newLocation.course;

    // 現在位置の取得を停止
    [self stopUpdatingLocation];

    // 通知を送信
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATE_SUCCEEDED_NOTIFICATION object:nil];
}

// startUpdatingLocationメソッド実行後、現在位置の取得に失敗した場合に実行される処理
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    // 現在位置の取得を停止
    [self stopUpdatingLocation];

    // 更新失敗の通知を送信
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATE_FAILED_NOTIFICATION object:nil];
}

@end
