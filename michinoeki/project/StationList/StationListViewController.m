//
//  StationListViewController.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationListViewController.h"
#import "Constants.h"
#import "Utility.h"
#import "StationDataListWithoutDetail.h"
#import "StationListTableViewCell.h"
#import "StationInfoViewController.h"

@implementation StationListViewController

#pragma mark - テーブルに関するイベント

// 選択可能な行数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StationDataListWithoutDetail getInstance].stationDataList count];
}

// 指定された索引の行の高さを返す
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STATION_LIST_CELL_HEIGHT;
}

// テーブルビューが操作され、指定されたセルの表示が要求された時に実行される処理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルを格納
    static NSString *CellIdentifier = @"StationListTableViewCell";
    StationListTableViewCell *cell = (StationListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = (StationListTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]
                                             objectAtIndex:0];
	}
    
    // 現在参照しているセルの行番号に応じた駅データを格納
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];
    
    // 各コントロールを表示
    cell.stationIDLabel.text = [NSString stringWithFormat:@"%d", stationData.stationID];
    cell.stationImageView.image = [UIImage imageNamed:
                                   [NSString stringWithFormat:STATION_IMAGE_FILE_FORMAT, stationData.stationID]];
    cell.nameLabel.text = stationData.name;
    cell.rubiLabel.text = stationData.rubi;
    
    // 現在参照している駅データに訪問日が設定されている場合
    if (stationData.visitedDate) {
        // 訪問日を画面に設定
        NSDateComponents *date_components = [[NSCalendar currentCalendar]
                                             components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
                                               fromDate:stationData.visitedDate];
        cell.visitedDateLabel.text = [NSString stringWithFormat:VISITED_STATION_TEXT_FORMAT,
                                               date_components.year,
                                               date_components.month,
                                               date_components.day];
        cell.visitedDateLabel.textColor = VISITED_STATION_TEXT_COLOR;
    } else {
        cell.visitedDateLabel.text = NOT_VISITED_STATION_TEXT;
        cell.visitedDateLabel.textColor = NOT_VISITED_STATION_TEXT_COLOR;
    }
    
    return cell;
}

// 指定された行のセルが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 遷移先で表示される戻るボタンを設定(※設定しないと、当画面のナビゲーションバーの文字列がボタンに設定される)
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"駅一覧"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    [backButtonItem release];

    // 詳細画面のオブジェクトを生成
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];
    StationInfoViewController *stationInfoViewController = [[StationInfoViewController alloc] initWithStationID:stationData.stationID];
    
    // 詳細画面を表示
    [self.navigationController pushViewController:stationInfoViewController animated:YES];
    
    // オブジェクトを解放
    [stationInfoViewController release];
    
    // 行選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
