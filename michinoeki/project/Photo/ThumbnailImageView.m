//
//  PhotoThumbnailImageView.m
//  MichiNoEki
//
//  Created by  on 11/09/02.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ThumbnailImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation ThumbnailImageView

@synthesize filePath;
@synthesize originalFilePath;
@synthesize exportIconImageView;
@synthesize deleteIconImageView;

- (id)initWithFilePath:(NSString *)_filePath originalFilePath:(NSString *)_originalFilePath {
    // 指定されたファイルパスの画像で自身を初期化
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:_filePath];
    self = [super initWithImage:image];
    [image release];
    
    if (self) {
        // 縮尺を維持して画像を表示するように設定
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        // 自身の外枠に線を設定
        self.layer.borderWidth = PHOTO_THUMBNAIL_BORDER_WIDTH;
        self.layer.borderColor = [BAR_GRADATION_START_COLOR CGColor];

        // サムネイル画像と元の画像ファイルのパスを格納
        filePath = [_filePath copy];
        originalFilePath = [_originalFilePath copy];
        
        // 外部出力アイコンの表示欄と削除アイコンの表示欄を生成
        exportIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:EXPORT_ICON_FILE_NAME]];
        deleteIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DELETE_ICON_FILE_NAME]];

        // 外部出力アイコンの表示欄と削除アイコンの表示欄の表示位置を設定
        CGRect iconImageViewFrame = exportIconImageView.frame;
        iconImageViewFrame.origin.x = self.bounds.size.width - iconImageViewFrame.size.width - PHOTO_THUMBNAIL_BORDER_WIDTH - 1;
        iconImageViewFrame.origin.y = self.bounds.size.height - iconImageViewFrame.size.height - PHOTO_THUMBNAIL_BORDER_WIDTH - 1;
        exportIconImageView.frame = iconImageViewFrame;
        deleteIconImageView.frame = iconImageViewFrame;
        
        // 外部出力アイコンの表示欄と削除アイコンの表示欄を非表示にする
        exportIconImageView.hidden = YES;
        deleteIconImageView.hidden = YES;

        // 外部出力アイコンの表示欄と削除アイコンの表示欄を自身に追加
        [self addSubview:exportIconImageView];
        [self addSubview:deleteIconImageView];
    }
    
    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [filePath release], filePath = nil;
    [originalFilePath release], originalFilePath = nil;
    
    // 各コントロールの解放
    [exportIconImageView release], exportIconImageView = nil;
    [deleteIconImageView release], deleteIconImageView = nil;
    
    [super dealloc];
}

@end
