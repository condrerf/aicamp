//
//  NationalHolidayManager.h
//  MichiNoEki
//
//  Created by  on 11/09/12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 祝日管理クラス
@interface NationalHolidayManager : NSObject {
    NSMutableArray *nationalHolidayBaseData_;
    NSMutableArray *nationalHolidays_;
    int updatedYear_;
}

+ (NationalHolidayManager *)getInstance;
- (BOOL)tryUpdatingNationalHolidays;
- (BOOL)isNationalHolidayForMonth:(int)month day:(int)day;

@end
