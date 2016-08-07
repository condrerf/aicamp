//
//  RouteButtonMenuTableViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RouteButtonMenuTableViewController.h"
#import "Constants.h"

// 非公開メソッドのカテゴリ
@interface RouteButtonMenuTableViewController(PrivateMethods)
- (void)setCellCaptions:(NSArray *)_captions;
- (void)setCellCaptionsColor;
@end

@implementation RouteButtonMenuTableViewController

// 行が選択されていないことを示す行の索引値
static int SELECTED_ROW_INDEX_NOT_SELECTED = -1;

#pragma mark - 初期化・終端処理

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // 右寄せ表示を行うように設定
        isAlignmentRight_ = YES;
        
        // 初期化
        [self initialize];
    }
    
    return self;
}

#pragma mark - テーブルに関するイベント

// 指定されたセルが表示される時に実行される処理
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 指定されたセルが「経路を消去」に該当する場合は、セルの背景色を灰色に設定
    if (indexPath.row == [captions_ count] - 1) [cell setBackgroundColor:[UIColor grayColor]];
}

// 指定された行のセルが選択された時に実行される処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 親クラスの同メソッドを実行
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    // 行の索引を格納(最終行(「経路を消去」)が選択された場合は初期値を格納)
    selectedRowIndex_ = (indexPath.row == [captions_ count] - 1) ? SELECTED_ROW_INDEX_NOT_SELECTED : indexPath.row;
}

#pragma mark - オーバーライドメソッド

// メニューの位置を移動する
- (void)moveMenuPosition:(BOOL)shows {
    // 行が選択されており、メニューの表示が要求されている場合は、各セルの見出しの文字色を設定
    if (selectedRowIndex_ != SELECTED_ROW_INDEX_NOT_SELECTED && shows) [self setCellCaptionsColor];
    
    // 親クラスの同メソッドを実行
    [super moveMenuPosition:shows];
}

#pragma mark - パブリックメソッド

// 初期化処理
- (void)initialize {
    // 選択された行の索引を初期化
    selectedRowIndex_ = SELECTED_ROW_INDEX_NOT_SELECTED;
    
    // 各セルの見出しの文字色を設定
    [self setCellCaptionsColor];
}

// 指定されたセルの見出しの集合を設定する
- (void)setCellCaptions:(NSArray *)_captions {
    // 指定されたセルの見出しの集合に「経路を消去」の要素を追加して格納
    NSMutableArray *captions = [[NSMutableArray alloc] initWithArray:_captions];
    [captions addObject:ROUTE_BUTTON_MENU_DELETE_ROUTES_CAPTION];
    [captions_ release];
    captions_ = captions;
    
    // メニューを再設定
    [self resizeMenu];
    [self.tableView reloadData];
    [self initialize];
}

#pragma mark - プライベートメソッド

// 各セルの見出しの文字色を設定する
- (void)setCellCaptionsColor {
    // 各セルを参照
    for (int i = 0; i < [captions_ count]; i++) {
        // 現在参照しているセルを取得
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        // セルの行が選択されているかどうかによって見出しの文字色を設定
        cell.textLabel.textColor = (i == selectedRowIndex_) ? [UIColor blueColor] : [UIColor whiteColor];
    }
}

@end
