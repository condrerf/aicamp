//
//  MapViewController.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Constants.h"
#import "Utility.h"
#import "ConfigurationData.h"
#import "Database.h"
#import "StationDataListWithoutDetail.h"
#import "LocationManager.h"
#import "StationData.h"
#import "StationAnnotation.h"
#import "NationalHolidayManager.h"
#import "StationListViewController.h"
#import "StationRoute.h"
#import "StepObject.h"
#import "RouteLine.h"

// 非公開メソッドのカテゴリ
@interface MapViewController(PrivateMethods)
- (void)viewDidBecomeActive;
- (void)viewWillResignActive;
- (void)stationAnnotationUpdateTimerEvent;
- (void)notificationTimerEvent;
- (void)stopNotificationTimerEvent;
- (void)trackingTimerEvent:(NSTimer *)timer;
- (void)tryDrawingMapOfCurrentLocation;
- (void)drawMapOfCurrentLocation;
- (void)cancelDrawingMapOfCurrentLocation;
- (void)resetAnnotationsIncludingCurentLocationAnnotation:(BOOL)removeSourceLocationAnnotation;
- (UIImage *)annotationImageOfStationData:(StationData *)stationData;
- (void)changeControlsView:(BOOL)shows;
- (void)changeNotificationView:(BOOL)shows;
- (void)changeRecordVisitInfoButton:(BOOL)shows;
- (void)changeTracking:(BOOL)tracks;
- (void)initializeRouteInfoView;
- (void)setCurrentStepCenterLocation;
- (void)moveCurrentStepCenterLocationCircle;
@end

@implementation MapViewController

@synthesize mapView;
@synthesize notificationLabel;
@synthesize currentLocationButton;
@synthesize currentLocationButtonMenuTableViewController;
@synthesize mapTypeSegmentedControl;
@synthesize recordVisitInfoButton;
@synthesize routeButton;
@synthesize routeButtonMenuTableViewController;

#pragma mark - 初期化・終端処理

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // アノテーションが変わった駅データの集合の初期化
        annotationChangedStationDataArray_ = [[NSMutableArray alloc] init];

        // インジケータ画面の生成
        indicatorViewController_ = [[IndicatorViewController alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 地図画面に専用のジェスチャーイベント検出クラスを設定
    MapGestureRecognizer *recognizer = [[MapGestureRecognizer alloc] init];
    recognizer.delegate = self;
    [mapView addGestureRecognizer:recognizer];
    [recognizer release];
    
    // 地図画面のデリゲートを設定
    mapView.delegate = self;
    mapView.scrollDelegate = self;
    
    // 地図画面の現在地のアノテーションのタイトルを設定
    mapView.userLocation.title = CURRENT_LOCATION_ANNOTATION_TITLE;
    
    // 現在位置ボタンのメニューのデリゲートの設定
    currentLocationButtonMenuTableViewController.delegate = self;
    
    // ナビゲーションバーから経路ボタンを除去
    self.navigationItem.rightBarButtonItem = nil;
    
    // 経路ボタンのメニューのデリゲートの設定
    routeButtonMenuTableViewController.delegate = self;

    // 経路情報画面のコントローラを生成
    routeInfoViewController_ = [[RouteInfoViewController alloc] init];
    
    // 経路情報画面のデリゲートの設定
    routeInfoViewController_.delegate = self;
    
    // 経路情報画面を地図画面の上に設定
    [self.view insertSubview:routeInfoViewController_.view aboveSubview:mapView];
    routeInfoViewController_.view.hidden = YES;
    
    // 郡上市役所（岐阜県の地理的な中心）を中心とした地図を描画
    MKCoordinateRegion region;
    region.center.latitude = GUJO_CITY_OFFICE_LATITUDE;
    region.center.longitude = GUJO_CITY_OFFICE_LONGITUDE;
    region.span.latitudeDelta = INITIAL_MAP_RANGE_DEGREE;
    region.span.longitudeDelta = INITIAL_MAP_RANGE_DEGREE;
    [mapView setRegion:region animated:YES];
    
    // 各駅にアノテーションを設定
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        StationAnnotation *stationAnnotation = [[StationAnnotation alloc] initWithStationData:stationData];
        [mapView addAnnotation:stationAnnotation];
        [stationAnnotation release];
    }
}

// 画面の表示開始時に実行される処理
- (void)viewWillAppear:(BOOL)animated {
    // 画面が操作対象になった時の処理を実行
    [self viewDidBecomeActive];
    
    // アプリケーションの処理開始時の通知を受信したらメソッドを実行するように設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidBecomeActive)
                                                 name:APPLICATION_DID_BECOME_ACTIVE_NOTIFICATION
                                               object:nil];
    
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

- (void)viewDidUnload {    
    // 各コントロールの解放
    [self setMapView:nil];
    [self setNotificationLabel:nil];
    [self setCurrentLocationButton:nil];
    [self setCurrentLocationButtonMenuTableViewController:nil];
    [self setMapTypeSegmentedControl:nil];
    [self setRecordVisitInfoButton:nil];
    [self setRouteButton:nil];
    [self setRouteButtonMenuTableViewController:nil];

    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [annotationChangedStationDataArray_ release], annotationChangedStationDataArray_ = nil;
    [stationRoutes_ release], stationRoutes_ = nil;
    
    // 各コントロールの解放
    [mapView release], mapView = nil;
    [notificationLabel release], notificationLabel = nil;
    [currentLocationButton release], currentLocationButton = nil;
    [currentLocationButtonMenuTableViewController release], currentLocationButtonMenuTableViewController = nil;
    [mapTypeSegmentedControl release], mapTypeSegmentedControl = nil;
    [recordVisitInfoButton release], recordVisitInfoButton = nil;
    [routeButton release], routeButton = nil;
    [routeButtonMenuTableViewController release], routeButtonMenuTableViewController = nil;
    [indicatorViewController_ release], indicatorViewController_ = nil;
    [routeInfoViewController_ release], routeInfoViewController_ = nil;
    [currentStepCenterLocationCircleImageView_ release], currentStepCenterLocationCircleImageView_ = nil;

    [super dealloc];
}

#pragma mark - イベント

// 画面が操作対象になった時に実行される処理
- (void)viewDidBecomeActive {
    // 祝日データの更新を試行
    [[NationalHolidayManager getInstance] tryUpdatingNationalHolidays];
    
    // 各駅データの閉店中フラグを更新
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) [stationData updateClosingFlag];
    
    // 出発地を除いた各駅のアノテーションを再設定
    [self resetAnnotationsIncludingCurentLocationAnnotation:NO];
    
    // 経路情報画面が表示中の場合は、到着予定時刻を更新
    if (routeInfoViewController_.isOpening) [routeInfoViewController_ updateEstimatedArrivalTime]; 

    // 駅のアノテーションの更新を行うタイマーを開始
    stationAnnotationUpdateTimer_ = [NSTimer scheduledTimerWithTimeInterval:1
                                                                     target:self
                                                                   selector:@selector(stationAnnotationUpdateTimerEvent)
                                                                   userInfo:nil
                                                                    repeats:YES];
    
    // タイマーが非同期で動作するように設定
    [[NSRunLoop currentRunLoop] addTimer:stationAnnotationUpdateTimer_ forMode:NSRunLoopCommonModes];
}

// 画面が操作対象でなくなる時に実行される処理
- (void)viewWillResignActive {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];

    // 駅のアノテーションの更新を行うタイマーを解放
    [stationAnnotationUpdateTimer_ invalidate], stationAnnotationUpdateTimer_ = nil;
    
    // 通知のタイマーが起動している場合は、アノテーションが変わった駅データの集合を初期化した上で通知のタイマーイベントを終了
    if (notificationTimer_) {
        [annotationChangedStationDataArray_ removeAllObjects];
        [self stopNotificationTimerEvent];
    }

    // 位置の追跡を行っている場合は、追跡を終了
    if (isTracking_) [self changeTracking:NO];
}

// 地図の種類が変更された時に実行される処理
- (IBAction)mapTypeControlChanged {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];

    // 地図の種類を変更
    mapView.mapType = mapTypeSegmentedControl.selectedSegmentIndex;
}

// 現在位置ボタンがタップされた時に実行される処理
- (IBAction)currentLocationButtonTouchUp {
    // 経路ボタンのメニューを閉じる
    [routeButtonMenuTableViewController closeMenu];

    // 現在位置ボタンのメニューが表示されていない場合は表示、表示されている場合は非表示にする
    if (![currentLocationButtonMenuTableViewController isShowingMenu]) {
        [currentLocationButtonMenuTableViewController showMenu];
    } else {
        [currentLocationButtonMenuTableViewController closeMenu];
    }
}

// 経路ボタンがタップされた時に実行される処理
- (IBAction)routeButtonTouchUp {
    // 現在位置ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];

    // 経路ボタンのメニューが表示されていない場合は表示、表示されている場合は非表示にする
    if (![routeButtonMenuTableViewController isShowingMenu]) {
        [routeButtonMenuTableViewController showMenu];
    } else {
        [routeButtonMenuTableViewController closeMenu];
    }
}

// 「訪問情報を記録」ボタンがタップされた時に実行される処理
- (IBAction)recordVisitInfoButtonTouchUp {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];

    // 訪問対象駅の訪問日の更新
    [[Database getInstance] updateVisitedDateOfStationID:visitTargetStationID_];

    // 訪問対象駅の駅データを格納
    StationData *visitTargetStationData = [[StationDataListWithoutDetail getInstance] stationDataWithStationID:visitTargetStationID_];

    // 訪問対象駅の訪問日をデータベースから取得し、駅データに設定
    visitTargetStationData.visitedDate = [[Database getInstance] selectVisitedDateOfStationID:visitTargetStationID_];

    // 各アノテーションを参照
    for (id<MKAnnotation> annotation in mapView.annotations) {
        // 現在参照しているアノテーションが駅のものである場合
        if ([annotation isMemberOfClass:[StationAnnotation class]]) {
            // 駅のアノテーションとして格納
            StationAnnotation *stationAnnotation = (StationAnnotation *) annotation;
            
            // 現在参照している駅のアノテーションが、訪問対象駅のものである場合
            if (stationAnnotation.stationData.stationID == visitTargetStationID_) {
                // アノテーション画像を更新し、ループから抜ける
                [mapView viewForAnnotation:annotation].image = [self annotationImageOfStationData:visitTargetStationData];
                break;
            }
        }
    }

    // 訪問日の表示を更新するため、駅情報タブ内の駅一覧画面のテーブルを再描画
    UINavigationController *stationInfoNavigationController = [self.tabBarController.viewControllers objectAtIndex:StationInfo];
    [((StationListViewController *) [stationInfoNavigationController.viewControllers objectAtIndex:0]).tableView reloadData];
    
    // 駅訪問ダイアログを表示
    [[Utility getInstance] showDialogWithMessage:[NSString stringWithFormat:STATION_VISITED_MESSAGE, visitTargetStationData.name] title:@"訪問情報の記録"];
    
    // 訪問情報記録ボタンを非表示にする
    [self changeRecordVisitInfoButton:NO];
}

#pragma mark - タイマーイベント

// 駅のアノテーションの更新を行うタイマーイベント
- (void)stationAnnotationUpdateTimerEvent {
    // 祝日データの更新を試行
    [[NationalHolidayManager getInstance] tryUpdatingNationalHolidays];
    
    // 現在の秒が0でない場合は、処理を中断する
    if ([[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:[NSDate date]].second != 0) return;

    // 各駅データを参照
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        // 設定画面で駅を表示しないように設定されている場合
        if (![ConfigurationData getInstance].notifiesStation) {
            // 閉店中フラグの更新のみ実行
            [stationData updateClosingFlag];
            // 表示するように設定されている場合
        } else {
            // 更新前の閉店中フラグを格納
            BOOL isClosing = stationData.isClosing;
            
            // 閉店中フラグを更新
            [stationData updateClosingFlag];
            
            // 閉店中フラグが変わった場合は、現在参照している駅データを、アノテーションが変わった駅データの集合に追加
            if (stationData.isClosing != isClosing) [annotationChangedStationDataArray_ addObject:stationData];
        }
    }
    
    // 出発地を除いた各駅のアノテーションを再設定
    [self resetAnnotationsIncludingCurentLocationAnnotation:NO];
    
    // アノテーションが変わった駅データが存在し、通知タイマーが開始していない場合
    if ([annotationChangedStationDataArray_ count] > 0 && !notificationTimer_) {
        // 通知タイマーを開始
        notificationTimer_ = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_TIMER_INTERVAL
                                                         target:self
                                                       selector:@selector(notificationTimerEvent)
                                                       userInfo:nil
                                                        repeats:YES];
        
        // タイマーが非同期で動作するように設定
        [[NSRunLoop currentRunLoop] addTimer:notificationTimer_ forMode:NSRunLoopCommonModes];
    }
    
    // 経路情報画面が表示中の場合は、到着予定時刻を更新
    if (routeInfoViewController_.isOpening) [routeInfoViewController_ updateEstimatedArrivalTime]; 
}

// 通知に関するタイマーイベント
- (void)notificationTimerEvent {
    // アノテーションが変わった駅データの集合が空になった場合
    if ([annotationChangedStationDataArray_ count] == 0) {
        // タイマーイベントを終了して処理を中断する
        [self stopNotificationTimerEvent];
        return;
    }
    
    // アノテーションが変わった駅データの集合の最初の要素を格納
    StationData *stationData = [annotationChangedStationDataArray_ objectAtIndex:0];
    
    // 閉店中フラグの内容に応じて通知内容を設定
    notificationLabel.text = [NSString stringWithFormat:ANNOTATION_CHANGED_STATION_NOTIFICATION_FORMAT, stationData.name, (stationData.isClosing ? @"閉店" : @"開店")];
    
    // 通知表示欄が表示されていない場合は表示
    if (notificationLabel.alpha == 0) [self changeNotificationView:YES];
    
    // アノテーションが変わった駅データの集合から、使用した駅データを削除
    [annotationChangedStationDataArray_ removeObjectAtIndex:0];
}

// 通知のタイマーイベントを終了する
- (void)stopNotificationTimerEvent {
    // 通知表示欄を非表示にする
    [self changeNotificationView:NO];
    
    // 通知のタイマーの解放
    [notificationTimer_ invalidate], notificationTimer_ = nil;
}

// 追跡に関するタイマーイベント
- (void)trackingTimerEvent:(NSTimer *)timer {
    // 追跡中である場合
    if (isTracking_) {
        // 現在位置の更新中でない(前回のタイマーイベントが終了している)場合は、現在位置の地図の描画を試行
        if (![LocationManager getInstance].isUpdatingLocation) [self tryDrawingMapOfCurrentLocation];
        // 追跡中でない場合
    } else {
        // 追跡のタイマーの解放
        [timer invalidate], timer = nil;
    }
}

#pragma mark - デリゲートメソッド(MKMapViewDelegate)

// オーバーレイの描画時に実行される処理
- (MKOverlayView *)mapView:(MKMapView *)mapView_ viewForOverlay:(id<MKOverlay>)overlay {
    // 経路の線のオーバーレイが指定されている場合
    if ([overlay isMemberOfClass:[RouteLine class]]) {
        // オーバーレイから線の表示領域を生成
        MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
        
        // 線の色と幅の設定
        polylineView.strokeColor = ((RouteLine *) overlay).color;
        polylineView.lineWidth = ROUTE_LINE_WIDTH;
        
        // 線の表示領域を返す
        return polylineView;
    }

    // 上記に該当しない場合はnilを返す
    return nil;
}

// アノテーション表示時に実行される処理
- (MKAnnotationView *)mapView:(MKMapView *)_mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    // 現在位置のアノテーションが呼び出された場合は、nilを返す(標準のAnnotationViewが使用される)
	if([annotation isMemberOfClass:[MKUserLocation class]]) return nil;
    
    // 指定されたアノテーションが駅のものである場合
    if ([annotation isMemberOfClass:[StationAnnotation class]]) {
        // 指定されたアノテーションを駅のアノテーションとして格納
        StationAnnotation *stationAnnotation = (StationAnnotation *) annotation;
        
        // 指定されたアノテーションに設定された駅データに応じたアノテーション画像を取得
        UIImage *annotationImage = [self annotationImageOfStationData:stationAnnotation.stationData];
        
        // 地図画面に保存されているアノテーションの表示欄を取得
        NSString *identifier = @"StationAnnotationView";
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        // 取得できなかった場合
        if (!annotationView) {
            // 駅のアノテーションの表示欄の生成
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            
            // アノテーションの表示欄が、指定した位置の中心に表示されるように表示位置を調整
            annotationView.calloutOffset = CGPointMake(annotationImage.size.width / 10, 0);
            
            // アノテーションのタップ時にバルーンを表示するように設定
            annotationView.canShowCallout = YES;
            
            // バルーンの右側にボタンを設定
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        // 取得できた場合
        } else {
            // 指定されたアノテーションを設定
            annotationView.annotation = annotation;
        }
        
        // アノテーション画像を設定
        annotationView.image = annotationImage;
        
        // アノテーションの表示欄を返す
        return annotationView;
    // 上記に該当しない場合（現在地のアノテーション）
    } else {
        // 地図画面に保存されているピンのアノテーションの表示欄を取得
        NSString *identifier = @"PinAnnotationView";
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        // 取得できなかった場合
        if (!pinAnnotationView) {
            // 現在地用のアノテーションの表示欄の生成
            pinAnnotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            
            // 緑色のピンを設定
            pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
            
            // アニメーションを行うように設定
            pinAnnotationView.animatesDrop = YES;
            
            // アノテーションのタップ時にバルーンを表示するように設定
            pinAnnotationView.canShowCallout = YES;
        // 取得できた場合
        } else {
            // 指定されたアノテーションを設定
            pinAnnotationView.annotation = annotation;
        }
        
        // ピンのアノテーションの表示欄を返す
        return pinAnnotationView;
    }
}

// アノテーション内のバルーンのボタンがタップされた時に実行される処理
- (void)mapView:(MKMapView *)_mapView 
 annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control {
    // 駅のアノテーションでない場合は処理を中断する
    if (![view.annotation isMemberOfClass:[StationAnnotation class]]) return;
    
    // 詳細画面のオブジェクトを生成
    StationAnnotation *stationAnnotation = (StationAnnotation *) view.annotation;
    StationData *stationData = stationAnnotation.stationData;
    StationInfoViewController *stationInfoViewController = [[StationInfoViewController alloc] 
                                                            initWithStationID:stationData.stationID];
    
    // 詳細画面を表示
    [self.navigationController pushViewController:stationInfoViewController animated:YES];
    
    // オブジェクトを解放
    [stationInfoViewController release];
    
    // バルーンを非表示にする
    [_mapView deselectAnnotation:stationAnnotation animated:NO];
}

#pragma mark - デリゲートメソッド(MapViewScrollDelegate)

// 地図画面が移動した時に実行される処理
- (void)mapViewDidScroll {
    // 現在の道程の中心位置の円の表示欄を移動
    [self moveCurrentStepCenterLocationCircle];
}

#pragma mark - デリゲートメソッド(MapGestureRecognizerDelegate)

// 地図がタッチされた時に実行される処理
- (void)mapTouched {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];
}

// 地図が移動した時に実行される処理
- (void)mapMoved {
    // 各コントロールを非表示にする
    [self changeControlsView:NO];
}

// 地図の移動が止まった時に実行される処理
- (void)mapStopped {
    // 各コントロールを表示する
    [self changeControlsView:YES];
}

#pragma mark - デリゲートメソッド(MenuTableViewControllerDelegate)

// メニューの項目がタップされた時に実行される処理
- (void)didSelectMenuItem:(id)sender index:(int)index {
    // 現在位置ボタンのメニューの項目が選択された場合
    if ([sender isMemberOfClass:[CurrentLocationButtonMenuTableViewController class]]) {
        // タップされたセルによる分岐
        switch (index) {
            // 現在位置の取得
            case CurrentLocation:
                // 現在位置の地図の描画の試行
                [self tryDrawingMapOfCurrentLocation];
                break;
            // 位置を追跡
            case Tracking:
                // 追跡の設定の変更
                [self changeTracking:!isTracking_];
                break;
        }
    // 経路ボタンのメニューの項目が選択された場合
    } else if ([sender isMemberOfClass:[RouteButtonMenuTableViewController class]]) {
        // 「経路を消去」が選択された場合
        if (index == [stationRoutes_ count]) {
            // 経路が描画されたオーバーレイの除去
            [mapView removeOverlays:[mapView overlays]];
            
            // 経路検索で選択された駅のIDを初期化
            routingSelectedStationID_ = 0;
            
            // 出発地を含めた各アノテーションを初期化
            [self resetAnnotationsIncludingCurentLocationAnnotation:YES];

            // 駅の経路データの集合を解放
            [stationRoutes_ release], stationRoutes_ = nil;

            // 経路情報に関する表示を初期化
            [self initializeRouteInfoView];

            // ナビゲーションバーから経路ボタンを除去
            self.navigationItem.rightBarButtonItem = nil;
        // 周辺の駅の項目が選択された場合
        } else {
            // 選択された駅の経路データを格納
            StationRoute *stationRoute = [stationRoutes_ objectAtIndex:index];
            
            // 選択された駅の経路データが既に経路情報画面に設定されている場合
            if (stationRoute == routeInfoViewController_.stationRoute) {
                // 経路情報画面が表示されている場合は、経路情報画面を初期化
                if (!routeInfoViewController_.view.hidden) [routeInfoViewController_ initialize];
            } else {
                // 選択された駅の経路データを経路情報画面に設定して初期化
                routeInfoViewController_.stationRoute = stationRoute;
                [routeInfoViewController_ initialize];
            }
            
            // 経路情報画面を表示し、表示中フラグを設定
            routeInfoViewController_.view.hidden = NO;
            routeInfoViewController_.isOpening = YES;
            
            // 現在の道程の中心位置を設定
            [self setCurrentStepCenterLocation];
        }
    }
}

#pragma mark - デリゲートメソッド(RouteInfoViewControllerDelegate)

// 経路情報画面がタップされた時に実行される処理
- (void)RouteInfoViewTouched {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];
}

// 経路情報画面のボタンがタップされた時に実行される処理
- (void)RouteInfoViewButtonTouched {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];
    
    // 現在の道程の中心位置を設定
    [self setCurrentStepCenterLocation];
}

// 経路情報画面が閉じられた時に実行される処理
- (void)RouteInfoViewClosed {
    // 現在位置ボタンのメニューと経路ボタンのメニューを閉じる
    [currentLocationButtonMenuTableViewController closeMenu];
    [routeButtonMenuTableViewController closeMenu];
    
    // 経路情報に関する表示を初期化
    [self initializeRouteInfoView];
}

#pragma mark - 地図の描画

// 現在位置の地図の描画を試行する
- (void)tryDrawingMapOfCurrentLocation {
    // 位置情報が取得可能である場合
    if ([[LocationManager getInstance] locationServicesEnabled]) {
        // 現在位置の更新に関する通知を受け取ったらメソッドを実行するように設定
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(drawMapOfCurrentLocation)
                                                     name:LOCATION_UPDATE_SUCCEEDED_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelDrawingMapOfCurrentLocation)
                                                     name:LOCATION_UPDATE_FAILED_NOTIFICATION
                                                   object:nil];
        
        // 現在位置の更新を開始
        [[LocationManager getInstance] startUpdatingLocation];
        
        // 追跡中でない場合
        if (!isTracking_) {
            // インジケータを表示
            indicatorViewController_.message = LOCATION_UPDATE_MESSAGE;
            [self.navigationController.view addSubview:indicatorViewController_.view];
        }
        // 取得できない場合
    } else {
        // 現在位置の地図の描画の中断
        [self cancelDrawingMapOfCurrentLocation];
    }
}

// 現在位置の地図を描画する
- (void)drawMapOfCurrentLocation {
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 追跡中でない場合
    if (!isTracking_) {
        // インジケータの表示を解除
        [indicatorViewController_.view removeFromSuperview];
        
        // 現在位置を地図の中心に設定
        MKCoordinateRegion region = mapView.region;
        region.center = [LocationManager getInstance].location;
        region.span.latitudeDelta = CURRENT_LOCATION_MAP_RANGE_DEGREE;
        region.span.longitudeDelta = CURRENT_LOCATION_MAP_RANGE_DEGREE;
        [mapView setRegion:region animated:YES];
        // 追跡中である場合
    } else {
        // 現在位置を地図の中心に設定
        [mapView setCenterCoordinate:[LocationManager getInstance].location animated:YES];
    }
    
    // 現在日時の年月日の要素を取得
    NSInteger components = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:components fromDate:[NSDate date]];
    
    // 訪問対象の駅のIDの初期化
    visitTargetStationID_ = 0;
    
    // 各駅データを参照
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        // 現在参照している駅の訪問日が設定されている場合
        if (stationData.visitedDate) {
            // 訪問日の年月日が現在日時と等しい場合は、次の要素に処理を移す
            NSDateComponents *visitedDateComponents = [[NSCalendar currentCalendar] components:components fromDate:stationData.visitedDate];
            if (visitedDateComponents.year == currentDateComponents.year
                && visitedDateComponents.month == currentDateComponents.month
                && visitedDateComponents.day == currentDateComponents.day) continue;
        }
        
        // 緯度経度の下限・上限を算出
        double lowerLimitLatitude = [LocationManager getInstance].location.latitude - STATION_DEGREE_ERROR_ACCEPTABLE_RANGE;
        double higherLimitLatitude = [LocationManager getInstance].location.latitude + STATION_DEGREE_ERROR_ACCEPTABLE_RANGE;
        double lowerLimitLongitude = [LocationManager getInstance].location.longitude - STATION_DEGREE_ERROR_ACCEPTABLE_RANGE;
        double higherLimitLongitude = [LocationManager getInstance].location.longitude + STATION_DEGREE_ERROR_ACCEPTABLE_RANGE;
        
        // 現在参照している駅の緯度経度が下限と上限の間に収まっている場合
        if (stationData.location.latitude >= lowerLimitLatitude &&
            stationData.location.latitude <= higherLimitLatitude &&
            stationData.location.longitude >= lowerLimitLongitude &&
            stationData.location.longitude <= higherLimitLongitude) {
            // 現在参照している駅データのIDを訪問対象の駅のIDとして格納し、ループから抜ける
            visitTargetStationID_ = stationData.stationID;
            break;
        }
    }
 
    // 訪問対象の駅のIDが設定されているかどうかによって、訪問情報記録ボタンの表示を切り替え
    [self changeRecordVisitInfoButton:visitTargetStationID_];
}

// 現在位置の地図の描画を中断する
- (void)cancelDrawingMapOfCurrentLocation {
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 追跡中でない場合
    if (!isTracking_) {
        // エラーダイアログを表示
        [[Utility getInstance] showErrorDialog:LOCATION_UPDATE_FAILED_MESSAGE];
        
        // インジケータを非表示にする
        [indicatorViewController_.view removeFromSuperview];
    }
}

#pragma mark - アノテーションの設定

// 各アノテーションを再設定する
- (void)resetAnnotationsIncludingCurentLocationAnnotation:(BOOL)removeSourceLocationAnnotation {
    // 各アノテーションを参照
    for (id<MKAnnotation> annotation in mapView.annotations) {
        // 現在参照しているアノテーションが駅のものである場合
        if ([annotation isMemberOfClass:[StationAnnotation class]]) {
            // アノテーションの画像を設定            
            [mapView viewForAnnotation:annotation].image = [self annotationImageOfStationData:((StationAnnotation *) annotation).stationData];
        // 駅のものでも現在地のものでもない場合（出発地）
        } else if (![annotation isMemberOfClass:[MKUserLocation class]]) {
            // 出発地のアノテーションを削除するように指定されている場合は削除
            if (removeSourceLocationAnnotation) [mapView removeAnnotation:annotation];
        }
    }
}

// 指定された駅データに応じたアノテーション画像を返す
- (UIImage *)annotationImageOfStationData:(StationData *)stationData {
    // アノテーションの画像ファイル名を格納
    NSString *annotationImageFileName;
    
    // 指定された駅データが、経路検索で現在選択されている駅のものである場合
    if (stationData.stationID == routingSelectedStationID_) {
        // 選択された駅のアノテーション画像ファイル名を設定
        annotationImageFileName = SELECTED_STATION_ANNOTATION_IMAGE_FILE_NAME;
    // 選択されておらず現在閉店中である場合
    } else if (stationData.isClosing) {
        // 訪問済みかどうかに応じて、閉店中の駅のアノテーション画像ファイル名を設定
        annotationImageFileName = stationData.visitedDate ? CLOSING_VISITED_STATION_ANNOTATION_IMAGE_FILE_NAME : CLOSING_STATION_ANNOTATION_IMAGE_FILE_NAME;
    // 選択されておらず、現在閉店中でもなく、訪問済みに設定されている場合
    } else if (stationData.visitedDate) {
        // 訪問済みの駅のアノテーション画像ファイル名を設定
        annotationImageFileName = VISITED_STATION_ANNOTATION_IMAGE_FILE_NAME;
        // 上記に該当しない場合
    } else {
        // 通常の駅のアノテーション画像ファイル名を設定
        annotationImageFileName = STATION_ANNOTATION_IMAGE_FILE_NAME;
    }
    
    // 設定されたアノテーション画像ファイル名の画像を生成し、それを返す
    return [UIImage imageNamed:annotationImageFileName];
}

#pragma mark - 地図移動中のコントロールの表示の切り替え

// 各コントロールの表示の切り替えを行う
- (void)changeControlsView:(BOOL)shows {
    // ステータスバーとナビゲーションバーの表示の切り替え
    [[UIApplication sharedApplication] setStatusBarHidden:!shows];
    self.navigationController.navigationBar.hidden = !shows;
    
    // 現在位置ボタンのメニューと経路ボタンのメニューの表示の切り替え
    if (shows) {
        [currentLocationButtonMenuTableViewController unhideMenu];
        [routeButtonMenuTableViewController unhideMenu];
    } else {
        [currentLocationButtonMenuTableViewController hideMenu];
        [routeButtonMenuTableViewController hideMenu];
    }
    
    // 「訪問情報を記録」ボタンが透明でない場合は、表示を切り替え
    if (recordVisitInfoButton.alpha != 0) recordVisitInfoButton.hidden = !shows;
    
    // 経路情報画面に表示中フラグが設定されている場合は、経路情報画面の表示の切り替え
    if (routeInfoViewController_.isOpening) routeInfoViewController_.view.hidden = !shows;
}

#pragma mark - 通知の表示の切り替え

// 指定された値に応じて、通知表示欄の表示の切り替えを行う
- (void)changeNotificationView:(BOOL)shows {
    [UIView beginAnimations:@"Animations" context:NULL];
    [UIView setAnimationDuration:TRANSPARENT_VIEW_TOGGLE_TIME];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    {
        notificationLabel.alpha = shows ? TRANSPARENT_VIEW_ALPHA_VALUE: 0;
    }
    [UIView commitAnimations];
}

#pragma mark - 訪問情報記録ボタンの表示の切り替え

// 指定された値に応じて、訪問情報記録ボタンの表示の切り替えを行う
- (void)changeRecordVisitInfoButton:(BOOL)shows {
    [UIView beginAnimations:@"Animations" context:NULL];
    [UIView setAnimationDuration:TRANSPARENT_VIEW_TOGGLE_TIME];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    {
        recordVisitInfoButton.alpha = shows ? TRANSPARENT_VIEW_ALPHA_VALUE: 0;
    }
    [UIView commitAnimations];
}

#pragma mark - 追跡に関する処理

// 指定された値に応じて、追跡の設定を変更する
- (void)changeTracking:(BOOL)tracks {
    // 追跡フラグの設定
    isTracking_ = tracks;
    currentLocationButtonMenuTableViewController.isTracking = tracks;
    
    // ロック状態への遷移の可否を設定
    [UIApplication sharedApplication].idleTimerDisabled = tracks;
    
    // 現在位置ボタンを解放
    [currentLocationButton release];
    
    // 追跡する場合
    if (tracks) {
        // 現在位置追跡タイマーを開始(※このタイマーを非同期にした場合、地図画面をドラッグしている最中にも強制的に移動してしまうため、非同期にしない)
        [NSTimer scheduledTimerWithTimeInterval:TRACKING_TIMER_INTERVAL
                                         target:self
                                       selector:@selector(trackingTimerEvent:)
                                       userInfo:nil
                                        repeats:YES];
        
        // 追跡時のボタンを現在位置ボタンに設定
        currentLocationButton = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:100 
                                 target:self
                                 action:@selector(currentLocationButtonTouchUp)];
        // 追跡を終了する場合
    } else {
        // 現在位置の取得を停止
        [[LocationManager getInstance] stopUpdatingLocation];
        
        // 通常時のボタンを現在位置ボタンに設定
        currentLocationButton = [[UIBarButtonItem alloc] 
                                 initWithImage:[UIImage imageNamed:CURRENT_LOCATION_BUTTON_DEFAULT_IMAGE_NAME]
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(currentLocationButtonTouchUp)];
    }
    
    // 現在位置ボタンをナビゲーションバーに設定
    self.navigationItem.leftBarButtonItem = currentLocationButton;
}

#pragma mark - 経路に関する処理

// 指定された駅の経路データの集合を設定する
- (void)setStationRoutes:(NSArray *)stationRoutes routingType:(RoutingType)routingType {
    // 駅の経路データが空の場合は、処理を中断する
    if (!stationRoutes || [stationRoutes count] == 0) return;
    
    // 1か所目の駅の経路データを格納
    StationRoute *firstStationRoute = [stationRoutes objectAtIndex:0];
    
    // 現在地から経路が検索された場合は目的地、それ以外の場合は出発地の駅のIDを経路検索で選択された駅のIDとして格納
    routingSelectedStationID_ = (routingType == RoutingTypeFromCurrentLocation) ? firstStationRoute.destinationStationData.stationID
                                                                                : firstStationRoute.sourceStationData.stationID;
    
    // 出発地を含めた各アノテーションを再設定
    [self resetAnnotationsIncludingCurentLocationAnnotation:YES];
    
    // オーバーレイの除去
    [mapView removeOverlays:[mapView overlays]];
    
    // 各経路の各点の中で最低と最高の緯度と経度を格納(選択された駅の周辺の駅の経路が検索された場合のみ使用)
    double lowestLatitude = DBL_MAX;
    double highestLatitude = DBL_MIN;
    double lowestLongitude = DBL_MAX;
    double highestLongitude = DBL_MIN;
    
    // 駅の経路データの集合の各要素を参照
    for (int i = 0; i < [stationRoutes count]; i++) {
        // 現在参照している駅の経路データを取得
        StationRoute *stationRoute = [stationRoutes objectAtIndex:i];
        
        // 経路を構成する座標数の合計を算出
        int totalCoordinateCount = 0;
        for (StepObject *stepObject in stationRoute.routeObject.steps) totalCoordinateCount += [stepObject.polyLines count];
        
        // 座標が空の場合は、次の要素に処理を移す
        if (totalCoordinateCount == 0) continue;
        
        // 経路を構成する各座標データを格納
        CLLocationCoordinate2D coordinates[totalCoordinateCount];
        int index = 0;
        
        for (StepObject *stepObject in stationRoute.routeObject.steps) {
            for (int j = 0; j < [stepObject.polyLines count]; j++) {
                CLLocation *location = [stepObject.polyLines objectAtIndex:j];
                coordinates[index++] = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
                
                // 選択された駅の周辺の駅の経路が検索された場合
                if (routingType == RoutingTypeToSurroundingStations) {
                    // これまでの緯度・経度の最低値より低い、または最高値よりも高い場合は値を格納
                    if (location.coordinate.latitude < lowestLatitude) lowestLatitude = location.coordinate.latitude;
                    if (location.coordinate.latitude > highestLatitude) highestLatitude = location.coordinate.latitude;
                    if (location.coordinate.longitude < lowestLongitude) lowestLongitude = location.coordinate.longitude;
                    if (location.coordinate.longitude > highestLongitude) highestLongitude = location.coordinate.longitude;
                }
            }
        }
        
        // 経路の線の生成
        RouteLine *routeLine = (RouteLine *) [RouteLine polylineWithCoordinates:coordinates count:totalCoordinateCount];
        
        // 線の色の値を格納
        float redValue = 0;
        float greenValue = 0;
        float blueValue = 0;
        
        // 色の種類が最高で(colorDegreeCount * colorDivisionCount)種類になるように色の値を設定
        const int colorDivisionCount = 3;
        const int colorDegreeCount = 3;
        float colorValue = (i % colorDegreeCount) * ((float) 1 / (colorDegreeCount - 1));
        
        switch ((i % (colorDegreeCount * colorDivisionCount)) / colorDegreeCount) {
            // 001→011
            case 0:
                redValue = 0;
                greenValue = colorValue;
                blueValue = 1;
                break;
            // 010→110
            case 1:
                redValue = colorValue;
                greenValue = 1;
                blueValue = 0;
                break;
            // 101→001
            default:
                redValue = 1 - colorValue;
                greenValue = 0;
                blueValue = 1;
                break;
        }
        
        // 経路の線に色を設定
        routeLine.color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:ROUTE_LINE_ALPHA_VALUE];
        //        NSLog(@"red: %f, green: %f, blue: %f", redValue, greenValue, blueValue);
        
        // 地図画面に経路の線のオーバーレイを追加
        [mapView addOverlay:routeLine];
    }
    
    // 中心点の位置情報を格納
    CLLocationCoordinate2D centerLocation;
    
    // 緯度と経度の差分を格納
    double latitudeDelta;
    double longitudeDelta;
    
    // 出発地(現在地からの経路が検索された場合は現在地、それ以外の場合は選択された駅)の位置座標を格納
    CLLocationCoordinate2D sourceLocation;
    sourceLocation.latitude = firstStationRoute.routeObject.startLocationLat;
    sourceLocation.longitude = firstStationRoute.routeObject.startLocationLng;
    
    // 選択された駅の周辺の駅の経路が検索された場合
    if (routingType == RoutingTypeToSurroundingStations) {
        // 緯度・経度の最高値と最低値の差分を設定
        latitudeDelta = highestLatitude - lowestLatitude;
        longitudeDelta = highestLongitude - lowestLongitude;

        // 中間点の緯度と経度を中心点として設定
        centerLocation.latitude = lowestLatitude + (latitudeDelta / 2);
        centerLocation.longitude = lowestLongitude + (longitudeDelta / 2);
    // 現在地から選択された駅、または任意の駅への経路が検索された場合
    } else {
        // 現在地からの経路が検索された場合
        if (routingType == RoutingTypeFromCurrentLocation) {
            // 現在地を出発地としたアノテーションを生成して地図画面に設定
            Annotation *annotation = [[Annotation alloc] initWithCoordinate:sourceLocation title:SOURCE_LOCATION_ANNOTATION_TITLE];
            [mapView addAnnotation:annotation];
            [annotation release];
        }

        // 出発地と目的地の駅の緯度と経度の差を格納
        latitudeDelta = sourceLocation.latitude - firstStationRoute.routeObject.endLocationLat;
        longitudeDelta = sourceLocation.longitude - firstStationRoute.routeObject.endLocationLng;

        // 中間点の緯度と経度を中心点として設定
        centerLocation.latitude = sourceLocation.latitude - (latitudeDelta / 2);
        centerLocation.longitude = sourceLocation.longitude - (longitudeDelta / 2);
    }
    
    // 緯度の差分と中心を補正(ステータスバー・ナビゲーションバー・タブバーの領域分を補正するため)
    latitudeDelta = fabs(latitudeDelta) * self.view.bounds.size.height / mapView.bounds.size.height;
    centerLocation.latitude += latitudeDelta * ((mapView.bounds.size.height - self.view.bounds.size.height) / 2) / mapView.bounds.size.height;
    
    // 出発地と目的地の中間点が中心になるように地図の位置を設定
	MKCoordinateRegion region;
	region.center = centerLocation;
	region.span.latitudeDelta = latitudeDelta;
	region.span.longitudeDelta = fabs(longitudeDelta);
    [mapView setRegion:region animated:YES];
    
    // 経路ボタンのメニューの各セルの見出しを生成
    NSMutableArray *routeButtonMenuCellCaptions = [[NSMutableArray alloc] initWithCapacity:[stationRoutes count]];
    
    for (StationRoute *stationRoute in stationRoutes) {
        [routeButtonMenuCellCaptions addObject:[NSString stringWithFormat:@"→%@", stationRoute.destinationStationData.name]];
    }

    // セルの見出しの集合を経路ボタンのメニューに設定
    [routeButtonMenuTableViewController setCellCaptions:routeButtonMenuCellCaptions];
    [routeButtonMenuCellCaptions release];

    // ナビゲーションバーに経路ボタンを設定
    self.navigationItem.rightBarButtonItem = routeButton;

    // 駅の経路データの集合を格納
    [stationRoutes_ release];
    stationRoutes_ = [stationRoutes retain];
    
    // 経路情報に関する表示を初期化
    [self initializeRouteInfoView];
}

// 経路情報に関する表示を初期化する
- (void)initializeRouteInfoView {
    // 経路情報画面を非表示にし、表示中フラグを解除
    routeInfoViewController_.view.hidden = YES;
    routeInfoViewController_.isOpening = NO;

    // 現在の道程の位置の画像表示欄を非表示にする
    currentStepCenterLocationCircleImageView_.hidden = YES;
}

// 現在の道程の中心位置を設定する
- (void)setCurrentStepCenterLocation {
    // 現在の道程の中心位置の円の表示欄が生成されていない場合
    if (!currentStepCenterLocationCircleImageView_) {
        // 円の表示欄を生成
        currentStepCenterLocationCircleImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CURRENT_STEP_CENTER_LOCATION_IMAGE_FILE_NAME]];
        currentStepCenterLocationCircleImageView_.alpha = CURRENT_STEP_CENTER_LOCATION_IMAGE_ALPHA_VALUE;
        
        // 円の表示欄を非表示にして地図画面に追加
        currentStepCenterLocationCircleImageView_.hidden = YES;
        [mapView addSubview:currentStepCenterLocationCircleImageView_];
    }
    
    // 現在選択されている道程の開始位置を中心とした位置情報を生成
    MKCoordinateRegion region = mapView.region;
    region.center = [routeInfoViewController_ currentStepStartLocation];
    region.span.latitudeDelta = ROUTE_INFO_MAP_RANGE_DEGREE;
    region.span.longitudeDelta = ROUTE_INFO_MAP_RANGE_DEGREE;
    
    // アニメーションの実行
    [UIView animateWithDuration:CURRENT_STEP_CENTER_LOCATION_ANIMATION_DURATION delay:0 options:0
        animations:^{
            // 現在の道程の中心位置の円の表示欄を一旦非表示にした上で地図画面の中心位置を設定
            currentStepCenterLocationCircleImageView_.hidden = YES;
            mapView.region = region;
        }completion:^(BOOL finished){
            // 現在の道程の中心位置の円の表示欄を表示した上で移動
            currentStepCenterLocationCircleImageView_.hidden = NO;
            [self moveCurrentStepCenterLocationCircle];
    }];
}

// 現在の道程の中心位置の円の表示欄を現在の中心位置に移動する
- (void)moveCurrentStepCenterLocationCircle {
    // 円の表示欄が生成され、表示されている場合は、円の位置を現在の道程の中心位置に設定
    if (currentStepCenterLocationCircleImageView_ && !currentStepCenterLocationCircleImageView_.hidden) {
        currentStepCenterLocationCircleImageView_.center = [mapView convertCoordinate:[routeInfoViewController_ currentStepStartLocation] toPointToView:mapView];
    }
}

@end
