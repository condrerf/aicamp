//
//  ShopHour.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 営業時間データ
@interface ShopHour : NSObject {
    int openingHour;
    int openingMinute;
    int closingHour;
    int closingMinute;
    int startMonth;
    int endMonth;
    int startDay;
    int endDay;
    BOOL beyondMonth;
    int startWeekday;
    int endWeekday;
    BOOL isHoliday;
    NSString *comment;
}

@property (nonatomic) int openingHour;
@property (nonatomic) int openingMinute;
@property (nonatomic) int closingHour;
@property (nonatomic) int closingMinute;
@property (nonatomic) int startMonth;
@property (nonatomic) int endMonth;
@property (nonatomic) int startDay;
@property (nonatomic) int endDay;
@property (nonatomic) BOOL beyondMonth;
@property (nonatomic) int startWeekday;
@property (nonatomic) int endWeekday;
@property (nonatomic) BOOL isHoliday;
@property (nonatomic, retain) NSString *comment;

@end
