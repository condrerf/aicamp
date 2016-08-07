//
//  HolidayWeekday.h
//  MichiNoEki
//
//  Created by  on 11/09/06.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 休日(曜日)データ
@interface HolidayWeekday : NSObject {
    int startWeekday;
    int endWeekday;
    int startMonth;
    int endMonth;
    int startWeek;
    int endWeek;
    BOOL exceptHoliday;
    BOOL isPreviousDayIfNationalHoliday;
    BOOL isNextDayIfNationalHoliday;
    NSString *comment;
}

@property (nonatomic) int startWeekday;
@property (nonatomic) int endWeekday;
@property (nonatomic) int startMonth;
@property (nonatomic) int endMonth;
@property (nonatomic) int startWeek;
@property (nonatomic) int endWeek;
@property (nonatomic) BOOL exceptHoliday;
@property (nonatomic) BOOL isPreviousDayIfNationalHoliday;
@property (nonatomic) BOOL isNextDayIfNationalHoliday;
@property (nonatomic, retain) NSString *comment;

@end
