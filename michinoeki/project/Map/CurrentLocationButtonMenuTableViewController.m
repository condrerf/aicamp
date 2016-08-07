//
//  CurrentLocationButtonMenuTableViewController2.m
//  MichiNoEki
//
//  Created by  on 11/09/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CurrentLocationButtonMenuTableViewController.h"
#import "Constants.h"

@implementation CurrentLocationButtonMenuTableViewController

@synthesize isTracking;

#pragma mark - 初期化・終端処理

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // セルの各見出しを設定
        captions_ = [[NSArray alloc] initWithObjects:CURRENT_LOCATION_BUTTON_MENU_CELL_CAPTIONS, nil];
        captions2_ = [[NSArray alloc] initWithObjects:CURRENT_LOCATION_BUTTON_MENU_CELL_CAPTIONS2, nil];
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [captions2_ release], captions2_ = nil;
    
    [super dealloc];
}

#pragma mark - テーブルに関するイベント

// 指定されたインデックスの行が選択されようとしている時に実行される処理
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 「現在位置」が選択されようとしていて、位置の追跡を現在行っている場合は、選択不可にする
    return (indexPath.row == CurrentLocation && isTracking) ? nil : indexPath;
}

#pragma mark - オーバーライドメソッド

// メニューの位置を移動する
- (void)moveMenuPosition:(BOOL)shows {
    // 表示を行う場合
    if (shows) {
        // メニューの各セルを格納
        UITableViewCell *currentLocationCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CurrentLocation inSection:0]];
        UITableViewCell *trackLocationCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Tracking inSection:0]];
        
        // 現在位置の追跡を行っている場合
        if (isTracking) {
            // 追跡時の表示内容に設定
            currentLocationCell.textLabel.textColor = [UIColor grayColor];
            trackLocationCell.textLabel.text = [captions2_ objectAtIndex:Tracking];
            // 行っていない場合
        } else {
            // 通常時の表示内容に設定
            currentLocationCell.textLabel.textColor = [UIColor whiteColor];
            trackLocationCell.textLabel.text = [captions_ objectAtIndex:Tracking];
        }
    }
    
    // 親クラスの同メソッドを実行
    [super moveMenuPosition:shows];
}

@end