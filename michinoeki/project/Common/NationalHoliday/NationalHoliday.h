//
//  NationalHoliday.h
//  MichiNoEki
//
//  Created by  on 11/09/13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 祝日データクラス
@interface NationalHoliday : NSObject {
    int month;
    int week;
    int weekday;
    int day;
    NSString *name;
}

@property (nonatomic) int month;
@property (nonatomic) int week;
@property (nonatomic) int weekday;
@property (nonatomic) int day;
@property (nonatomic, copy) NSString *name;

@end
