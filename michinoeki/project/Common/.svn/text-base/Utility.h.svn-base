//
//  Utility.h
//  MichiNoEki
//
//  Created by  on 11/08/29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 各種処理を管理するクラス
@interface Utility : NSObject {
    NSMutableArray *weekdayCharacters;
    NSString *platform;
}

@property (nonatomic, readonly) NSArray *weekdayCharacters;
@property (nonatomic, readonly) NSString *platform;

+ (Utility *)getInstance;
- (void)showDialogWithMessage:(NSString *)message title:(NSString *)title;
- (void)showConfirmationDialogWithMessage:(NSString *)message tag:(int)tag delegate:(id)delegate;
- (void)showErrorDialog:(NSString *)message;
- (void)setAdjustFontSizeOfNavigationItem:(UINavigationItem *)navigationItem;
- (NSString *) photoDirectoryPathWithStationID:(int)stationID;

@end
