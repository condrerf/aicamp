//
//  DatabaseBase.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseBase.h"
#import "Constants.h"

@implementation DatabaseBase

// 初期化処理
- (id)init {
    self = [super init];
    
    if (self) {
        // Documentsフォルダ内のデータベースファイルのパスを取得
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *databasePath = [documentsPath stringByAppendingPathComponent:DATABASE_NAME];

        // データベースファイルがDocumentsフォルダに存在しない場合(初回起動時)
        if(![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
            // オリジナルのデータベースファイルのパスを取得
            NSString *originalDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
            
            // Documentsフォルダへのコピーに失敗した場合
            NSError *error = nil;
            if(![[NSFileManager defaultManager] copyItemAtPath:originalDatabasePath toPath:databasePath error:&error]) {
                // エラーログの出力
                NSLog(@"データベースファイルのコピーに失敗: %@", [error description]);
            }
        }

        // データベースファイルが開けなかった場合
        if (sqlite3_open([databasePath UTF8String], &database_) != SQLITE_OK) {
            // エラーログの出力
            NSLog(@"データベースファイルが開けませんでした");
        }

        // 日付の書式を設定
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateFormat:@"yyyy/MM/dd"];
    }
    
    return self;
}

// 終端処理
- (void)dealloc {
    // データベースを開いている場合
    if (database_) {
        // データベースのクローズ
        sqlite3_close(database_);
        database_ = NULL;
    }

    // 各オブジェクトの解放
    [dateFormatter_ release], dateFormatter_ = nil;

    [super dealloc];
}

// データベースに接続できるかどうかを返す
- (BOOL)isConnectable {
    return (database_ != NULL);
}

@end
