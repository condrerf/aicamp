//
//  StationInfoViewController.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StationInfoViewController.h"
#import "Categories.h"
#import "Constants.h"
#import "Utility.h"
#import "ConfigurationData.h"
#import "FBNetworkReachability.h"
#import "Database.h"
#import "StationDataListWithoutDetail.h"
#import "LocationManager.h"
#import "StationRoute.h"
#import "MapViewController.h"

// 非公開メソッドのカテゴリ
@interface StationInfoViewController(PrivateMethods)
- (void)swipedRight;
- (void)cancelGettingCurrentLocation;
- (void)executeRoutingFromCurrentLocation;
- (void)executeRoutingOfRoutingType:(NSNumber *)routingType;
@end

@implementation StationInfoViewController

@synthesize scrollView;
@synthesize stationInfoView;
@synthesize descriptionLabel;
@synthesize stationImageView;
@synthesize introductionLabel;
@synthesize addressCaptionLabel;
@synthesize addressLabel;
@synthesize telephoneCaptionLabel;
@synthesize telephoneLabel;
@synthesize telephoneButton;
@synthesize shopHourCaptionLabel;
@synthesize shopHourLabel;
@synthesize holidayCaptionLabel;
@synthesize holidayLabel;
@synthesize commentLabel;
@synthesize messageCaptionLabel;
@synthesize messageLabel;
@synthesize recommendationCaptionLabel;
@synthesize recommendationLabel;
@synthesize routingCaptionLabel;
@synthesize fromCurrentLocationRouteButton;
@synthesize surroundingStationsRouteButton;
@synthesize arbitraryStationRouteButton;

#pragma mark - 初期化・終端処理

// 指定されたIDの駅データで初期化する
- (id)initWithStationID:(int)stationID {
    self = [self initWithNibName:@"StationInfo" bundle:nil];
    
    if (self) {
        // 駅データの取得
        currentStationData_ = [[[Database getInstance] selectStationDataWithDetailOfStationID:stationID] retain];
        
        // 目的地の駅データの集合を初期化
        destinationStationDataArray_ = [[NSMutableArray alloc] init];

        // ナビゲーションバーに駅名を設定
        self.navigationItem.title = currentStationData_.name;

        // 右スワイプイベントを検出するクラスの設定
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(swipedRight)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeGestureRecognizer];
        [swipeGestureRecognizer release];

        // ナビゲーションバーのフォントサイズがタイトルの文字数に応じて調整されるように設定
        [[Utility getInstance] setAdjustFontSizeOfNavigationItem:self.navigationItem];
        
        // インジケータ画面の生成
        indicatorViewController_ = [[IndicatorViewController alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 各データを設定
    descriptionLabel.text = currentStationData_.description;
    stationImageView.image = [UIImage imageNamed:
                              [NSString stringWithFormat:STATION_IMAGE_FILE_FORMAT, currentStationData_.stationID]];
    introductionLabel.text = currentStationData_.introduction;
    messageLabel.text = currentStationData_.message;
    recommendationLabel.text = currentStationData_.recommendationInfo;
    addressLabel.text = currentStationData_.address;
    telephoneLabel.text = currentStationData_.telephone;
    [telephoneButton setTitle:currentStationData_.telephone forState:UIControlStateNormal];
    shopHourLabel.text = [currentStationData_ shopHoursString];
    holidayLabel.text = [currentStationData_ holidaysString];
    
    // 各情報欄の大きさを再設定(縦方向で上揃えにするため)
    [descriptionLabel resize];
    [introductionLabel resize];
    [shopHourLabel resize];
    [holidayLabel resize];
    [commentLabel resize];
    [messageLabel resize];
    [recommendationLabel resize];
    
    // 各情報欄の表示位置を調整
    int addressLabelYPosition = introductionLabel.frame.origin.y + introductionLabel.frame.size.height + (STATION_INFO_LABEL_MARGIN * 2);
    int telephoneLabelYPosition = addressLabelYPosition + addressLabel.frame.size.height + STATION_INFO_LABEL_MARGIN;
    int shopHourLabelYPosition = telephoneLabelYPosition + telephoneLabel.frame.size.height + STATION_INFO_LABEL_MARGIN;
    int holidayLabelYPosition = shopHourLabelYPosition + shopHourLabel.frame.size.height + STATION_INFO_LABEL_MARGIN;
    int commentLabelYPosition = holidayLabelYPosition + holidayLabel.frame.size.height + STATION_INFO_LABEL_MARGIN;
    int messageCaptionLabelYPosition = commentLabelYPosition + commentLabel.frame.size.height + (STATION_INFO_LABEL_MARGIN * 2);
    int messageLabelYPosition = messageCaptionLabelYPosition + messageCaptionLabel.frame.size.height;
    int recommendationCaptionLabelYPosition = messageLabelYPosition + messageLabel.frame.size.height + STATION_INFO_LABEL_MARGIN;
    int recommendationLabelYPosition = recommendationCaptionLabelYPosition + recommendationCaptionLabel.frame.size.height;
    int routingCaptionLabelYPosition = recommendationLabelYPosition + recommendationLabel.frame.size.height + (STATION_INFO_LABEL_MARGIN * 2);
    int fromCurrentLocationRouteButtonYPosition = routingCaptionLabelYPosition + routingCaptionLabel.frame.size.height + (STATION_INFO_LABEL_MARGIN * 2);
    int surroundingStationsButtonYPosition = fromCurrentLocationRouteButtonYPosition + fromCurrentLocationRouteButton.frame.size.height + STATION_INFO_LABEL_MARGIN;
    
    addressCaptionLabel.frame = CGRectMake(addressCaptionLabel.frame.origin.x, addressLabelYPosition,
                                           addressCaptionLabel.frame.size.width, addressCaptionLabel.frame.size.height);
    addressLabel.frame = CGRectMake(addressLabel.frame.origin.x, addressLabelYPosition,
                                    addressLabel.frame.size.width, addressLabel.frame.size.height);
    telephoneCaptionLabel.frame = CGRectMake(telephoneCaptionLabel.frame.origin.x, telephoneLabelYPosition,
                                             telephoneCaptionLabel.frame.size.width, telephoneCaptionLabel.frame.size.height);
    telephoneLabel.frame = CGRectMake(telephoneLabel.frame.origin.x, telephoneLabelYPosition,
                                      telephoneLabel.frame.size.width, telephoneLabel.frame.size.height);
    telephoneButton.frame = CGRectMake(telephoneButton.frame.origin.x, telephoneLabelYPosition,
                                      telephoneButton.frame.size.width, telephoneButton.frame.size.height);
    shopHourCaptionLabel.frame = CGRectMake(shopHourCaptionLabel.frame.origin.x, shopHourLabelYPosition,
                                            shopHourCaptionLabel.frame.size.width, shopHourCaptionLabel.frame.size.height);
    shopHourLabel.frame = CGRectMake(shopHourLabel.frame.origin.x, shopHourLabelYPosition,
                                     shopHourLabel.frame.size.width, shopHourLabel.frame.size.height);
    holidayCaptionLabel.frame = CGRectMake(holidayCaptionLabel.frame.origin.x, holidayLabelYPosition,
                                           holidayCaptionLabel.frame.size.width, holidayCaptionLabel.frame.size.height);
    holidayLabel.frame = CGRectMake(holidayLabel.frame.origin.x, holidayLabelYPosition,
                                    holidayLabel.frame.size.width, holidayLabel.frame.size.height);
    commentLabel.frame = CGRectMake(commentLabel.frame.origin.x, commentLabelYPosition,
                                    commentLabel.frame.size.width, commentLabel.frame.size.height);
    messageCaptionLabel.frame = CGRectMake(messageCaptionLabel.frame.origin.x, messageCaptionLabelYPosition,
                                           messageCaptionLabel.frame.size.width, messageCaptionLabel.frame.size.height);
    messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabelYPosition,
                                    messageLabel.frame.size.width, messageLabel.frame.size.height);
    recommendationCaptionLabel.frame = CGRectMake(recommendationCaptionLabel.frame.origin.x, recommendationCaptionLabelYPosition,
                                                  recommendationCaptionLabel.frame.size.width, recommendationCaptionLabel.frame.size.height);
    recommendationLabel.frame = CGRectMake(recommendationLabel.frame.origin.x, recommendationLabelYPosition,
                                           recommendationLabel.frame.size.width, recommendationLabel.frame.size.height);
    routingCaptionLabel.frame = CGRectMake(routingCaptionLabel.frame.origin.x, routingCaptionLabelYPosition,
                                           routingCaptionLabel.frame.size.width, routingCaptionLabel.frame.size.height);
    fromCurrentLocationRouteButton.frame = CGRectMake(fromCurrentLocationRouteButton.frame.origin.x, fromCurrentLocationRouteButtonYPosition,
                                                      fromCurrentLocationRouteButton.frame.size.width, fromCurrentLocationRouteButton.frame.size.height);
    surroundingStationsRouteButton.frame = CGRectMake(surroundingStationsRouteButton.frame.origin.x, surroundingStationsButtonYPosition,
                                                 surroundingStationsRouteButton.frame.size.width, surroundingStationsRouteButton.frame.size.height);
    arbitraryStationRouteButton.frame = CGRectMake(arbitraryStationRouteButton.frame.origin.x, surroundingStationsButtonYPosition,
                                                      arbitraryStationRouteButton.frame.size.width, arbitraryStationRouteButton.frame.size.height);
    
    // 駅情報画面の高さを調整
    stationInfoView.frame = CGRectMake(stationInfoView.frame.origin.x, 
                                       stationInfoView.frame.origin.y, 
                                       stationInfoView.frame.size.width, 
                                       surroundingStationsButtonYPosition + surroundingStationsRouteButton.frame.size.height + STATION_INFO_LABEL_MARGIN);

    // スクロールビューに駅情報画面を設定
    scrollView.contentSize = [stationInfoView sizeThatFits:CGSizeZero];
    [scrollView addSubview:stationInfoView];
    
    // 使用されている端末がiPhoneである場合
    if ([[Utility getInstance].platform rangeOfString:@"iPhone"].location != NSNotFound) {
        // 電話番号ボタンを表示し、電話番号表示欄を非表示にする
        telephoneButton.hidden = NO;
        telephoneLabel.hidden = YES;
    }
}

- (void)viewDidUnload {
    // 各コントロールの解放
    [self setScrollView:nil];
    [self setStationInfoView:nil];
    [self setDescriptionLabel:nil];
    [self setStationImageView:nil];
    [self setIntroductionLabel:nil];
    [self setAddressCaptionLabel:nil];
    [self setAddressLabel:nil];
    [self setTelephoneCaptionLabel:nil];
    [self setTelephoneLabel:nil];
    [self setTelephoneButton:nil];
    [self setShopHourCaptionLabel:nil];
    [self setShopHourLabel:nil];
    [self setHolidayCaptionLabel:nil];
    [self setHolidayLabel:nil];
    [self setCommentLabel:nil];
    [self setMessageCaptionLabel:nil];
    [self setMessageLabel:nil];
    [self setRecommendationCaptionLabel:nil];
    [self setRecommendationLabel:nil];
    [self setRoutingCaptionLabel:nil];
    [self setFromCurrentLocationRouteButton:nil];
    [self setSurroundingStationsRouteButton:nil];
    [self setArbitraryStationRouteButton:nil];

    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [currentStationData_ release], currentStationData_ = nil;
    [destinationStationDataArray_ release], destinationStationDataArray_ = nil;

    // 各コントロールの解放
    [scrollView release], scrollView = nil;
    [stationInfoView release], stationInfoView = nil;
    [descriptionLabel release], descriptionLabel = nil;
    [stationImageView release], stationImageView = nil;
    [introductionLabel release], introductionLabel = nil;
    [addressCaptionLabel release], addressCaptionLabel = nil;
    [addressLabel release], addressLabel = nil;
    [telephoneCaptionLabel release], telephoneCaptionLabel = nil;
    [telephoneLabel release], telephoneLabel = nil;
    [telephoneButton release], telephoneButton = nil;
    [shopHourCaptionLabel release], shopHourCaptionLabel = nil;
    [shopHourLabel release], shopHourLabel = nil;
    [holidayCaptionLabel release], holidayCaptionLabel = nil;
    [holidayLabel release], holidayLabel = nil;
    [commentLabel release], commentLabel = nil;
    [messageCaptionLabel release], messageCaptionLabel = nil;
    [messageLabel release], messageLabel = nil;
    [recommendationCaptionLabel release], recommendationCaptionLabel = nil;
    [recommendationLabel release], recommendationLabel = nil;
    [routingCaptionLabel release], routingCaptionLabel = nil;
    [fromCurrentLocationRouteButton release], fromCurrentLocationRouteButton = nil;
    [surroundingStationsRouteButton release], surroundingStationsRouteButton = nil;
    [arbitraryStationRouteButton release], arbitraryStationRouteButton = nil;
    [indicatorViewController_ release], indicatorViewController_ = nil;

    [super dealloc];
}

#pragma mark - イベント

// 右スワイプ時に実行される処理
- (void)swipedRight {
    // 前の画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

// 電話番号表示欄がタップされた時に実行される処理
- (void)telephoneButtonTouchUp {
    // 電話確認ダイアログを表示
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"確認";
    alertView.message = TELEPHONE_CONFIRMATION_DIALOG_MESSAGE;
    [alertView addButtonWithTitle:@"はい"];
    [alertView addButtonWithTitle:@"いいえ"];
    [alertView show];
    [alertView release];
}

// アラートダイアログのボタンが押された時に実行される処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 「はい」が選択された場合は、電話をかける
    if (buttonIndex == 0) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", currentStationData_.telephone]]];
}

// 「現在位置からの経路」ボタンがタッチされた時に実行される処理
- (IBAction)routeButtonTouchUp {
    // 位置情報が取得可能である場合
    if ([[LocationManager getInstance] locationServicesEnabled]) {
        // 現在位置の更新に関する通知を受け取ったらメソッドを実行するように設定
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(executeRoutingFromCurrentLocation)
                                                     name:LOCATION_UPDATE_SUCCEEDED_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelGettingCurrentLocation)
                                                     name:LOCATION_UPDATE_FAILED_NOTIFICATION
                                                   object:nil];
        
        // 現在位置の更新を開始
        [[LocationManager getInstance] startUpdatingLocation];
        
        // インジケータを表示
        indicatorViewController_.message = LOCATION_UPDATE_MESSAGE;
        [self.navigationController.view addSubview:indicatorViewController_.view];
    // 取得できない場合
    } else {
        // 現在位置の地図の描画の中断
        [self cancelGettingCurrentLocation];
    }
}

// 「周辺の駅への経路」ボタンがタップされた時に実行される処理
- (IBAction)surroundingStationsRouteButtonTouchUp {
    // 現在選択されている駅から各駅への距離と各駅データの設定
    NSMutableDictionary *distances = [NSMutableDictionary dictionaryWithCapacity:[[StationDataListWithoutDetail getInstance].stationDataList count] - 1];
    
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        // 現在参照している駅が現在選択されている駅である場合は、処理を行わない
        if (stationData.stationID == currentStationData_.stationID) continue;
        
        NSNumber *stationIDNumber = [NSNumber numberWithInt:stationData.stationID];
        double distance = sqrt(pow(currentStationData_.location.latitude - stationData.location.latitude, 2) +
                               pow(currentStationData_.location.longitude - stationData.location.longitude, 2));
        [distances setObject:[NSNumber numberWithDouble:distance] forKey:stationIDNumber];
    }
    
    // 距離の昇順で駅のIDの集合を取得
    NSArray *stationIDs = [distances keysSortedByValueUsingSelector:@selector(compare:)];
    
    // 目的地の駅データの集合を初期化
    [destinationStationDataArray_ removeAllObjects];

    // 規定数分の駅データを集合に追加
    for (int i = 0; i < [ConfigurationData getInstance].routingCount; i++) {
        int stationID = [[stationIDs objectAtIndex:i] intValue];
        [destinationStationDataArray_ addObject:[[StationDataListWithoutDetail getInstance] stationDataWithStationID:stationID]];
    }
    
    // インジケータを表示
    indicatorViewController_.message = ROUTING_MESSAGE;
    [self.navigationController.view addSubview:indicatorViewController_.view];
    
    // 経路検索を実行
    [self performSelector:@selector(executeRoutingOfRoutingType:) withObject:[NSNumber numberWithInt:RoutingTypeToSurroundingStations] afterDelay:0];
}

// 「任意の駅への経路」ボタンがタップされた時に実行される処理
- (IBAction)arbitraryStationRouteButtonTouchUp {
    // 写真の保存先選択画面を表示
    StationSelectViewController *stationSelectViewController = [[StationSelectViewController alloc] initWithStationID:currentStationData_.stationID];
    stationSelectViewController.delegate = self;
    [self.tabBarController presentModalViewController:stationSelectViewController animated:YES];
    [stationSelectViewController release];
}

#pragma mark - 経路検索

// 現在位置の取得を中断する
- (void)cancelGettingCurrentLocation {
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // エラーダイアログを表示
    [[Utility getInstance] showErrorDialog:LOCATION_UPDATE_FAILED_MESSAGE];
    
    // インジケータを非表示にする
    [indicatorViewController_.view removeFromSuperview];
}

// 現在位置からの経路検索を試行する
- (void)executeRoutingFromCurrentLocation {
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 現在選択されている駅データを設定
    [destinationStationDataArray_ removeAllObjects];
    [destinationStationDataArray_ addObject:currentStationData_];
    
    // インジケータのラベルを変更
    indicatorViewController_.message = ROUTING_MESSAGE;
    
    // 経路検索を実行
    [self performSelector:@selector(executeRoutingOfRoutingType:) withObject:[NSNumber numberWithInt:RoutingTypeFromCurrentLocation] afterDelay:0];
}

// 指定された種類に応じた経路検索を実行する
- (void)executeRoutingOfRoutingType:(NSNumber *)routingType_ {
    // ネットワークに接続できない場合
    if (![[FBNetworkReachability sharedInstance] reachable]) {
        // エラーメッセージを表示
        [[Utility getInstance] showErrorDialog:ROUTING_FAILED_FOR_NETWORK_MESSAGE];
        
        // インジケータを非表示にして処理を中断する
        [indicatorViewController_.view removeFromSuperview];
        return;
    }

    // 経路の型の値を変換
    RoutingType routingType = [routingType_ intValue];

    // 現在位置からの経路検索が要求されている場合は現在位置、そうでない場合は現在選択されている駅の位置情報を位置情報に格納
    CLLocationCoordinate2D sourceLocation = (routingType == RoutingTypeFromCurrentLocation ? [LocationManager getInstance].location : currentStationData_.location);
    
    // 駅の各経路データを格納
    NSMutableArray *stationRoutes = [NSMutableArray arrayWithCapacity:[destinationStationDataArray_ count]];
    
    // 経路検索に失敗したかどうかを格納
    BOOL isRoutingFailed = NO;
    
    // 使用上限超過によって経路検索に失敗したかどうかを格納
    BOOL isOverQueryLimit = NO;
    
    // 目的地の駅データの集合の各要素を参照
    for (StationData *stationData in destinationStationDataArray_) {
        // 現在参照している目的地の駅への経路データを生成
        StationRoute *stationRoute = [[StationRoute alloc] initWithSourceLocation:sourceLocation
                                                              destinationLocation:stationData.location];
        
        // 経路検索に失敗した場合
        if (![GOOGLE_MAPS_API_STATUS_OK isEqualToString:stationRoute.routeObject.status]) {
            // 使用制限の上限超過のステータスが設定されている場合
            if ([GOOGLE_MAPS_API_STATUS_OVER_QUERY_LIMIT isEqualToString:stationRoute.routeObject.status]) {
                // 使用上限超過フラグを設定
                isOverQueryLimit = YES;
            // その他のステータスが設定されている場合
            } else {
                // 経路検索失敗フラグを設定
                isRoutingFailed = YES;
            }
            
            // 経路データを解放してループから抜ける
            [stationRoute release];
            break;
        }
        
        // 出発地(現在位置からの経路以外の場合)と目的地の駅データを駅の経路データに設定
        if (routingType != RoutingTypeFromCurrentLocation) stationRoute.sourceStationData = currentStationData_;
        stationRoute.destinationStationData = stationData;

        // 駅の経路データを集合に追加
        [stationRoutes addObject:stationRoute];
        
        // オブジェクトを解放
        [stationRoute release];
    }
    
    // 経路検索に失敗した場合
    if (isRoutingFailed || isOverQueryLimit) {
        // エラーメッセージを表示
        [[Utility getInstance] showErrorDialog:isOverQueryLimit ? ROUTING_OVER_QUERY_LIMIT_MESSAGE : ROUTING_FAILED_MESSAGE];
        
        // インジケータを非表示にして処理を中断する
        [indicatorViewController_.view removeFromSuperview];
        return;
    }
    
    // インジケータを非表示にする
    if (self.tabBarController.modalViewController) {
        [self.tabBarController dismissModalViewControllerAnimated:NO];
    } else {
        [indicatorViewController_.view removeFromSuperview];
    }
    
    // 地図画面のナビゲーションコントローラを取得
    UINavigationController *viewController = [self.tabBarController.viewControllers objectAtIndex:Map];
    
    // 地図画面に経路を設定
    MapViewController *mapViewController = [[viewController viewControllers] objectAtIndex:0];
    [mapViewController setStationRoutes:stationRoutes routingType:routingType];
    
    // 詳細画面を表示している場合は地図画面に戻す
    if ([[viewController viewControllers] count] > 1) [viewController popToRootViewControllerAnimated:NO];
    
    // 地図画面を表示する
    [self.tabBarController setSelectedIndex:Map];
}

#pragma mark - デリゲートメソッド(StationSelectViewDelegate)

// 駅の選択画面で駅が選択された時に実行される処理
- (void)stationSelectViewCellSelectedStationData:(StationData *)stationData {
    // 選択された駅データを設定
    [destinationStationDataArray_ removeAllObjects];
    [destinationStationDataArray_ addObject:stationData];
    
    // 駅の選択画面の上にインジケータを表示
    indicatorViewController_.message = ROUTING_MESSAGE;
    [self.tabBarController.modalViewController.view addSubview:indicatorViewController_.view];

    // 経路検索を実行
    [self performSelector:@selector(executeRoutingOfRoutingType:) withObject:[NSNumber numberWithInt:RoutingTypeToArbitraryStation] afterDelay:0];
}

// 駅の選択画面でキャンセルボタンがタップされた時に実行される処理
- (void)stationSelectViewCancelButtonTouched {
    // 駅の選択画面を閉じる
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

@end
