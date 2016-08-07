//
//  PhotoStationSelectViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoStationSelectViewController.h"
#import "Constants.h"
#import "StationDataListWithoutDetail.h"

@implementation PhotoStationSelectViewController

@synthesize delegate;
@synthesize nearestStationButton;
@synthesize stationTableView;
@synthesize cancelButton;

// 指定された最寄駅のIDを使用して自身を初期化する
- (id)initWithNearestStationID:(int)stationID {
    self = [self initWithNibName:@"PhotoStationSelectView" bundle:nil];
    
    if (self) {
        // 共有している駅データの各要素を参照
        for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
            // 現在参照している駅データのIDが指定されたIDと等しい場合
            if (stationData.stationID == stationID) {
                // 駅データを最寄駅のデータとして格納してループから抜ける
                nearestStationData_ = [stationData retain];
                break;
            }
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 最寄駅のデータが設定されている場合
    if (nearestStationData_) {
        // 文字列を最寄駅ボタンに設定
        [nearestStationButton setTitle:[NSString stringWithFormat:NEAREST_STATION_BUTTON_FORMAT, nearestStationData_.name] forState:UIControlStateNormal];
    // 設定されていない場合
    } else {
        // 最寄駅検索失敗時の文字列を最寄駅ボタンに設定
        [nearestStationButton setTitle:NEAREST_STATION_BUTTON_TEXT_SEARCH_FAILED forState:UIControlStateNormal];

        // ボタンが押せないように設定
        nearestStationButton.enabled = NO;

        // 最寄駅ボタンの文字列の色を灰色に設定
        nearestStationButton.titleLabel.textColor = [UIColor grayColor];
    }
}

- (void)dealloc {
    // 各オブジェクトを解放
    [nearestStationData_ release], nearestStationData_ = nil;
    
    // 各コントロールを解放
    [nearestStationButton release], nearestStationButton = nil;
    [stationTableView release], stationTableView = nil;
    [cancelButton release], cancelButton = nil;
    
    [super dealloc];
}

// 表示するセルの行数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StationDataListWithoutDetail getInstance].stationDataList count];
}

// テーブルビューが操作され、上下いずれかのセルが画面に表示される時の処理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルを格納
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

    // 駅名を設定
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];
    cell.textLabel.text = stationData.name;
    
    return cell;
}

// 指定された行のセルが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 行選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 現在参照しているセルの行番号に応じた駅データを格納
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];

    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(photoStationSelectViewCellSelectedStationID:)]) [self.delegate photoStationSelectViewCellSelectedStationID:stationData.stationID];
}

// 最寄駅ボタンがタップされた時に実行される処理
- (IBAction)nearestStationButtonTouchUp {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(photoStationSelectViewCellSelectedStationID:)]) 
        [self.delegate photoStationSelectViewCellSelectedStationID:nearestStationData_.stationID];
}

// キャンセルボタンがタップされた時に実行される処理
- (IBAction)cancelButtonTouchUp {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(photoStationSelectViewCancelButtonTouched)])
        [self.delegate photoStationSelectViewCancelButtonTouched];
}

@end
