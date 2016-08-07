//
//  ConfigurationViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "Constants.h"
#import "ConfigurationData.h"
#import "StationDataListWithoutDetail.h"
#import "StationListViewController.h"
#import "PhotoStationListViewController.h"

// 非公開メソッドのカテゴリ
@interface ConfigurationViewController(PrivateMethods)
- (void)viewWillResignActive;
@end

@implementation ConfigurationViewController

@synthesize stationListOrderTypeControl;
@synthesize notifiesStationControl;
@synthesize avoidsTollRoadControl;
@synthesize routingCountSlider;
@synthesize routingCountLabel;
@synthesize savesToNearestStationAutomaticallyControl;

#pragma mark - 初期化・終端処理

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 設定データの値に応じて各設定欄の状態を設定
    stationListOrderTypeControl.selectedSegmentIndex = [ConfigurationData getInstance].stationListOrderType;
    notifiesStationControl.selectedSegmentIndex = [ConfigurationData getInstance].notifiesStation ? 0 : 1;
    avoidsTollRoadControl.selectedSegmentIndex = [ConfigurationData getInstance].avoidsTollRoad ? 0 : 1;
    routingCountSlider.value = [ConfigurationData getInstance].routingCount;
    routingCountLabel.text = [NSString stringWithFormat:@"%d", [ConfigurationData getInstance].routingCount];
    savesToNearestStationAutomaticallyControl.selectedSegmentIndex = [ConfigurationData getInstance].savesToNearestStationAutomatically ? 0 : 1;
    
    // 各選択欄の高さを調整
    [stationListOrderTypeControl setFrame:CGRectMake(stationListOrderTypeControl.frame.origin.x,
                                                     stationListOrderTypeControl.frame.origin.y,
                                                     stationListOrderTypeControl.frame.size.width,
                                                     SEGMENTED_CONTROLLER_HEIGHT)];
    [notifiesStationControl setFrame:CGRectMake(notifiesStationControl.frame.origin.x,
                                                notifiesStationControl.frame.origin.y,
                                                notifiesStationControl.frame.size.width,
                                                SEGMENTED_CONTROLLER_HEIGHT)];
    [avoidsTollRoadControl setFrame:CGRectMake(avoidsTollRoadControl.frame.origin.x,
                                               avoidsTollRoadControl.frame.origin.y,
                                               avoidsTollRoadControl.frame.size.width,
                                               SEGMENTED_CONTROLLER_HEIGHT)];
    [savesToNearestStationAutomaticallyControl setFrame:CGRectMake(savesToNearestStationAutomaticallyControl.frame.origin.x,
                                                                   savesToNearestStationAutomaticallyControl.frame.origin.y,
                                                                   savesToNearestStationAutomaticallyControl.frame.size.width,
                                                                   SEGMENTED_CONTROLLER_HEIGHT)];
}

- (void)viewDidUnload {
    // 各コントロールの解放
    [self setStationListOrderTypeControl:nil];
    [self setNotifiesStationControl:nil];
    [self setAvoidsTollRoadControl:nil];
    [self setRoutingCountSlider:nil];
    [self setRoutingCountLabel:nil];
    [self setSavesToNearestStationAutomaticallyControl:nil];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // 各コントロールの解放
    [stationListOrderTypeControl release], stationListOrderTypeControl = nil;
    [notifiesStationControl release], notifiesStationControl = nil;
    [avoidsTollRoadControl release], avoidsTollRoadControl = nil;
    [routingCountSlider release], routingCountSlider = nil;
    [routingCountLabel release], routingCountLabel = nil;
    [savesToNearestStationAutomaticallyControl release], savesToNearestStationAutomaticallyControl = nil;
    
    [super dealloc];
}

#pragma mark - 画面の表示・非表示時のイベント

// 画面の表示開始時に実行される処理
- (void)viewWillAppear:(BOOL)animated {
    // アプリケーションの処理停止時の通知を受信したらメソッドを実行するように設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillResignActive)
                                                 name:APPLICATION_WILL_RESIGN_ACTIVE_NOTIFICATION
                                               object:nil];
    
}

// 別の画面に切り替わる時に実行される処理
- (void)viewWillDisappear:(BOOL)animated {
    // 画面が操作対象でなくなる時の処理を実行
    [self viewWillResignActive];
    
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 画面が操作対象でなくなる時に実行される処理
- (void)viewWillResignActive {
    // 設定データを保存
    [[ConfigurationData getInstance] save];
    
    // 駅データ(詳細データ以外)の集合の順序の種類が、現在の駅一覧の順序の種類と異なる場合
    if ([StationDataListWithoutDetail getInstance].orderType != [ConfigurationData getInstance].stationListOrderType) {
        // 駅データ(詳細データ以外)の集合を整列
        [[StationDataListWithoutDetail getInstance] sort];
        
        // 駅情報タブ内の駅一覧画面のテーブルと写真タブ内の駅一覧画面のテーブルを再描画
        // (※各タブ内の駅選択画面表示時はタブが隠れ、駅選択画面が表示された状態で当画面を表示することはできないため、更新処理は不要)
        UINavigationController *stationInfoNavigationController = [self.tabBarController.viewControllers objectAtIndex:StationInfo];
        [((StationListViewController *) [stationInfoNavigationController.viewControllers objectAtIndex:0]).tableView reloadData];
        UINavigationController *photoStationInfoNavigationController = [self.tabBarController.viewControllers objectAtIndex:Photo];
        [((PhotoStationListViewController *) [photoStationInfoNavigationController.viewControllers objectAtIndex:0]).tableView reloadData];
    }
}

#pragma mark - コントロールのイベント

// 「駅一覧の順序」の状態が変更された時に実行される処理
- (IBAction)stationListOrderTypeControlChanged {
    // コントロールの値を設定データに設定
    [ConfigurationData getInstance].stationListOrderType = (stationListOrderTypeControl.selectedSegmentIndex == 0) ? StationListOrderTypeStationID
                                                                                                                   : StationListOrderTypeJapaneseSyllabary;
}

// 「駅の開店・閉店時間にメッセージを表示する」の状態が変更された時に実行される処理
- (IBAction)notifiesStationControlChanged {
    // コントロールの値を設定データに設定
    [ConfigurationData getInstance].notifiesStation = (notifiesStationControl.selectedSegmentIndex == 0) ? YES : NO;
}

// 「経路検索時に高速道路を使用する」の状態が変更された時に実行される処理
- (IBAction)avoidsTollRoadControlChanged {
    // コントロールの値を設定データに設定
    [ConfigurationData getInstance].avoidsTollRoad = (avoidsTollRoadControl.selectedSegmentIndex == 0) ? YES : NO;
}

// 「周辺の駅検索時に検索する駅の数」の状態が変更された時に実行される処理
- (IBAction)routingCountSliderChanged {
    // コントロールの値を設定データと駅数表示欄に設定
    [ConfigurationData getInstance].routingCount = (int) routingCountSlider.value;
    routingCountLabel.text = [NSString stringWithFormat:@"%d", [ConfigurationData getInstance].routingCount];
}

// 「写真撮影時、自動的に最寄駅に保存する」の状態が変更された時に実行される処理
- (IBAction)savesToNearestStationAutomaticallyControlChanged {
    // コントロールの値を設定データに設定
    [ConfigurationData getInstance].savesToNearestStationAutomatically = (savesToNearestStationAutomaticallyControl.selectedSegmentIndex == 0) ? YES : NO;
}

@end