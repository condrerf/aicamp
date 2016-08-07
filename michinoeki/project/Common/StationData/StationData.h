//
//  StationData.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// 駅データ
@interface StationData : NSObject {
    int stationID;
    NSString *name;
    NSString *rubi;
    NSString *romanName;
    CLLocationCoordinate2D location;
    NSString *address;
    NSString *telephone;
    NSArray *shopHours;
    NSArray *holidayWeekdays;
    NSArray *holidayDays;
    NSString *description;
    NSString *introduction;
    NSString *message;
    NSString *recommendationInfo;
    NSDate *visitedDate;
    BOOL isClosing;
}

@property (nonatomic) int stationID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rubi;
@property (nonatomic, copy) NSString *romanName;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, retain) NSArray *shopHours;
@property (nonatomic, retain) NSArray *holidayWeekdays;
@property (nonatomic, retain) NSArray *holidayDays;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *recommendationInfo;
@property (nonatomic, retain) NSDate *visitedDate;
@property (nonatomic, readonly) BOOL isClosing;

- (BOOL)isClosingWithDate:(NSDate *)date;
- (void)updateClosingFlag;
- (NSString *)shopHoursString;
- (NSString *)holidaysString;

@end
