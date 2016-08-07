//
//  Utility.m
//  MichiNoEki
//
//  Created by  on 11/08/29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "Constants.h"

#include <sys/types.h> 
#include <sys/sysctl.h>

@implementation Utility

@synthesize weekdayCharacters;
@synthesize platform;

// 自身のインスタンス
static Utility *instance = nil;

#pragma mark - クラスメソッド

// 自身のインスタンスを返す(シングルトンパターン)
+ (Utility *) getInstance {
    // インスタンスが生成されていない場合は生成 // 位置情報が取得可能か
	@synchronized(self) {
		if (!instance) {
            instance = [[self alloc] init];
        }
	}
	
    return instance;
}

#pragma mark - 初期化・終端処理

- (id)init {
    self = [super init];
    
    if (self) {
        // 曜日の各文字を集合に格納
        weekdayCharacters = [[NSMutableArray alloc] initWithCapacity:DAYS_OF_THE_WEEK.length];
        for (int i = 0; i < DAYS_OF_THE_WEEK.length; i++) [weekdayCharacters addObject:[DAYS_OF_THE_WEEK substringWithRange:NSMakeRange(i, 1)]];
        
        // プラットフォーム情報を格納
        size_t size; 
        sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
        char *machine = malloc(size); 
        sysctlbyname("hw.machine", machine, &size, NULL, 0); 
        platform = [[NSString stringWithCString:machine encoding:NSUTF8StringEncoding] retain]; 
        free(machine);
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [weekdayCharacters release], weekdayCharacters = nil;
    [platform release], platform = nil;
    
    [super dealloc];
}

#pragma mark - 各種処理

// 指定されたメッセージとタイトルによるダイアログを表示する
- (void)showDialogWithMessage:(NSString *)message title:(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

// 指定されたメッセージを表示し、指定されたタグを持つ確認ダイアログを表示し、指定された移譲先に選択結果を返す
- (void)showConfirmationDialogWithMessage:(NSString *)message tag:(int)tag delegate:(id)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.tag = tag;
    alertView.delegate = delegate;
    alertView.title = @"確認";
    alertView.message = message;
    [alertView addButtonWithTitle:@"はい"];
    [alertView addButtonWithTitle:@"いいえ"];
    [alertView show];
    [alertView release];
}

// 指定されたメッセージによるエラーダイアログを表示する
- (void)showErrorDialog:(NSString *)message {
    [self showDialogWithMessage:message title:@"エラー"];
}

// 指定されたナビゲーションアイテムに対し、タイトルの幅に応じてフォントサイズを調整するように設定する
- (void)setAdjustFontSizeOfNavigationItem:(UINavigationItem *)navigationItem {
    // ラベルを生成(※フォントサイズの調整の設定以外は、元のナビゲーションアイテムのタイトルに設定されているラベルの設定と同じ)
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = navigationItem.title;
    [label sizeToFit];
    label.adjustsFontSizeToFitWidth = YES;
    
    // ナビゲーションアイテムにラベルを設定
    navigationItem.titleView = label;
    [label release];
}

// 指定されたIDの駅の写真ディレクトリのパスを返す
- (NSString *) photoDirectoryPathWithStationID:(int)stationID {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:PHOTO_DIRECTORY_FORMAT, stationID]];
}

@end
