//
//  StationSelectViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StationSelectViewController.h"
#import "StationDataListWithoutDetail.h"

@implementation StationSelectViewController

@synthesize delegate;
@synthesize stationTableView;
@synthesize cancelButton;

// 指定された駅のIDを使用して自身を初期化する
- (id)initWithStationID:(int)stationID {
    self = [self initWithNibName:@"StationSelectView" bundle:nil];
    
    if (self) {
        // 駅データの集合を初期化
        stationDataArray_ = [[NSMutableArray alloc] initWithCapacity:[[StationDataListWithoutDetail getInstance].stationDataList count] - 1];
        
        // 共有している駅データの各要素を参照
        for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
            // 現在参照している駅データのIDが指定されたIDと異なる場合は、集合に追加
            if (stationData.stationID != stationID) [stationDataArray_ addObject:stationData];
        }
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトを解放
    [stationDataArray_ release], stationDataArray_ = nil;
    
    // 各コントロールを解放
    [stationTableView release], stationTableView = nil;
    [cancelButton release], cancelButton = nil;
    
    [super dealloc];
}

// 表示するセルの行数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stationDataArray_ count];
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
    cell.textLabel.text = ((StationData *) [stationDataArray_ objectAtIndex:indexPath.row]).name;
    
    return cell;
}

// 指定された行のセルが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 現在参照しているセルの行番号に応じた駅データを格納
    StationData *stationData = [stationDataArray_ objectAtIndex:indexPath.row];
    
    // 行選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(stationSelectViewCellSelectedStationData:)]) [self.delegate stationSelectViewCellSelectedStationData:stationData];
}

// キャンセルボタンがタップされた時に実行される処理
- (IBAction)cancelButtonTouchUp {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(stationSelectViewCancelButtonTouched)])
        [self.delegate stationSelectViewCancelButtonTouched];
}

@end