//
//  Database.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "Categories.h"
#import "Constants.h"
#import "ShopHour.h"
#import "HolidayWeekday.h"
#import "HolidayDay.h"

// 非公開メソッドのカテゴリ
@interface Database(PrivateMethods)
- (NSArray *)selectShopHoursOfStationID:(int)stationID;
- (NSArray *)selectHolidayWeekdaysOfStationID:(int)stationID;
- (NSArray *)selectHolidayDaysOfStationID:(int)stationID;
@end

@implementation Database

// 自身のインスタンス
static Database *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (Database *)getInstance {
    // インスタンスが生成されていない場合は生成
	@synchronized(self) {
		if (!instance) {
            instance = [[self alloc] init];
        }
	}

    return instance;
}

#pragma mark - 全体

// 指定された駅一覧の順序の種類に応じた順序で駅データ(詳細データ以外)の集合を生成し、それを返す
- (NSArray *)selectStationDataListWithoutDetailWithStationListOrderType:(StationListOrderType)stationListOrderType {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 駅データの集合を格納
    NSMutableArray *stationDataList = nil;
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT "];
    [sql appendString:@" id, "];
    [sql appendString:@" COALESCE(name, ''), "];
    [sql appendString:@" COALESCE(rubi, ''), "];
    [sql appendString:@" latitude, "];
    [sql appendString:@" longitude, "];
    [sql appendString:@" COALESCE(DATE(visited_date), '') "];
    [sql appendString:@"FROM "];
    [sql appendString:@" station "];
    [sql appendString:@"ORDER BY "];
    [sql appendString:[NSString stringWithFormat:@" %@ ", (stationListOrderType == StationListOrderTypeStationID) ? @"id" :  @"rubi"]];
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if(sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 取得データを設定
        stationDataList = [NSMutableArray arrayWithCapacity:1];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 駅データを生成
            StationData *stationData = [[StationData alloc] init];
            
            // 各要素に値を設定
            stationData.stationID = sqlite3_column_int(stmt, 0);
            stationData.name = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            stationData.rubi = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
            CLLocationCoordinate2D location;
            location.latitude = sqlite3_column_double(stmt, 3);
            location.longitude = sqlite3_column_double(stmt, 4);
            stationData.location = location;
            stationData.visitedDate = [NSDate dateFromString: [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 5)]];
            stationData.shopHours = [self selectShopHoursOfStationID:stationData.stationID];
            stationData.holidayWeekdays = [self selectHolidayWeekdaysOfStationID:stationData.stationID];
            stationData.holidayDays = [self selectHolidayDaysOfStationID:stationData.stationID];
            
            // 駅データを集合に追加
            [stationDataList addObject:stationData];
            [stationData release];
        }
        // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return stationDataList;
}

#pragma mark - 地図画面

// 指定されたIDの駅の訪問日を返す
- (NSDate *)selectVisitedDateOfStationID:(int)stationID {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 訪問日を格納
    NSDate *visitedDate = nil;
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT "];
    [sql appendString:@" COALESCE(DATE(visited_date), '') "];
    [sql appendString:@"FROM "];
    [sql appendString:@" station "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if(sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 条件値を設定
        sqlite3_bind_int(stmt, 1, stationID);
        
        // 条件に該当するデータが存在する場合
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            // 訪問日を取得
            visitedDate = [NSDate dateFromString:[NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)]];
        }
    // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return visitedDate;
}

// 指定されたIDの駅の訪問日を現在の日付に更新する
- (void)updateVisitedDateOfStationID:(int)stationID {
    // データベースに接続できない場合は、処理を中断する
    if (![self isConnectable]) return;
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"UPDATE "];
    [sql appendString:@" station "];
    [sql appendString:@"SET "];
    [sql appendString:@" visited_date = datetime('now', 'localtime') "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    
    // トランザクションの開始
    // sqlite3_exec(database_, "BEGIN", NULL, NULL, NULL);
    
    // SQLの構文を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if(sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 条件値の設定
        sqlite3_bind_int(stmt, 1, stationID);
        
        // SQLの実行に失敗した場合
        if(sqlite3_step(stmt) != SQLITE_DONE) {
            // エラーログを出力
            NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
        }
        // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    // トランザクションの終了
    // sqlite3_exec(database_, "COMMIT", NULL, NULL, NULL);
}

#pragma mark - 駅情報画面

// 指定されたIDの駅データ(詳細データ含む)を返す
- (StationData *)selectStationDataWithDetailOfStationID:(int)stationID {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 駅データを格納
    StationData *stationData = nil;

    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT "];
    [sql appendString:@" COALESCE(name, ''), "];
    [sql appendString:@" latitude, "];
    [sql appendString:@" longitude, "];
    [sql appendString:@" COALESCE(address, ''), "];
    [sql appendString:@" COALESCE(telephone, ''), "];
    [sql appendString:@" COALESCE(description, ''), "];
    [sql appendString:@" COALESCE(introduction, ''), "];
    [sql appendString:@" COALESCE(message, ''), "];
    [sql appendString:@" COALESCE(recommendation, ''), "];
    [sql appendString:@" COALESCE(DATE(visited_date), '') "];
    [sql appendString:@"FROM "];
    [sql appendString:@" station "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;

    // SQLの実行に成功した場合
    if(sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 条件値を設定
        sqlite3_bind_int(stmt, 1, stationID);

        // 条件に該当するデータが存在する場合
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            // データを設定
            stationData = [[[StationData alloc] init] autorelease];
            stationData.stationID = stationID;
            stationData.name = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
            CLLocationCoordinate2D location;
            location.latitude = sqlite3_column_double(stmt, 1);
            location.longitude = sqlite3_column_double(stmt, 2);
            stationData.location = location;
            stationData.address = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 3)];
            stationData.telephone = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 4)];
            stationData.description = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 5)];
            stationData.introduction = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 6)];
            stationData.message = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 7)];
            stationData.recommendationInfo = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 8)];
            stationData.visitedDate = [NSDate dateFromString:
                                           [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 9)]];
            stationData.shopHours = [self selectShopHoursOfStationID:stationID];
            stationData.holidayWeekdays = [self selectHolidayWeekdaysOfStationID:stationID];
            stationData.holidayDays = [self selectHolidayDaysOfStationID:stationID];
        }
    // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return stationData;
}

#pragma mark - 営業時間データ

// 指定されたIDの駅の営業時間データを返す
- (NSArray *)selectShopHoursOfStationID:(int)stationID {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 営業時間データの集合を格納
    NSMutableArray *shopHours = nil;
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    
    // SQLを設定
    [sql appendString:@"SELECT "];
    [sql appendString:@" opening_hour, "];
    [sql appendString:@" opening_minute, "];
    [sql appendString:@" closing_hour, "];
    [sql appendString:@" closing_minute, "];
    [sql appendString:@" start_month, "];
    [sql appendString:@" end_month, "];
    [sql appendString:@" start_day, "];
    [sql appendString:@" end_day, "];
    [sql appendString:@" beyond_month_flag, "];
    [sql appendString:@" start_weekday, "];
    [sql appendString:@" end_weekday, "];
    [sql appendString:@" holiday_flag, "];
    [sql appendString:@" COALESCE(comment, '') "];
    [sql appendString:@"FROM "];
    [sql appendString:@" shop_hour "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    [sql appendString:@"ORDER BY "];
    [sql appendString:@" start_month "];    
    [sql appendString:@" , start_weekday "];    
    [sql appendString:@" , holiday_flag "];    
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if(sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 条件値を設定
        sqlite3_bind_int(stmt, 1, stationID);
        
        // 条件に該当するデータを設定
        shopHours = [NSMutableArray arrayWithCapacity:1];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ShopHour *shopHour = [[ShopHour alloc] init];
            shopHour.openingHour = sqlite3_column_int(stmt, 0);
            shopHour.openingMinute = sqlite3_column_int(stmt, 1);
            shopHour.closingHour = sqlite3_column_int(stmt, 2);
            shopHour.closingMinute = sqlite3_column_int(stmt, 3);
            shopHour.startMonth = sqlite3_column_int(stmt, 4);
            shopHour.endMonth = sqlite3_column_int(stmt, 5);
            shopHour.startDay = sqlite3_column_int(stmt, 6);
            shopHour.endDay = sqlite3_column_int(stmt, 7);
            shopHour.beyondMonth = sqlite3_column_int(stmt, 8);
            shopHour.startWeekday = sqlite3_column_int(stmt, 9);
            shopHour.endWeekday = sqlite3_column_int(stmt, 10);
            shopHour.isHoliday = sqlite3_column_int(stmt, 11);
            NSString *comment = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 12)];
            shopHour.comment = [@"" isEqualToString:comment] ? nil : comment;
            [shopHours addObject:shopHour];
            [shopHour release];
        }
        // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return shopHours;
}

#pragma mark - 休日データ

// 指定されたIDの駅の休日データを返す
- (NSArray *)selectHolidayWeekdaysOfStationID:(int)stationID {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 休日データの集合を格納
    NSMutableArray *holidayWeekdays = [NSMutableArray arrayWithCapacity:1];
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT "];
    [sql appendString:@" start_weekday, "];
    [sql appendString:@" end_weekday, "];
    [sql appendString:@" start_month, "];
    [sql appendString:@" end_month, "];
    [sql appendString:@" start_week, "];
    [sql appendString:@" end_week, "];
    [sql appendString:@" except_holiday_flag, "];
    [sql appendString:@" previous_day_if_national_holiday_flag, "];
    [sql appendString:@" next_day_if_national_holiday_flag, "];
    [sql appendString:@" COALESCE(comment, '') "];
    [sql appendString:@"FROM "];
    [sql appendString:@" holiday_weekday "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    [sql appendString:@"ORDER BY "];
    [sql appendString:@" start_weekday "];    
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if (sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 取得対象の駅IDを設定
        sqlite3_bind_int(stmt, 1, stationID);
        
        // 条件に該当する休日データを設定
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            HolidayWeekday *holidayWeekday = [[HolidayWeekday alloc] init];
            holidayWeekday.startWeekday = sqlite3_column_int(stmt, 0);
            holidayWeekday.endWeekday = sqlite3_column_int(stmt, 1);
            holidayWeekday.startMonth = sqlite3_column_int(stmt, 2);
            holidayWeekday.endMonth = sqlite3_column_int(stmt, 3);
            holidayWeekday.startWeek = sqlite3_column_int(stmt, 4);
            holidayWeekday.endWeek = sqlite3_column_int(stmt, 5);
            holidayWeekday.exceptHoliday = sqlite3_column_int(stmt, 6);
            holidayWeekday.isPreviousDayIfNationalHoliday = sqlite3_column_int(stmt, 7);
            holidayWeekday.isNextDayIfNationalHoliday = sqlite3_column_int(stmt, 8);
            NSString *comment = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 9)];
            holidayWeekday.comment = [@"" isEqualToString:comment] ? nil : comment;
            [holidayWeekdays addObject:holidayWeekday];
            [holidayWeekday release];
        }
        // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return holidayWeekdays;
}

// 指定されたIDの駅の休日データを返す
- (NSArray *)selectHolidayDaysOfStationID:(int)stationID {
    // データベースに接続できない場合は、nilを返す
    if (![self isConnectable]) return nil;
    
    // 休日データ(日)の集合を格納
    NSMutableArray *holidayDays = [NSMutableArray arrayWithCapacity:1];
    
    // SQLを設定
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT "];
    [sql appendString:@" start_month, "];
    [sql appendString:@" end_month, "];
    [sql appendString:@" start_day, "];
    [sql appendString:@" end_day, "];
    [sql appendString:@" beyond_month_flag, "];
    [sql appendString:@" comment "];
    [sql appendString:@"FROM "];
    [sql appendString:@" holiday_day "];
    [sql appendString:@"WHERE "];
    [sql appendString:@" id = ? "];
    [sql appendString:@"ORDER BY "];
    [sql appendString:@" start_month "];    
    [sql appendString:@" , start_day "];    
    
    // SQLの実行結果を格納
    sqlite3_stmt *stmt = NULL;
    
    // SQLの実行に成功した場合
    if (sqlite3_prepare_v2(database_, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        // 取得対象の駅IDを設定
        sqlite3_bind_int(stmt, 1, stationID);
        
        // 条件に該当する休日データを設定
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            HolidayDay *holidayDay = [[HolidayDay alloc] init];
            holidayDay.startMonth = sqlite3_column_int(stmt, 0);
            holidayDay.endMonth = sqlite3_column_int(stmt, 1);
            holidayDay.startDay = sqlite3_column_int(stmt, 2);
            holidayDay.endDay = sqlite3_column_int(stmt, 3);
            holidayDay.beyondMonth = sqlite3_column_int(stmt, 4);
            NSString *comment = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 5)];
            holidayDay.comment = [@"" isEqualToString:comment] ? nil : comment;
            [holidayDays addObject:holidayDay];
            [holidayDay release];
        }
        // 失敗した場合
    } else {
        // エラーログを出力
        NSLog(@"SQLの実行に失敗: %s", sqlite3_errmsg(database_));
    }
    
    // 終端処理
    [sql release];
    sqlite3_finalize(stmt);
    
    return holidayDays;
}

@end
