//
//  HolidayDay.m
//  MichiNoEki
//
//  Created by  on 11/09/06.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HolidayDay.h"

@implementation HolidayDay

@synthesize startMonth;
@synthesize endMonth;
@synthesize startDay;
@synthesize endDay;
@synthesize beyondMonth;
@synthesize comment;

// 終端処理
- (void)dealloc {
    // 各オブジェクトの解放
    [comment release], comment = nil;
    
    [super dealloc];
}

@end
