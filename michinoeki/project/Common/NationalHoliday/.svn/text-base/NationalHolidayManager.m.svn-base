//
//  NationalHolidayManager.m
//  MichiNoEki
//
//  Created by  on 11/09/12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NationalHolidayManager.h"
#import "Constants.h"
#import "NationalHoliday.h"

// 日データ
typedef struct {
    int month;
    int day;
} Day;

// 非公開メソッドのカテゴリ
@interface NationalHolidayManager(PrivateMethods)
- (void)updateNationalHolidaysWithYear:(int)year;
- (NationalHoliday *)springEquinoxDay;
- (NationalHoliday *)autumnEquinoxDay;
- (NationalHoliday *)nationalHolidayWithDay:(Day)day;
@end

@implementation NationalHolidayManager

// 自身のインスタンス
static NationalHolidayManager *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (NationalHolidayManager *) getInstance {
    // インスタンスが生成されていない場合は生成 // 位置情報が取得可能か
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
        // プロパティリストのデータを取得
        NSString *propertyListFilePath = [[NSBundle mainBundle] pathForResource:NATIONAL_HOLIDAY_PROPERTY_LIST_NAME ofType:@"plist"];
        NSArray *propertyListDataArray = [[NSDictionary dictionaryWithContentsOfFile:propertyListFilePath] objectForKey:@"ROOT"];
        
        // プロパティリストのデータを祝日基本データに追加
        nationalHolidayBaseData_ = [[NSMutableArray alloc] initWithCapacity:[propertyListDataArray count]];
        
        for (NSDictionary *propetyListData in propertyListDataArray) {
            NationalHoliday *nationalHoliday = [[NationalHoliday alloc] init];
            nationalHoliday.month = [[propetyListData valueForKey:@"month"] intValue];
            nationalHoliday.week = [[propetyListData valueForKey:@"week"] intValue];
            nationalHoliday.weekday = [[propetyListData valueForKey:@"weekday"] intValue];
            nationalHoliday.day = [[propetyListData valueForKey:@"day"] intValue];
            nationalHoliday.name = [propetyListData valueForKey:@"name"];
            [nationalHolidayBaseData_ addObject:nationalHoliday];
            [nationalHoliday release];
        }
        
        // 春分の日と秋分の日の祝日データを祝日基本データに追加
        [nationalHolidayBaseData_ addObject:[self springEquinoxDay]];
        [nationalHolidayBaseData_ addObject:[self autumnEquinoxDay]];
        
        // 祝日データの集合を生成
        nationalHolidays_ = [[NSMutableArray alloc] init];
        
        // 祝日データを更新
        [self updateNationalHolidaysWithYear:[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]].year];
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [nationalHolidayBaseData_ release], nationalHolidayBaseData_ = nil;
    [nationalHolidays_ release], nationalHolidays_ = nil;
    [instance release], instance = nil;

    [super dealloc];
}

// 祝日データの更新を試行する
- (BOOL)tryUpdatingNationalHolidays {
    // 現在の年を取得
    int presentYear = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]].year;

    // 現在の年が、更新された年と異なる場合
    if (presentYear != updatedYear_) {
        // 現在の年で祝日データを更新してYESを返す
        [self updateNationalHolidaysWithYear:presentYear];
        return YES;
    // 等しい場合
    } else {
        // NOを返す
        return NO;
    }
}

// 指定された年の祝日データを生成し、そのデータで更新する(※年が変わった時に更新する必要がある)
- (void)updateNationalHolidaysWithYear:(int)year {
    // カレンダーオブジェクトを取得
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 祝日基本データから祝日データの集合を生成
    [nationalHolidays_ removeAllObjects];
    [nationalHolidays_ addObjectsFromArray:nationalHolidayBaseData_];
    
    // 祝日の各日付データを格納
    NSMutableArray *nationalHolidayDates = [[NSMutableArray alloc] initWithCapacity:[nationalHolidays_ count]];
    
    // 祝日データの各要素を参照
    for (NationalHoliday *nationalHoliday in nationalHolidays_) {
        // 日付データを格納
        NSDate *date;
        
        // 現在参照している祝日データに日が設定されていない(「第x週のy曜日」と規定されている)場合
        if (!nationalHoliday.day) {
            // 設定されている年・月の1日の日付データを生成
            NSDateComponents *baseDateComponents = [[NSDateComponents alloc] init];
            baseDateComponents.year = year;
            baseDateComponents.month = nationalHoliday.month;
            baseDateComponents.day = 1;
            NSDate *baseDate = [calendar dateFromComponents:baseDateComponents];
            [baseDateComponents release];
            
            // 1日の日付情報を取得
            baseDateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit) fromDate:baseDate];
            
            // 1日の日付データの週番号・曜日番号から祝日データの週番号・曜日番号までの差を日に加算した日付データを設定
            NSDateComponents *dayDifferenceDateComponents = [[NSDateComponents alloc] init];
            
            if (baseDateComponents.weekday > nationalHoliday.weekday) {
                dayDifferenceDateComponents.day = ((nationalHoliday.week - 1) * 7) + ((7 - baseDateComponents.weekday) + nationalHoliday.weekday);
            } else {
                dayDifferenceDateComponents.day = ((nationalHoliday.week - 1) * 7) + (nationalHoliday.weekday - baseDateComponents.weekday);
            }
            
            date = [calendar dateByAddingComponents:dayDifferenceDateComponents toDate:baseDate options:0];
            [dayDifferenceDateComponents release];
            
            // 生成した日付データの日を、現在参照している祝日データに設定
            nationalHoliday.day = [calendar components:NSDayCalendarUnit fromDate:date].day;
        // 日が設定されている場合
        } else {
            // 年月日から日付データを生成
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year = year;
            dateComponents.month = nationalHoliday.month;
            dateComponents.day = nationalHoliday.day;
            date = [calendar dateFromComponents:dateComponents];
            [dateComponents release];
        }
        
        // 日付データを日付データの集合に追加
        [nationalHolidayDates addObject:date];
    }

    // 国民の休日(祝日と祝日の間に挟まされた平日)の祝日データを格納
    NSMutableArray *additionalNationalHolidays = [[NSMutableArray alloc] init];

    // 祝日データの内、最後以外の各要素を参照(処理内容上、最後の要素は確認する必要がないため)
    for (int i = 0; i < [nationalHolidays_ count] - 1; i++) {
        // 現在参照している祝日データが9月でない場合は、次の要素に処理を移す
        // (※現時点では国民の休日が発生する可能性があるのは9月のみであるため)
        if (((NationalHoliday *) [nationalHolidays_ objectAtIndex:i]).month != 9) continue;

        // 現在参照している祝日データに該当する日付データを格納
        NSDate *nationalHolidayDate = [nationalHolidayDates objectAtIndex:i];
        
        // 一昨日の日データを生成
        NSDateComponents *addingDayDateComponents = [[NSDateComponents alloc] init];
        addingDayDateComponents.day = -2;
        NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit)
                                                       fromDate:[calendar dateByAddingComponents:addingDayDateComponents toDate:nationalHolidayDate options:0]];
        Day dayBeforeYesterday;
        dayBeforeYesterday.month = dateComponents.month;
        dayBeforeYesterday.day = dateComponents.day;
        
        // 明後日の日データを生成
        addingDayDateComponents.day = 2;
        dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:[calendar dateByAddingComponents:addingDayDateComponents toDate:nationalHolidayDate options:0]];
        Day dayAfterTomorrow;
        dayAfterTomorrow.month = dateComponents.month;
        dayAfterTomorrow.day = dateComponents.day;

        // オブジェクトを解放
        [addingDayDateComponents release];
        
        // 現在参照している祝日データの次以降の要素の祝日データを参照
        for (int j = i + 1; j < [nationalHolidays_ count]; j++) {
            // 比較対象の祝日データを格納
            NationalHoliday *comparingNationalHoliday = [nationalHolidays_ objectAtIndex:j];
            
            // 比較対象の祝日データが、現在参照している祝日データの一昨日または明後日である場合
            if ((comparingNationalHoliday.month == dayBeforeYesterday.month && comparingNationalHoliday.day == dayBeforeYesterday.day) ||
                (comparingNationalHoliday.month == dayAfterTomorrow.month && comparingNationalHoliday.day == dayAfterTomorrow.day)) {
                // 対象日の日データを生成
                NSDateComponents *addingDayDateComponents = [[NSDateComponents alloc] init];
                addingDayDateComponents.day = (comparingNationalHoliday.day == dayBeforeYesterday.day) ? -1 : 1;
                NSDateComponents *dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit)
                                                               fromDate:[calendar dateByAddingComponents:addingDayDateComponents toDate:nationalHolidayDate options:0]];
                Day targetday;
                targetday.month = dateComponents.month;
                targetday.day = dateComponents.day;
                [addingDayDateComponents release];
                
                // 対象日が祝日であるかどうかを格納
                BOOL isTargetDayNationalHoliday = NO;
                
                // 現在参照している祝日データの次以降の要素の祝日データを参照
                for (int k = i + 1; k < [nationalHolidays_ count]; k++) {
                    // 比較対象の祝日データを格納
                    NationalHoliday *comparingNationalHoliday2 = [nationalHolidays_ objectAtIndex:k];
                    
                    // 比較対象の祝日データが対象日である場合
                    if (comparingNationalHoliday2.month == targetday.month && comparingNationalHoliday2.day == targetday.day) {
                        // 祝日フラグを設定してループから抜ける
                        isTargetDayNationalHoliday = YES;
                        break;
                    }
                }
                
                // 対象日が祝日でない場合は、対象日を国民の休日として追加の祝日データの集合に追加
                if (!isTargetDayNationalHoliday) [additionalNationalHolidays addObject:[self nationalHolidayWithDay:targetday]];
            }
        }
    }
    
    // 追加の祝日データを祝日データの集合に追加
    [nationalHolidays_ addObjectsFromArray:additionalNationalHolidays];
    [additionalNationalHolidays release];
    
    // 祝日の日付データの集合を解放
    [nationalHolidayDates release];

    // 指定された年を更新された年に設定
    updatedYear_ = year;
}

// 指定された月・日が祝日であるかどうかを返す
- (BOOL)isNationalHolidayForMonth:(int)month day:(int)day {
    // 各祝日データを参照
    for (NationalHoliday *nationalHoliday in nationalHolidays_) {
        // 現在参照している祝日データが指定された日である場合は、YESを返す
        if (nationalHoliday.month == month && nationalHoliday.day == day) return YES;
    }
    
    // ここまで来たらNOを返す
    return NO;
}

// 春分の日の祝日データを返す
- (NationalHoliday *)springEquinoxDay {
    // 現在の年の春分の日の値を算出(※2150年まで有効)
    int year = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
    double additionalValue = (year <= 2099) ? 20.8431 : 21.851;
    int day = (int)(additionalValue + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));

    // 春分の日の祝日データを生成
    NationalHoliday *nationalHoliday = [[[NationalHoliday alloc] init] autorelease];
    nationalHoliday.month = 3;
    nationalHoliday.week = 0;
    nationalHoliday.weekday = 0;
    nationalHoliday.day = day;
    nationalHoliday.name = @"春分の日";

    return nationalHoliday;
}

// 秋分の日の祝日データを返す
- (NationalHoliday *)autumnEquinoxDay {
    // 現在の年の秋分の日の値を算出(※2150年まで有効)
    int year = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
    double additionalValue = (year <= 2099) ? 23.2488 : 24.2488;
    int day = (int)(additionalValue + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));

    // 秋分の日の祝日データを生成
    NationalHoliday *nationalHoliday = [[[NationalHoliday alloc] init] autorelease];
    nationalHoliday.month = 9;
    nationalHoliday.week = 0;
    nationalHoliday.weekday = 0;
    nationalHoliday.day = day;
    nationalHoliday.name = @"秋分の日";

    return nationalHoliday;
}

// 指定された日を国民の休日とした祝日データを返す
- (NationalHoliday *)nationalHolidayWithDay:(Day)day {
    NationalHoliday *nationalHoliday = [[[NationalHoliday alloc] init] autorelease];
    nationalHoliday.month = day.month;
    nationalHoliday.week = 0;
    nationalHoliday.weekday = 0;
    nationalHoliday.day = day.day;
    nationalHoliday.name = @"国民の休日";
    
    return nationalHoliday;
}

@end
