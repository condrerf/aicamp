//
//  PhotoViewerViewController.m
//  MichiNoEki
//
//  Created by  on 11/08/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import "Constants.h"
#import "Utility.h"

// 非公開メソッドのカテゴリ
@interface PhotoViewerViewController(PrivateMethods)
- (void)imageViewTapped;
- (void)savedDateLabelTapped;
@end

@implementation PhotoViewerViewController

@synthesize imageView;
@synthesize savedDateLabel;

// 指定された写真ファイルのパスで初期化する
- (id)initWithPhotoFilePath:(NSString *)photoFilePath {
    self = [self initWithNibName:@"PhotoViewer" bundle:nil];
    
    if (self) {
        // 写真画像を格納
        photoImage_ = [[UIImage alloc] initWithContentsOfFile:photoFilePath];
        
        // ファイル名を格納
        fileName_ = [[[photoFilePath componentsSeparatedByString:@"/"] lastObject] retain];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 写真画像を画像の表示欄に設定
    imageView.image = photoImage_;
    
    // ファイル名から保存日時を設定
    int savedYear = [[fileName_ substringToIndex:4] intValue];
    int savedMonth = [[fileName_ substringWithRange:NSMakeRange(4, 2)] intValue];
    int savedDay = [[fileName_ substringWithRange:NSMakeRange(6, 2)] intValue];
    int savedHour = [[fileName_ substringWithRange:NSMakeRange(8, 2)] intValue];
    int savedMinute = [[fileName_ substringWithRange:NSMakeRange(10, 2)] intValue];
    savedDateLabel.text = [NSString stringWithFormat:SAVED_DATE_TEXT_FORMAT, savedYear, savedMonth, savedDay, savedHour, savedMinute];

    // 画像の表示欄にタップイベントを検出するクラスを設定
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(imageViewTapped)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    // 保存日の表示欄にタップイベントを検出するクラスを設定
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savedDateLabelTapped)];
    [savedDateLabel addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];

    // ステータスバーを非表示にする
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

- (void)viewDidUnload {
    // 各コントロールの解放
    [self setImageView:nil];
    [self setSavedDateLabel:nil];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [photoImage_ release], photoImage_ = nil;
    [fileName_ release], fileName_ = nil;

    // 各コントロールの解放
    [imageView release], imageView = nil;
    [savedDateLabel release], savedDateLabel = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // 逆さま以外の方向変換を許可
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || 
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // 写真が横長である場合
    if (photoImage_.size.width > photoImage_.size.height) {
        // 横向きの場合は表示欄全体に、縦向きの場合は縮尺を維持して写真を表示するように設定
        imageView.contentMode = (toInterfaceOrientation != UIInterfaceOrientationPortrait) ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
    // 縦長である場合
    } else {
        // 縦向きの場合は表示欄全体に、横向きの場合は縮尺を維持して写真を表示するように設定
        imageView.contentMode = (toInterfaceOrientation == UIInterfaceOrientationPortrait) ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
    }
}

#pragma mark - イベント

// 画像の表示欄がタップされた時に実行される処理
- (void)imageViewTapped {
    // ステータスバーを表示
    [UIApplication sharedApplication].statusBarHidden = NO;

    // 画面を閉じる
    [self dismissModalViewControllerAnimated:YES];
}

// 保存日の表示欄がタップされた時に実行される処理
- (void)savedDateLabelTapped {
    // 非表示にする
    [UIView beginAnimations:@"Animations" context:NULL];
    [UIView setAnimationDuration:TRANSPARENT_VIEW_TOGGLE_TIME];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    {
        savedDateLabel.alpha = 0;
    }
    [UIView commitAnimations];
}

@end
