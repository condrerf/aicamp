//
//  Downloader.m
//  MichiNoEki
//
//  Created by  on 11/09/13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

@synthesize delegate;

#pragma mark - 初期化・終端処理

- (void)dealloc {
    // 各オブジェクトの解放
    [downloadData_ release], downloadData_ = nil;
    
    [super dealloc];
}

#pragma mark - 接続処理

// 指定されたURLに接続する
- (void)downloadWithURL:(NSString *)url {
    // URLが空の場合は処理を中断する
    if (!url) return;
    
    // 指定されたURLに接続
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
}

#pragma mark - デリゲートメソッド(NSURLConnectionDelegate)

// ダウンロードが開始された時に実行される処理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// ダウンロードデータオブジェクトの初期化
	[downloadData_ release];
    downloadData_ = [[NSMutableData alloc] init];
}

// データの一部がダウンロードされた時に実行される処理
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // ダウンロードされたデータをオブジェクトに追加
	[downloadData_ appendData:data];
}

// ダウンロードが完了した時に実行される処理
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(downloaded:)]) [self.delegate downloaded:downloadData_];
}

// ダウンロードに失敗した時に実行される処理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // エラーメッセージを格納
    NSString *errorMessage = [error description];

    // エラー内容をログ出力
    NSLog(@"error: %@", errorMessage);

    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(downloadFailedMessage:)]) [self.delegate downloadFailedMessage:errorMessage];
}

@end
