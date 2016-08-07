//
//  RouteInfoViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RouteInfoViewController.h"
#import "Constants.h"

@implementation RouteInfoViewController

@synthesize delegate;
@synthesize stationRoute;
@synthesize fromToLabel;
@synthesize distanceTimeLabel;
@synthesize estimatedArrivalTimeLabel;
@synthesize warningLabel;
@synthesize infoLabel;
@synthesize currentStepNumberLabel;
@synthesize stepCountLabel;
@synthesize backButton;
@synthesize forwardButton;
@synthesize closeButton;
@synthesize isOpening;

#pragma mark - 初期化・終端処理

- (id)init {
    self = [self initWithNibName:@"RouteInfo" bundle:nil];
    
    return self;
}

- (void)viewDidUnload {    
    // 各コントロールの解放
    [self setFromToLabel:nil];
    [self setDistanceTimeLabel:nil];
    [self setEstimatedArrivalTimeLabel:nil];
    [self setWarningLabel:nil];
    [self setInfoLabel:nil];
    [self setCurrentStepNumberLabel:nil];
    [self setStepCountLabel:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setCloseButton:nil];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [stationRoute release], stationRoute = nil;

    // 各コントロールの解放
    [fromToLabel release], fromToLabel = nil;
    [distanceTimeLabel release], distanceTimeLabel = nil;
    [estimatedArrivalTimeLabel release], estimatedArrivalTimeLabel = nil;
    [warningLabel release], warningLabel = nil;
    [infoLabel release], infoLabel = nil;
    [currentStepNumberLabel release], currentStepNumberLabel = nil;
    [stepCountLabel release], stepCountLabel = nil;
    [backButton release], backButton = nil;
    [forwardButton release], forwardButton = nil;
    [closeButton release], closeButton = nil;
    
    [super dealloc];
}

#pragma mark - イベント

// 画面がタップされた時に実行される処理
- (IBAction)viewTouchUp {
    // デリゲートオブジェクトが設定され、画面タップ時のメソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(RouteInfoViewTouched)]) [self.delegate RouteInfoViewTouched];
}

// 戻るボタンがタップされた時に実行される処理
- (IBAction)backButtonTouchUp {
    // 道程の索引を減算
    stepIndex_--;
    
    // 現在選択されている道程の情報を表示欄に設定
    infoLabel.text = [stationRoute informationWithStepIndex:stepIndex_];

    // 現在の道程番号表示欄に値を設定
    currentStepNumberLabel.text = [NSString stringWithFormat:@"%d", stepIndex_ + 1];

    // 道程が最初の場合は、戻るボタンを非表示にする
    if (stepIndex_ == 0) backButton.hidden = YES;

    // 進むボタンが非表示の場合は、進むボタンを表示する
    if (forwardButton.hidden) forwardButton.hidden = NO;

    // デリゲートオブジェクトが設定され、ボタンタップ時のメソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(RouteInfoViewButtonTouched)]) [self.delegate RouteInfoViewButtonTouched];
}

// 進むボタンがタップされた時に実行される処理
- (IBAction)forwardButtonTouchUp {
    // 道程の索引を加算
    stepIndex_++;
    
    // 現在選択されている道程の情報を表示欄に設定
    infoLabel.text = [stationRoute informationWithStepIndex:stepIndex_];

    // 現在の道程番号表示欄に値を設定
    currentStepNumberLabel.text = [NSString stringWithFormat:@"%d", stepIndex_ + 1];
    
    // 道程が最終の場合は、戻るボタンを非表示にする
    if (stepIndex_ == [stationRoute.routeObject.steps count] - 1) forwardButton.hidden = YES;
    
    // 戻るボタンが非表示の場合は、戻るボタンを表示する
    if (backButton.hidden) backButton.hidden = NO;

    // デリゲートオブジェクトが設定され、ボタンタップ時のメソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(RouteInfoViewButtonTouched)]) [self.delegate RouteInfoViewButtonTouched];
}

// 閉じるボタンがタップされた時に実行される処理
- (IBAction)closeButtonTouchUp {
    // 自身を非表示にし、表示中フラグを解除
    self.view.hidden = YES;
    isOpening = NO;
    
    // デリゲートオブジェクトが設定され、画面が閉じられた時のメソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(RouteInfoViewClosed)]) [self.delegate RouteInfoViewClosed];
}

#pragma mark - 各種処理

// 初期化処理
- (void)initialize {
    // 経路の道程の索引を初期化
    stepIndex_ = 0;

    // 出発地の駅データが設定されていない(現在位置からの経路検索)場合は専用の文字列、設定されている場合は出発地の駅名を出発地の駅名に設定
    NSString *sourceStationName = (!stationRoute.sourceStationData) ? SOURCE_LOCATION_ANNOTATION_TITLE : stationRoute.sourceStationData.name;

    // 出発地・目的地、距離・時間表示欄に文字列を設定
    fromToLabel.text = [NSString stringWithFormat:@"%@→%@", sourceStationName, stationRoute.destinationStationData.name];
    distanceTimeLabel.text = [NSString stringWithFormat:@"%@　%@", stationRoute.routeObject.distanceText, stationRoute.routeObject.durationText];
    
    // 現在選択されている道程の情報を表示欄に設定
    infoLabel.text = [stationRoute informationWithStepIndex:stepIndex_];

    // 現在の道程番号表示欄と道程数表示欄に値を設定
    currentStepNumberLabel.text = [NSString stringWithFormat:@"%d", 1];
    stepCountLabel.text = [NSString stringWithFormat:@"%d", [stationRoute.routeObject.steps count]];
    
    // 戻るボタンを非表示にする
    backButton.hidden = YES;
    
    // 進むボタンを表示する
    forwardButton.hidden = NO;
    
    //到着予定時間を更新
    [self updateEstimatedArrivalTime];
}

// 現在設定されている経路の中で、現在選択されている道程の開始位置の座標を返す
- (CLLocationCoordinate2D)currentStepStartLocation {
    return [stationRoute startLocationWithStepIndex:stepIndex_];
}

// 到着予定時間を更新する
- (void)updateEstimatedArrivalTime {
    // 到着予定日時を算出
    int requiredTime = [stationRoute.routeObject.durationValue intValue];
    NSDate *estimatedArrivalDate = [[NSDate date] dateByAddingTimeInterval:requiredTime + (requiredTime % 60)];
    
    // 到着予定時刻を設定
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:estimatedArrivalDate];
    estimatedArrivalTimeLabel.text = [NSString stringWithFormat:@"%d時%d分", dateComponents.hour, dateComponents.minute];
    
    // 到着予定日時に、目的地の駅が営業時間であるかどうかによって警告表示欄の表示を設定
    warningLabel.hidden = ![stationRoute.destinationStationData isClosingWithDate:estimatedArrivalDate];
}

@end
