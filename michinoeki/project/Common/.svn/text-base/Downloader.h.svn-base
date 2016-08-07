//
//  Downloader.h
//  MichiNoEki
//
//  Created by  on 11/09/13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate;

//typedef enum {
//    DataTypeXML = 0,
//    DataTypeJSON
//} DataType;

// ダウンロード管理クラス(※祝日データの取得のために作成したものの使用していないが、折角なので保管)
@interface Downloader : NSObject {
    id<DownloaderDelegate> delegate;
    NSMutableData *downloadData_;
}

@property (nonatomic, assign) id<DownloaderDelegate> delegate;

- (void)downloadWithURL:(NSString *)url;

@end

// デリゲートプロトコル
@protocol DownloaderDelegate<NSObject>
- (void)downloaded:(NSData *)data;
@optional
- (void)downloadFailedMessage:(NSString *)errorMessage;
@end