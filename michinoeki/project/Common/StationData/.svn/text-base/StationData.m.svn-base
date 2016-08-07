//
//  StationData.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationData.h"
#import "Constants.h"
#import "Categories.h"
#import "Utility.h"
#import "ShopHour.h"
#import "HolidayWeekday.h"
#import "HolidayDay.h"
#import "NationalHolidayManager.h"

// 非公開メソッドのカテゴリ
@interface StationData(PrivateMethods)
- (NSString *)dateStringWithStartMonth:(int)startMonth endMonth:(int)endMonth startDay:(int)startDay endDay:(int)endDay beyondMonth:(BOOL)beyondMonth;
- (NSString *)commentWithShopHour:(ShopHour *)shopHour;
- (NSString *)weekdayStringWithHolidayWeekday:(HolidayWeekday *)holidayWeekday;
- (NSString *)commentWithHolidayWeekday:(HolidayWeekday *)holidayWeekday;
- (BOOL)isInRangeWithMonth:(int)month day:(int)day
                startMonth:(int)startMonth endMonth:(int)endMonth 
                  startDay:(int)startDay endDay:(int)endDay 
               beyondMonth:(BOOL)beyondMonth;
@end

@implementation StationData

@synthesize stationID;
@synthesize name;
@synthesize rubi;
@synthesize romanName;
@synthesize location;
@synthesize address;
@synthesize telephone;
@synthesize shopHours;
@synthesize holidayWeekdays;
@synthesize holidayDays;
@synthesize description;
@synthesize introduction;
@synthesize message;
@synthesize recommendationInfo;
@synthesize visitedDate;
@synthesize isClosing;

#pragma mark - 初期化・終端処理

- (void)dealloc {
    // 各オブジェクトの解放
    [name release], name = nil;
    [rubi release], rubi = nil;
    [romanName release], romanName = nil;
    [address release], address = nil;
    [telephone release], telephone = nil;
    [shopHours release], shopHours = nil;
    [holidayWeekdays release], holidayWeekdays = nil;
    [holidayDays release], holidayDays = nil;
    [description release], description = nil;
    [introduction release], introduction = nil;
    [message release], message = nil;
    [recommendationInfo release], recommendationInfo = nil;
    [visitedDate release], visitedDate = nil;

    [super dealloc];
}

#pragma mark - 閉店中フラグの更新

// 自身の駅が現在閉店中であるかどうかのフラグを更新する
- (void)updateClosingFlag {
    isClosing = [self isClosingWithDate:[NSDate date]];
}

// 指定された日時において、自身の駅が閉店中であるかどうかを返す
- (BOOL)isClosingWithDate:(NSDate *)date {
    // 営業時間データが空(→営業時間が存在しない)である場合は、YESを返す
    if (!shopHours || [shopHours count] == 0) return YES;
    
    // 指定された日時の月・日・時間・分・週番号・曜日番号を取得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = (NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSHourCalendarUnit | NSMinuteCalendarUnit |
                             NSWeekCalendarUnit | NSWeekdayCalendarUnit);
    NSDateComponents *dateComponents = [calendar components:components fromDate:date];
    int month = dateComponents.month;
    int day = dateComponents.day;
    int hour = dateComponents.hour;
    int minute = dateComponents.minute;
    int week = dateComponents.week;
    int weekday = dateComponents.weekday;
    
    // 指定された日時が祝日であるかどうかを格納
    BOOL isTodayNationalHoliday = [[NationalHolidayManager getInstance] isNationalHolidayForMonth:month day:day];
    
    // 休日(曜日)データが空でない場合
    if (holidayWeekdays && [holidayWeekdays count] > 0) {
        // 各休日データを参照
        for (int i = 0; i < [holidayWeekdays count]; i++) {
            // 現在参照している休日データを格納
            HolidayWeekday *holidayWeekday = [holidayWeekdays objectAtIndex:i];
            
            // 現在参照している休日データの月が設定されている場合
            if (holidayWeekday.startMonth) {
                // 終了月が設定されている場合
                if (holidayWeekday.endMonth) {
                    // 開始月の値が終了月以下である場合
                    if (holidayWeekday.startMonth <= holidayWeekday.endMonth) {
                        // 現在の月が開始月未満または終了月を超えている場合は、次の要素に処理を移す
                        if (month < holidayWeekday.startMonth || month > holidayWeekday.endMonth) continue;
                        // 開始月の値の方が大きい場合(年跨ぎ)
                    } else {
                        // 現在の月が開始月未満かつ終了月を超えている場合は、次の要素に処理を移す
                        if (month < holidayWeekday.startMonth && month > holidayWeekday.endMonth) continue;
                    }
                    // 設定されていない場合
                } else {
                    // 現在の月と開始月が異なっている場合は、次の要素に処理を移す
                    if (month != holidayWeekday.startMonth) continue;
                }
                // 月が設定されておらず、他に休日データが存在する(→他の休日データの適用対象月以外の月が適用対象)場合
            } else if ([holidayWeekdays count] > 1) {
                // 対象外の月であるかどうかを格納
                BOOL isExemptMonth = NO;
                
                // 各休日データを参照
                for (int j = 0; j < [holidayWeekdays count]; j++) {
                    // 自分自身を参照している場合は、次の要素に処理を移す
                    if (j == i) continue;
                    
                    // 例外対象の休日データを格納
                    HolidayWeekday *exceptionalHolidayWeekday = [holidayWeekdays objectAtIndex:j];
                    
                    // 月が設定されていない場合は、次の要素に処理を移す
                    if (!exceptionalHolidayWeekday.startMonth) continue;
                    
                    // 開始月の値が終了月以下である場合
                    if (exceptionalHolidayWeekday.startMonth <= exceptionalHolidayWeekday.endMonth) {
                        // 現在の月が開始月から終了月の間にある場合は、対象外月フラグを設定してループから抜ける
                        if (month >= exceptionalHolidayWeekday.startMonth && month <= exceptionalHolidayWeekday.endMonth) {
                            isExemptMonth = YES;
                            break;
                        }
                        // 開始月の値の方が大きい場合(年跨ぎ)
                    } else {
                        // 現在の月が開始月以上(12月以下)または(1月以上)終了月以下である場合は、対象外月フラグを設定してループから抜ける
                        if (month >= exceptionalHolidayWeekday.startMonth || month <= exceptionalHolidayWeekday.endMonth) {
                            isExemptMonth = YES;
                            break;
                        }
                    }
                }
                
                // 対象外月フラグが設定されている場合は、次の要素に処理を移す
                if (isExemptMonth) continue;
            }
            
            // 土日祝以外フラグが設定されている場合
            if (holidayWeekday.exceptHoliday) {
                // 今日が土日祝のいずれかである場合は、次の要素に処理を移す
                if (weekday == 1 || weekday == 7 || isTodayNationalHoliday) continue;
                // 設定されていない場合
            } else {
                // 週が設定されている場合
                if (holidayWeekday.startWeek) {
                    // 終了週が設定されている場合
                    if (holidayWeekday.endWeek) {
                        // 現在の週が開始週未満または終了週を超えている場合は、次の要素に処理を移す
                        if (week < holidayWeekday.startWeek || week > holidayWeekday.endWeek) continue;
                        // 設定されていない場合
                    } else {
                        // 現在の週が開始週でない場合は、次の要素に処理を移す
                        if (week != holidayWeekday.startWeek) continue; 
                    }
                }
                
                // 終了曜日が設定されている場合
                // (※1 土日祝以外フラグが設定されていないデータは、開始曜日が設定されているものとして処理する)
                // (※2 終了曜日が設定されている(曜日が複数)場合は、「祝祭日の場合は前日」「祝祭日の場合は翌日」フラグを無視する
                if (holidayWeekday.endWeekday) {
                    // 現在の曜日が開始曜日未満または終了曜日を超えている場合は、次の要素に処理を移す
                    if (weekday < holidayWeekday.startWeekday || weekday > holidayWeekday.endWeekday) continue;
                // 設定されていない場合
                } else {
                    // 現在の曜日が開始曜日と等しい場合
                    if (weekday == holidayWeekday.startWeekday) {
                        // 今日が祝日で、「祝祭日の場合は前日」フラグまたは「祝祭日の場合は翌日」フラグが設定されている場合は、次の要素に処理を移す
                        if (isTodayNationalHoliday && (holidayWeekday.isPreviousDayIfNationalHoliday || holidayWeekday.isNextDayIfNationalHoliday)) continue;
                    // 異なっている場合
                    } else {
                        // 「祝祭日の場合は前日」フラグと「祝祭日の場合は翌日」フラグが共に設定されていない場合は、次の要素に処理を移す
                        if (!holidayWeekday.isPreviousDayIfNationalHoliday && !holidayWeekday.isNextDayIfNationalHoliday) continue;
                        
                        // 「祝祭日の場合は前日」フラグが設定されていて明日の曜日と開始曜日が異なる、または「祝祭日の場合は翌日」フラグが設定されていて昨日の曜日と開始曜日が異なる場合は、次の要素に処理を移す
                        if ((holidayWeekday.isPreviousDayIfNationalHoliday && (weekday + 1) != holidayWeekday.startWeekday)
                            || (holidayWeekday.isNextDayIfNationalHoliday && (weekday - 1) != holidayWeekday.startWeekday)) continue;
                        
                        // 対象日の日データを生成
                        NSDateComponents *addingDayDateComponents = [[NSDateComponents alloc] init];
                        addingDayDateComponents.day = holidayWeekday.isPreviousDayIfNationalHoliday ? 1 : -1;
                        NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                       fromDate:[calendar dateByAddingComponents:addingDayDateComponents toDate:[NSDate date] options:0]];
                        [addingDayDateComponents release];

                        // 対象日が祝日でない場合は、次の要素に処理を移す
                        if (![[NationalHolidayManager getInstance] isNationalHolidayForMonth:dateComponents.month day:dateComponents.day]) continue;
                    }
                }
            }
            
            // ここまでの条件を満たしていない場合は、今日は休日と見なし、YESを返す
            return YES;
        }
    }
    
    // 休日(日)データが空でない場合
    if (holidayDays && [holidayDays count] > 0) {
        // 各休日データを参照
        for (HolidayDay *holidayDay in holidayDays) {
            // 指定された日時の月日が、現在参照している休日データの範囲内に入っている場合は、YESを返す
            if([self isInRangeWithMonth:month day:day 
                             startMonth:holidayDay.startMonth endMonth:holidayDay.endMonth 
                               startDay:holidayDay.startDay endDay:holidayDay.endDay beyondMonth:holidayDay.beyondMonth]) {
                return YES;
            }
        }
    }
    
    // 標準の営業時間データと現在の営業時間データを格納
    ShopHour *defaultShopHour = nil;
    ShopHour *currentShopHour = nil;
    
    // 各営業時間データを参照
    for (ShopHour *shopHour in shopHours) {
        // 現在参照している営業時間データに月と曜日が設定されていない場合
        if (!shopHour.startMonth && !shopHour.startWeekday && !shopHour.isHoliday) {
            // 営業時間データを通常の営業時間データとして格納し、次の要素に処理を移す
            defaultShopHour = shopHour;
            continue;
        }
        
        // 現在の月日が、現在参照している営業時間データの範囲内に入っていない場合は、次の要素に処理を移す
        if(![self isInRangeWithMonth:month day:day 
                          startMonth:shopHour.startMonth endMonth:shopHour.endMonth 
                            startDay:shopHour.startDay endDay:shopHour.endDay beyondMonth:shopHour.beyondMonth]) continue;        
        
        // 曜日が設定されている場合
        if (shopHour.startWeekday) {
            // 終了曜日が設定されている場合
            if (shopHour.endWeekday) {
                // 現在の曜日が開始曜日に達していないか終了曜日を超えている場合は、次の要素に処理を移す
                if (weekday < shopHour.startWeekday || weekday > shopHour.endWeekday) continue;
                // 設定されていない場合
            } else {
                // 現在の曜日が開始曜日と異なる場合は、次の要素に処理を移す
                if (weekday != shopHour.startWeekday) continue;
            }
            // 曜日が設定されていないが、土日祝フラグが設定されている場合
        } else if (shopHour.isHoliday) {
            // 今日が土日祝以外である場合は、次の要素に処理を移す
            if (weekday != 7 && weekday != 1 && !isTodayNationalHoliday) continue;
        }
        
        // ここまで来た場合は、現在参照している営業時間データを現在の営業時間データとして設定し、ループから抜ける
        currentShopHour = shopHour;
        break;
    }
    
    // 営業中かどうかを格納
    BOOL isOpening = NO;
    
    // 現在の営業時間データが設定されていないが、標準の営業時間データが設定されている場合は、標準の営業時間データを現在の営業時間データとして設定
    if (!currentShopHour && defaultShopHour) currentShopHour = defaultShopHour;
    
    // 現在の営業時間データが設定されている場合
    if (currentShopHour) {
        // 現在時間が、現在の営業時間データの開店時間と閉店時間の間にあるかどうかで営業中フラグを設定
        isOpening = (((hour == currentShopHour.openingHour && minute >= currentShopHour.openingMinute) || hour > currentShopHour.openingHour)
                     && (hour < currentShopHour.closingHour || (hour == currentShopHour.closingHour && minute < currentShopHour.closingMinute)));
    }
    
    // 営業中でないかどうかを返す
    return !isOpening;
}

// 指定された月日が、指定された開始月・終了月・開始日・終了日・月跨ぎフラグの範囲内にあるかどうかを返す
- (BOOL)isInRangeWithMonth:(int)month day:(int)day
                startMonth:(int)startMonth endMonth:(int)endMonth 
                  startDay:(int)startDay endDay:(int)endDay 
               beyondMonth:(BOOL)beyondMonth {
    // 月跨ぎフラグが設定されている場合
    if (beyondMonth) {
        // 開始月の値が終了月以下である場合
        if (startMonth <= endMonth) {
            // 現在月が開始月で現在日が開始日を過ぎている、現在月が開始月を過ぎ終了月に達していない、または現在月が終了月で現在日が終了日を過ぎていない、のいずれかに該当する場合はYES、該当しない場合はNOを返す
            return ((month == startMonth && day >= startDay) || (month > startMonth && month < endMonth) || (month == endMonth && day <= endDay));
            // 開始月の値の方が大きい場合(年跨ぎ)
        } else {
            // 現在月が開始月で現在日が開始日を過ぎている、現在月が開始月を過ぎている、現在月が終了月に達していない、または現在月が終了月で現在日が終了日を過ぎていない、のいずれかに該当する場合はYES、該当しない場合はNOを返す
            return ((month == startMonth && day >= startDay) || month > startMonth || month < endMonth || (month == endMonth && day <= endDay));
        }
    }
    
    // 月が設定されている場合
    if (startMonth) {
        // 終了月が設定されている場合
        if (endMonth) {
            // 開始月の値が終了月以下である場合
            if (startMonth <= endMonth) {
                // 現在の月が開始月未満または終了月を超えている場合は、NOを返す
                if (month < startMonth || month > endMonth) return NO;
                // 開始月の値の方が大きい場合(年跨ぎ)
            } else {
                // 現在の月が(1月以上)開始月未満かつ終了月を超えている(12月以下)場合は、NOを返す
                if (month < startMonth && month > endMonth) return NO;
            }
            // 設定されていない場合
        } else {
            // 現在の月と開始月が等しくない場合は、NOを返す
            if (month != startMonth) return NO;
        }
    }
    
    // 日が設定されている場合
    if (startDay) {
        // 終了日が設定されている場合
        if (endDay) {
            // 現在の日が開始日未満または終了日を超えている場合は、NOを返す
            if (day < startDay || day > endDay) return NO;
            // 設定されていない場合
        } else {
            // 現在の日が開始日と異なる場合は、NOを返す
            if (day != startDay) return NO; 
        }
    }
    
    // ここまで来たらYESを返す
    return YES;
}

#pragma mark - 文字列の生成

// 営業時間データから営業時間表示欄に設定する文字列を生成し、それを返す
- (NSString *)shopHoursString {
    // 営業時間データが空の場合は、nilを返す
    if ([shopHours count] == 0) return nil;
    
    // 営業時間の文字列の集合を格納
    NSMutableArray *shopHourStringArray = [[NSMutableArray alloc] initWithCapacity:[shopHours count]];
    
    // 通常の営業時間の文字列を格納
    NSString *defaultShopHourString = nil;
    
    // 営業時間データの各要素が使用されたかどうかを格納
    NSMutableArray *areShopHourElementsUsed = [[NSMutableArray alloc] initWithCapacity:[shopHours count]];
    for (int i = 0; i < [shopHours count]; i++) [areShopHourElementsUsed addObject:[NSNumber numberWithBool:NO]];
    
    // 営業時間データの各要素を参照
    for (int i = 0; i < [shopHours count]; i++) {
        // 参照対象の休日データが既に使用されている場合は、次の要素に処理を移す
        if ([((NSNumber *) [areShopHourElementsUsed objectAtIndex:i]) boolValue]) continue;
        
        // 現在参照している休日データを格納
        ShopHour *shopHour = [shopHours objectAtIndex:i];
        
        // 営業時間の文字列を格納
        NSMutableString *shopHourString = [NSMutableString stringWithFormat:SHOP_HOUR_TEXT_FORMAT, 
                                           shopHour.openingHour, shopHour.openingMinute, shopHour.closingHour, shopHour.closingMinute];
        
        // コメントを格納
        NSString *commentWithShopHour = [self commentWithShopHour:shopHour];
        NSMutableString *comment = [NSMutableString stringWithString:!commentWithShopHour ? @"" : commentWithShopHour];
        
        // 現在参照している営業時間データの次以降の各要素を参照
        for (int j = i + 1; j < [shopHours count]; j++) {
            // 比較対象の営業時間データが既に使用されている場合は、次の要素に処理を移す
            if ([((NSNumber *) [areShopHourElementsUsed objectAtIndex:j]) boolValue]) continue;
            
            // 比較対象の営業時間データを格納
            ShopHour *comparingShopHour = [shopHours objectAtIndex:j];
            
            // 比較対象の営業時間データの開店時間と閉店時間が、元の営業時間データと等しい場合
            if (comparingShopHour.openingHour == shopHour.openingHour &&
                comparingShopHour.openingMinute == shopHour.openingMinute &&
                comparingShopHour.closingHour == shopHour.closingHour &&
                comparingShopHour.closingMinute == shopHour.closingMinute) {
                // 比較対象の休日データのコメントが生成できた場合、コメントに追加
                NSString *comparingShopHourComment = [self commentWithShopHour:comparingShopHour];
                if (comparingShopHourComment) [comment appendStringWithBulletIfNotEmpty:comparingShopHourComment];
                
                // 比較対象の営業時間データに使用フラグを設定
                [areShopHourElementsUsed replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
            }
        }
        
        // 現在参照している営業時間データにコメントが設定されている場合は、コメントを文字列に追加
        if (shopHour.comment) [comment appendStringWithBulletIfNotEmpty:shopHour.comment];
        
        // コメントが空の場合
        if (comment.length == 0) {
            // 営業時間データが2つ以上存在する場合
            if ([shopHours count] > 1) {
                // 現在の営業時間の文字列を標準の営業時間の文字列として格納
                defaultShopHourString = [NSString stringWithFormat:STANDARD_ITEM_TEXT_FORMAT, shopHourString];
                // 1つのみの場合
            } else {
                // 営業時間の文字列を集合に追加
                [shopHourStringArray addObject:shopHourString];
            }
            // 空でない場合
        } else {
            // コメントを追加した営業時間の文字列を集合に追加
            [shopHourString appendFormat:@"(%@)", comment];
            [shopHourStringArray addObject:shopHourString];
        }
    }
    
    // 通常の営業時間の文字列が設定されている場合は、集合に追加する
    if (defaultShopHourString) [shopHourStringArray addObject:defaultShopHourString];
    
    // 営業時間の文字列の集合から文字列を生成
    NSMutableString *shopHourStrings = [NSMutableString string];
    for (NSString *shopHourString in shopHourStringArray) [shopHourStrings appendStringWithBreakCodeIfNotEmpty:shopHourString];
    
    // オブジェクトを解放
    [areShopHourElementsUsed release];
    [shopHourStringArray release];
    
    return shopHourStrings;
}

// 休日データから休日表示欄に表示する文字列を生成し、それを返す
- (NSString *)holidaysString {
    // 選択されている駅の休日データが空の場合は、年中無休として文字列を返す
    if ([holidayWeekdays count] == 0 && [holidayDays count] == 0) return NO_HOLIDAY_TEXT;
    
    // 休日の文字列の集合を格納
    NSMutableArray *holidayStringArray = [[NSMutableArray alloc] initWithCapacity:[holidayWeekdays count] + [holidayDays count]];
    
    // 休日データ(曜日)の各要素が使用されたかどうかを格納
    NSMutableArray *areHolidayWeekdayElementsUsed = [[NSMutableArray alloc] initWithCapacity:[holidayWeekdays count]];
    for (int i = 0; i < [holidayWeekdays count]; i++) [areHolidayWeekdayElementsUsed addObject:[NSNumber numberWithBool:NO]];
    
    // 通常の営業時間の文字列を格納
    NSString *defaultHolidayWeekdayString = nil;
    
    // 休日(曜日)データの各要素を参照
    for (int i = 0; i < [holidayWeekdays count]; i++) {
        // 参照対象の休日データが既に使用されている場合は、次の要素に処理を移す
        if ([((NSNumber *) [areHolidayWeekdayElementsUsed objectAtIndex:i]) boolValue]) continue;
        
        // 現在参照している休日データを格納
        HolidayWeekday *holidayWeekday = [holidayWeekdays objectAtIndex:i];
        
        // 休日の文字列を格納
        NSMutableString *holidayString = [[NSMutableString alloc] initWithCapacity:1];
        
        // 現在参照している休日データに土日祝以外フラグが設定されていない場合
        if (!holidayWeekday.exceptHoliday) {
            // 開始週が設定されている場合
            if (holidayWeekday.startWeek) {
                // 開始週の文字列を休日の文字列に追加
                [holidayString appendString:[NSString stringWithFormat:@"第%d", holidayWeekday.startWeek]];
                
                // 終了週が設定されている場合は、終了週の文字列を休日の文字列に追加
                if (holidayWeekday.endWeek) {
                    [holidayString appendString:[NSString stringWithFormat:@"〜%d", holidayWeekday.endWeek]];
                }
            }
            
            // 現在参照している休日データの次以降の各要素を参照
            for (int j = i + 1; j < [holidayWeekdays count]; j++) {
                // 比較対象の休日データが既に使用されている場合は、次の要素に処理を移す
                if ([((NSNumber *) [areHolidayWeekdayElementsUsed objectAtIndex:j]) boolValue]) continue;
                
                // 比較対象の休日データを格納
                HolidayWeekday *comparingHolidayWeekday = [holidayWeekdays objectAtIndex:j];
                
                // 比較対象の休日データの曜日と月の要素が、元の休日データと等しい場合
                if (comparingHolidayWeekday.startWeekday == holidayWeekday.startWeekday &&
                    comparingHolidayWeekday.endWeekday == holidayWeekday.endWeekday &&
                    comparingHolidayWeekday.startMonth == holidayWeekday.startMonth && 
                    comparingHolidayWeekday.endMonth == holidayWeekday.endMonth) {
                    
                    // 比較対象の休日データの開始週の文字列を休日の文字列に追加
                    [holidayString appendString:[NSString stringWithFormat:@"・%d", comparingHolidayWeekday.startWeek]];
                    
                    // 比較対象の休日データに終了週が設定されている場合は、終了週の文字列を休日の文字列に追加
                    if (comparingHolidayWeekday.endWeek) {
                        [holidayString appendString:[NSString stringWithFormat:@"〜%d", comparingHolidayWeekday.endWeek]];
                    }
                    
                    // 比較対象の休日データに使用フラグを設定
                    [areHolidayWeekdayElementsUsed replaceObjectAtIndex:j withObject:[NSNumber numberWithBool:YES]];
                }
            }
        }
        
        // 曜日の文字列を休日の文字列に追加
        [holidayString appendString:[self weekdayStringWithHolidayWeekday:holidayWeekday]];
        
        // コメントを取得
        NSString *comment = [self commentWithHolidayWeekday:holidayWeekday];
        
        // コメントが空の場合
        if (!comment) {
            // 休日(曜日)データが2つ以上存在する場合
            if ([holidayWeekdays count] > 1) {
                // 現在の休日の文字列を標準の営業時間の文字列として格納
                defaultHolidayWeekdayString = [NSString stringWithFormat:STANDARD_ITEM_TEXT_FORMAT, holidayString];
            // 1つのみの場合
            } else {
                // 休日の文字列を集合に追加
                [holidayStringArray addObject:holidayString];
            }
            // 空でない場合
        } else {
            // コメントを追加した休日の文字列を集合に追加
            [holidayString appendFormat:@"(%@)", comment];
            [holidayStringArray addObject:holidayString];
        }
        
        // オブジェクトを解放
        [holidayString release];
    }
    
    // 通常の休日(曜日)の文字列が設定されている場合は、集合に追加
    if (defaultHolidayWeekdayString) [holidayStringArray addObject:defaultHolidayWeekdayString];
    
    // 各休日データ(日)を参照
    for (HolidayDay *holidayDay in holidayDays) {
        //        NSLog(@"startMonth: %d, endMonth: %d, startDay: %d, endDay: %d, beyondMonth: %d, comment: %@", 
        //              holidayDay.startMonth, holidayDay.endMonth, holidayDay.startDay, holidayDay.endDay, holidayDay.beyondMonth, holidayDay.comment);
        
        // 休日(日)の文字列を格納
        NSMutableString *holidayDayString = [[NSMutableString alloc] initWithCapacity:1];
        
        // 日付の文字列を追加
        NSString *dateString = [self dateStringWithStartMonth:holidayDay.startMonth endMonth:holidayDay.endMonth
                                                       startDay:holidayDay.startDay endDay:holidayDay.endDay
                                                    beyondMonth:holidayDay.beyondMonth];
        [holidayDayString appendString:dateString];
        
        // 現在参照している休日データにコメントが設定されている場合は、コメントを文字列に追加
        if (holidayDay.comment) [holidayDayString appendString:[NSString stringWithFormat:@"(%@)", holidayDay.comment]];
        
        // 文字列を集合に追加
        [holidayStringArray addObject:holidayDayString];
        [holidayDayString release];
    }
    
    // 休日の文字列の集合から文字列を生成
    NSMutableString *holidayStrings = [NSMutableString string];
    for (NSString *holidayString in holidayStringArray) [holidayStrings appendStringWithBreakCodeIfNotEmpty:holidayString];
    
    // オブジェクトを解放
    [areHolidayWeekdayElementsUsed release];
    [holidayStringArray release];
    
    return holidayStrings;
}

// 指定された値から日付に関する文字列を生成し、それを返す
- (NSString *)dateStringWithStartMonth:(int)startMonth endMonth:(int)endMonth startDay:(int)startDay endDay:(int)endDay beyondMonth:(BOOL)beyondMonth {
    // 開始月が設定されていない場合は、nilを返す
    if (!startMonth) return nil; 
    
    // コメントを格納
    NSMutableString *comment = [NSMutableString stringWithCapacity:1];
    
    // 月跨ぎフラグが設定されている場合
    if (beyondMonth) {
        // 複数日・月跨ぎの文字列を設定
        [comment appendString:[NSString stringWithFormat:@"%d月%d日〜%d月%d日", startMonth, startDay, endMonth, endDay]];
    // 月跨ぎフラグが設定されておらず、開始日が設定されていない場合
    } else if (!startDay) {
        // 終了月が設定されているかに応じた月の文字列を追加
        [comment appendString:(!endMonth) ? [NSString stringWithFormat:@"%d月", startMonth]
                             : [NSString stringWithFormat:@"%d月〜%d月", startMonth, endMonth]];
    // 上記に該当しない場合
    } else {
        // 終了月が設定されていない場合は、開始月が設定されているかどうかに応じた月の文字列を追加
        if (!endMonth) [comment appendString:(!startMonth) ? @"毎月" : [NSString stringWithFormat:@"%d月", startMonth]];
        
        // 終了日が設定されているかどうかに応じた日の文字列を追加
        [comment appendString:(!endDay) ? [NSString stringWithFormat:@"%d日", startDay] : [NSString stringWithFormat:@"%d日〜%d日", startDay, endDay]];
        
        // 終了月が設定されている場合は、開始月〜終了月の文字列を追加
        if (endMonth) [comment appendString:[NSString stringWithFormat:@"(%d月〜%d月)", startMonth, endMonth]];
    }
    
    return comment;
}

// 指定された営業時間データからコメントを生成し、それを返す
- (NSString *)commentWithShopHour:(ShopHour *)shopHour {
    // コメントを格納
    NSMutableString *comment = [NSMutableString string];
    
    // 日付のコメントを取得
    NSString *dateComment = [self dateStringWithStartMonth:shopHour.startMonth endMonth:shopHour.endMonth
                                                  startDay:shopHour.startDay endDay:shopHour.endDay beyondMonth:shopHour.beyondMonth];
    
    // 曜日のコメントを格納
    NSMutableString *weekdayComment = [[NSMutableString alloc] init];
    
    // 曜日が設定されている場合
    if (shopHour.startWeekday) {
        // 開始曜日の値に該当する曜日を曜日コメントに追加
        [weekdayComment appendFormat:@"%@曜日", [[Utility getInstance].weekdayCharacters objectAtIndex:shopHour.startWeekday - 1]];
        
        // 終了曜日の値が設定されている場合は、終了曜日の値に該当する曜日を曜日コメントに追加
        if (shopHour.endWeekday) {
            [weekdayComment appendFormat:@"〜%@曜日", [[Utility getInstance].weekdayCharacters objectAtIndex:shopHour.endWeekday - 1]];
        }
    // 曜日が設定されていないが、土日祝フラグが設定されている場合
    } else if (shopHour.isHoliday) {
        // 土日祝祭日の文字列を曜日コメントに追加
        [weekdayComment appendString:SHOP_HOUR_HOLIDAY_TEXT];
    }
    
    // 日付のコメントが取得できた場合
    if (dateComment) {
        // 日付のコメントをコメントに追加
        [comment appendString:dateComment];
        
        // 曜日コメントが設定されている場合は、曜日コメントをコメントに追加
        if (weekdayComment.length > 0) [comment appendFormat:@"の%@", weekdayComment];
    // 取得できなかった場合
    } else {
        // 曜日コメントが設定されていない場合
        if (weekdayComment.length == 0) {
            // コメントをnilに設定
            comment = nil;
        // 設定されている場合
        } else {
            // 曜日コメントをコメントに設定
            [comment appendString:weekdayComment];
        }
    }
    
    // オブジェクトを解放
    [weekdayComment release];
    
    return comment;
}

// 指定された休日(曜日)データから曜日の文字列を生成し、それを返す
- (NSString *)weekdayStringWithHolidayWeekday:(HolidayWeekday *)holidayWeekday {
    // 指定された休日(曜日)データに土日祝以外フラグが設定されている場合
    if (holidayWeekday.exceptHoliday) {
        // 土日祝以外の文字列を返す
        return EXCEPT_HOLIDAY_TEXT;
        // 設定されていない場合
    } else {
        // 開始曜日の値に該当する曜日の文字を格納
        NSString *weekdayCharacter = [[Utility getInstance].weekdayCharacters objectAtIndex:holidayWeekday.startWeekday - 1];
        
        // 終了曜日が設定されているかどうかに応じて異なる文字列を返す
        if (holidayWeekday.endWeekday) {
            NSString *endWeekdayCharacter = [[Utility getInstance].weekdayCharacters objectAtIndex:holidayWeekday.endWeekday - 1];
            return [NSString stringWithFormat:@"%@〜%@曜日", weekdayCharacter, endWeekdayCharacter];
        } else {
            return [NSString stringWithFormat:@"%@曜日", weekdayCharacter];
        }
    }
}

// 指定された休日(曜日)データからコメントを生成し、それを返す
- (NSString *)commentWithHolidayWeekday:(HolidayWeekday *)holidayWeekday {
    // 開始月、祝祭日の前日フラグ、祝祭日の明日フラグ、コメントの全てが設定されていない場合は、nilを返す
    if (!holidayWeekday.startMonth
        && !holidayWeekday.isPreviousDayIfNationalHoliday && !holidayWeekday.isNextDayIfNationalHoliday
        && !holidayWeekday.comment) return nil;
    
    // コメントを格納
    NSMutableString *comment = [NSMutableString string];
    
    // 開始月が設定されている場合
    if (holidayWeekday.startMonth) {
        // 開始月の文字列をコメントに追加
        [comment appendString:[NSString stringWithFormat:@"%d月", holidayWeekday.startMonth]];
        
        // 終了月が設定されている場合は、終了月の文字列をコメントに追加
        if (holidayWeekday.endMonth) {
            [comment appendString:[NSString stringWithFormat:@"〜%d月", holidayWeekday.endMonth]];
        }
    }
    
    // 「祝祭日の場合は前日」フラグまたは祝祭日の場合は翌日」フラグが設定されている場合
    if (holidayWeekday.isPreviousDayIfNationalHoliday || holidayWeekday.isNextDayIfNationalHoliday) {
        // 文字列をコメントに追加
        [comment appendStringWithBulletIfNotEmpty:(holidayWeekday.isPreviousDayIfNationalHoliday) ? PREVIOUS_DAY_IF_NATIONAL_HOLIDAY_TEXT
                                                 : NEXT_DAY_IF_NATIONAL_HOLIDAY_TEXT];
    }
    
    // 休日データのコメントが設定されている場合は、休日データのコメントをコメントを追加
    if (holidayWeekday.comment) [comment appendStringWithBulletIfNotEmpty:holidayWeekday.comment];
    
    return comment;
}
        
@end
