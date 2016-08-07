//
//  NationalHoliday.m
//  MichiNoEki
//
//  Created by  on 11/09/13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NationalHoliday.h"

@implementation NationalHoliday

@synthesize month;
@synthesize week;
@synthesize weekday;
@synthesize day;
@synthesize name;

// 終端処理
- (void)dealloc {
    // 各オブジェクトの解放
    [name release], name = nil;

    [super dealloc];
}

@end
