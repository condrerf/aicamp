//
//  HolidayDay.h
//  MichiNoEki
//
//  Created by  on 11/09/06.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 休日(日)データ
@interface HolidayDay : NSObject {
    int startMonth;
    int endMonth;
    int startDay;
    int endDay;
    BOOL beyondMonth;
    NSString *comment;
}

@property (nonatomic) int startMonth;
@property (nonatomic) int endMonth;
@property (nonatomic) int startDay;
@property (nonatomic) int endDay;
@property (nonatomic) BOOL beyondMonth;
@property (nonatomic, copy) NSString *comment;

@end
