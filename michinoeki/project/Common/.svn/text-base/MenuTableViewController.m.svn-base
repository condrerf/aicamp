//
//  MenuTableViewController.m
//  MichiNoEki
//
//  Created by  on 11/09/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MenuTableViewController.h"
#import "Constants.h"

@implementation MenuTableViewController

@synthesize delegate;

// 1文字ごとの幅の付加値
static int ADDITIONAL_CHARACTER_WIDTH = 4;

#pragma mark - 初期化・終端処理

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // メニューの大きさを再設定
    [self resizeMenu];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [captions_ release], captions_ = nil;
    
    [super dealloc];
}

#pragma mark - テーブルに関するイベント

// 表示するセルの行数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [captions_ count];
}

// セルの高さとなる値を返す
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PULL_DOWN_MENU_CELL_HEIGHT;
}

// テーブルビューが操作され、指定されたセルの表示が要求された時に実行される処理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 既にセルが生成されている場合は取得
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // セルが生成されていない場合
    if (cell == nil) {
        // セルの生成
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:PULL_DOWN_MENU_CELL_FONT_SIZE];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = (isAlignmentRight_) ? UITextAlignmentRight : UITextAlignmentLeft;
    }
    
    // 各コントロールを表示
    cell.textLabel.text = [captions_ objectAtIndex:indexPath.row];
    
    return cell;
}

// 指定された行のセルが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(didSelectMenuItem:index:)]) [self.delegate didSelectMenuItem:self index:indexPath.row];
    
    // 行選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // メニューを閉じる
    [self closeMenu];
}

#pragma mark - メニューの大きさの再設定

// メニューの大きさを再設定する
- (void)resizeMenu {
    // メニューの幅を格納
    int maxCharacterCount = 0;
    for (NSString *caption in captions_) if (caption.length > maxCharacterCount) maxCharacterCount = caption.length;
    int width = MIN((PULL_DOWN_MENU_CELL_FONT_SIZE + ADDITIONAL_CHARACTER_WIDTH) * maxCharacterCount, [UIScreen mainScreen].bounds.size.width);
    
    // X位置を格納
    int xPosition = isAlignmentRight_ ? [UIScreen mainScreen].bounds.size.width - width : 0;
    
    // 高さを格納
    int rowCount = [captions_ count];
    CGFloat height = (rowCount == 0) ? 0 : PULL_DOWN_MENU_CELL_HEIGHT * rowCount - 1;
    
    // 位置と大きさを設定
    self.view.frame = CGRectMake(xPosition, -height, width, height);
}

#pragma mark - メニューの表示に関するメソッド

// メニューを表示しているかどうかを返す
- (BOOL)isShowingMenu {
    return (self.view.frame.origin.y == 0);
}

// メニューを表示する
- (void)showMenu {
    // 現在メニューを表示していない場合、メニューを表示
    if (![self isShowingMenu]) [self moveMenuPosition:YES];
}

// メニューを閉じる
- (void)closeMenu {
    // 現在メニューを表示している場合、メニューを閉じる
    if ([self isShowingMenu]) [self moveMenuPosition:NO];
}

// メニューを非表示にする
- (void)hideMenu {
    self.view.hidden = YES;
}

// メニューを非表示状態から戻す
- (void)unhideMenu {
    self.view.hidden = NO;
}

// メニューの位置を移動する
- (void)moveMenuPosition:(BOOL)shows {
    // 切り替え後の位置データを生成
    int yPosition = (shows ? 0 : -self.view.frame.size.height);
    CGRect rect = CGRectMake(self.view.frame.origin.x,
                             yPosition,
                             self.view.frame.size.width,
                             self.view.frame.size.height);
    
    // 位置の移動
    [UIView beginAnimations:@"Animations" context:NULL];
    [UIView setAnimationDuration:PULL_DOWN_MENU_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    {
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

@end
