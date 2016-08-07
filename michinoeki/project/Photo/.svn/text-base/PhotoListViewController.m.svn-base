//
//  PhotoListViewController.m
//  MichiNoEki
//
//  Created by  on 11/08/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoListViewController.h"
#import "Constants.h"
#import "Utility.h"
#import "Database.h"
#import "ThumbnailImageView.h"
#import "IndexedTapGestureRecognizer.h"
#import "PhotoStationListViewController.h"
#import "PhotoViewerViewController.h"

// 非公開メソッドのカテゴリ
@interface PhotoListViewController(PrivateMethods)
- (void)swipedRight;
- (void)imageViewTapped:(IndexedTapGestureRecognizer *)sender;
- (void)resetIcons;
@end

@implementation PhotoListViewController

@synthesize scrollView;
@synthesize photoListView;
@synthesize noPhotoLabel;
@synthesize exportInformationLabel;
@synthesize deleteInformationLabel;

// 指定されたIDの駅データで初期化する
- (id)initWithStationID:(int)stationID {
    self = [self initWithNibName:@"PhotoList" bundle:nil];
    
    if (self) {
        // 駅データの取得
        stationData_ = [[[Database getInstance] selectStationDataWithDetailOfStationID:stationID] retain];
        
        // 右スワイプイベントを検出するクラスの設定
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                                     action:@selector(swipedRight)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeGestureRecognizer];
        [swipeGestureRecognizer release];

        // ナビゲーションバーのフォントサイズがタイトルの文字数に応じて調整されるように設定
        [[Utility getInstance] setAdjustFontSizeOfNavigationItem:self.navigationItem];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // ナビゲーションバーに駅名を設定
    self.navigationItem.title = stationData_.name;
    
    // 選択された駅の写真ディレクトリ内に存在するファイル名の集合を取得
    NSString *photoDirectoryPath = [[Utility getInstance] photoDirectoryPathWithStationID:stationData_.stationID];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photoDirectoryPath error:NULL];
    
    // 写真が存在しない場合
    if (![fileNames count]) {
        // 写真なしラベルを表示して処理を中断
        noPhotoLabel.hidden = NO;
        return;
    }
    
    // 写真のサムネイルファイル名の集合の生成
    NSMutableArray *photoThumbnailFileNames = [NSMutableArray arrayWithCapacity:[fileNames count] / 2];
    
    for (NSString *fileName in fileNames) {
        if ([fileName hasSuffix:PHOTO_THUMBNAIL_FILE_SUFFIX]) {
            [photoThumbnailFileNames addObject:fileName];
        }
    }

    // 画像の配置に関するデータを設定
    int imageCountPerLine = self.view.bounds.size.width / PHOTO_THUMBNAIL_SIZE;
    int margin = (self.view.bounds.size.width - (PHOTO_THUMBNAIL_SIZE * imageCountPerLine)) / (imageCountPerLine + 1);

    // 各サムネイルファイル名を参照
    for (int i = 0; i < [photoThumbnailFileNames count]; i++) {
        // 現在参照しているサムネイルファイル画像の表示欄を生成
        NSString *photoThumbnailFileName = [photoThumbnailFileNames objectAtIndex:i];
        NSString *photoThumbnailFilePath = [photoDirectoryPath stringByAppendingPathComponent:photoThumbnailFileName];
        NSString *originalPhotoFileName = [NSString stringWithFormat:@"%@.jpg", 
                                           [photoThumbnailFileName substringToIndex:
                                            photoThumbnailFileName.length - PHOTO_THUMBNAIL_FILE_SUFFIX.length]];
        NSString *originalPhotoFilePath = [photoDirectoryPath stringByAppendingPathComponent:originalPhotoFileName];
        ThumbnailImageView *thumbnailImageView = [[ThumbnailImageView alloc] initWithFilePath:photoThumbnailFilePath 
                                                                             originalFilePath:originalPhotoFilePath];
        
        // 画像の表示欄の表示位置を設定
        CGRect thumbNailImageViewFrame = thumbnailImageView.frame;
        int rowIndex = i / imageCountPerLine;
        int columnIndex = i % imageCountPerLine;
        thumbNailImageViewFrame.origin.x = (PHOTO_THUMBNAIL_SIZE * columnIndex) + (margin * (columnIndex + 1));
        thumbNailImageViewFrame.origin.y = (PHOTO_THUMBNAIL_SIZE * rowIndex) + (margin * (rowIndex + 1));
        thumbnailImageView.frame = thumbNailImageViewFrame;
        
        // タップイベントを検出するクラス(索引付き)を設定
        thumbnailImageView.userInteractionEnabled = YES;
        IndexedTapGestureRecognizer *indexedTapGestureRecognizer = [[IndexedTapGestureRecognizer alloc] 
                                                                    initWithTarget:self
                                                                    action:@selector(imageViewTapped:)];
        indexedTapGestureRecognizer.index = i;
        [thumbnailImageView addGestureRecognizer:indexedTapGestureRecognizer];
        [indexedTapGestureRecognizer release];
        
        // タグを設定(0の設定は無効になるため、1から順に設定)
        thumbnailImageView.tag = i + 1;
        
        // 画像の表示欄を一覧画面に設定
        [photoListView addSubview:thumbnailImageView];
        [thumbnailImageView release];
    }
    
    // 画像の行数に応じて写真一覧画面の高さを設定
    int imageRowCount = ceil((float) [photoThumbnailFileNames count] / imageCountPerLine);
    CGRect frame = photoListView.frame;
    frame.size.height = margin + ((PHOTO_THUMBNAIL_SIZE + margin) * imageRowCount);
    photoListView.frame = frame;

    // スクロールビューに写真一覧画面を設定
    scrollView.contentSize = [photoListView sizeThatFits:CGSizeZero];
    [scrollView addSubview:photoListView];

    // 編集ボタンを生成してナビゲーションバーの右側に設定
    actionButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                  target:self
                                                                  action:@selector(actionButtonTouchUp)];
    self.navigationItem.rightBarButtonItem = actionButton_;

    // 外部出力ボタンと削除ボタンを生成
    exportButton_ = [[UIBarButtonItem alloc] initWithTitle:@"コピー" style:UIBarButtonItemStyleBordered target:self action:@selector(exportButtonTouchUp)];
    deleteButton_ = [[UIBarButtonItem alloc] initWithTitle:@"削除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteButtonTouchUp)];
}

- (void)viewDidUnload {
    // 各コントロールの解放
    [self setScrollView:nil];
    [self setPhotoListView:nil];
    [self setNoPhotoLabel:nil];
    [self setExportInformationLabel:nil];
    [self setDeleteInformationLabel:nil];
    [actionButton_ release], actionButton_ = nil;
    [exportButton_ release], exportButton_ = nil;
    [deleteButton_ release], deleteButton_ = nil;

    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [stationData_ release], stationData_ = nil;
    [exportTargetPhotoFilePaths_ release], exportTargetPhotoFilePaths_ = nil;
    
    // 各コントロールの解放
    [scrollView release], scrollView = nil;
    [photoListView release], photoListView = nil;
    [noPhotoLabel release], noPhotoLabel = nil;
    [exportInformationLabel release]; exportInformationLabel = nil;
    [deleteInformationLabel release], deleteInformationLabel = nil;
    [indicatorViewController_ release], indicatorViewController_ = nil;
    [actionButton_ release], actionButton_ = nil;
    [exportButton_ release], exportButton_ = nil;
    [deleteButton_ release], deleteButton_ = nil;
    
    [super dealloc];
}

#pragma mark - イベント

// 右スワイプ時に実行される処理
- (void)swipedRight {
    // 前の画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ボタンイベント

// 編集ボタンがタップされた時に実行される処理
- (void)actionButtonTouchUp {
    // アクションシートを格納
    UIActionSheet *actionSheet;
    
    // 使用されている機種にカメラロール機能が搭載されていない場合
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        // 写真のカメラロールへの出力ボタンがないアクションシートを設定
        actionSheet = [[UIActionSheet alloc] initWithTitle:PHOTO_ACTION_SHEET_TITLE delegate:self cancelButtonTitle:@"キャンセル"
                                    destructiveButtonTitle:PHOTO_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE
                                         otherButtonTitles:nil];
        // 搭載されている場合
    } else {
        // 写真のカメラロールへの出力ボタンを含むアクションシートを設定
        actionSheet = [[UIActionSheet alloc] initWithTitle:PHOTO_ACTION_SHEET_TITLE delegate:self cancelButtonTitle:@"キャンセル"
                                    destructiveButtonTitle:PHOTO_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE
                                         otherButtonTitles:PHOTO_LIST_ACTION_SHEET_EXPORT_BUTTON_TITLE, nil];
    }
    
    // アクションシートを表示
    [actionSheet showFromTabBar:self.tabBarController.tabBar];        
    [actionSheet release];
}

// 外部出力ボタンがタップされた時に実行される処理
- (void)exportButtonTouchUp {
    // 外部出力情報表示欄を非表示にする
    exportInformationLabel.hidden = YES;

    // 外部出力対象の写真ファイルのパスの集合を初期化
    if (!exportTargetPhotoFilePaths_) {
        exportTargetPhotoFilePaths_ = [[NSMutableArray alloc] init];
    } else {
        [exportTargetPhotoFilePaths_ removeAllObjects];
    }
    
    // 各サムネイル画像の表示欄を参照
    for (ThumbnailImageView *thumbnailImageView in photoListView.subviews) {
        // 現在参照しているサムネイル画像の表示欄に外部出力アイコンが表示されている場合
        if (!thumbnailImageView.exportIconImageView.hidden) {
            // サムネイル画像の元ファイルのパスを外部出力対象の写真ファイルのパスの集合に追加
            [exportTargetPhotoFilePaths_ addObject:thumbnailImageView.originalFilePath];
        }
    }
    
    // 外部出力対象の写真ファイルのパスの集合が空である場合
    if (![exportTargetPhotoFilePaths_ count]) {
        // 各アイコンを初期化
        [self resetIcons];
        
        // ナビゲーションバーの右側の領域に編集ボタンを設定する
        self.navigationItem.rightBarButtonItem = actionButton_;
    // 空でない場合
    } else {
        // 写真のカメラロールへの外部出力を実行
        [self performSelector:@selector(exportNextPhoto) withObject:nil afterDelay:0];
        
        // インジケータ画面を表示
        if (!indicatorViewController_) indicatorViewController_ = [[IndicatorViewController alloc] init];
        indicatorViewController_.message = PHOTO_EXPORT_INDICATOR_MESSAGE;
        [self.navigationController.view addSubview:indicatorViewController_.view];
    }
}

// 削除ボタンがタップされた時に実行される処理
- (void)deleteButtonTouchUp {
    // 削除情報表示欄を非表示にする
    deleteInformationLabel.hidden = YES;

    // 削除対象のサムネイル画像の各表示欄を格納
    NSMutableArray *deleteTargetThumbnailImageViews = [[NSMutableArray alloc] init];
    
    // 各サムネイル画像の表示欄を参照
    for (ThumbnailImageView *thumbnailImageView in photoListView.subviews) {
        // 現在参照しているサムネイル画像の表示欄に削除アイコンが表示されている場合
        if (!thumbnailImageView.deleteIconImageView.hidden) {
            // 現在参照しているサムネイル画像の表示を削除対象のサムネイル画像の表示欄の集合に追加
            [deleteTargetThumbnailImageViews addObject:thumbnailImageView];
        }
    }

    // 削除対象のサムネイル画像の表示欄の集合が空である場合
    if (![deleteTargetThumbnailImageViews count]) {
        // 各アイコンを初期化
        [self resetIcons];
        
        // ナビゲーションバーの右側の領域に編集ボタンを設定する
        self.navigationItem.rightBarButtonItem = actionButton_;
    // 空でない場合
    } else {
        // 写真の削除の実行
        [self performSelector:@selector(deletePhotoWithThumbnailImageViews:) withObject:deleteTargetThumbnailImageViews afterDelay:0];
        
        // インジケータ画面を表示
        if (!indicatorViewController_) indicatorViewController_ = [[IndicatorViewController alloc] init];
        indicatorViewController_.message = PHOTO_DELETE_INDICATOR_MESSAGE;
        [self.navigationController.view addSubview:indicatorViewController_.view];
    }
    
    // 削除対象のサムネイル画像の表示欄の集合を解放
    [deleteTargetThumbnailImageViews release];
}

#pragma mark - デリゲートメソッド(UITapGestureRecognizer)

// 画像の表示欄がタップされた時に実行される処理
- (void)imageViewTapped:(IndexedTapGestureRecognizer *)sender {
    // タップされたサムネイル画像の表示欄を取得
    ThumbnailImageView *thumbnailImageView = (ThumbnailImageView *) [photoListView viewWithTag:sender.index + 1];

    // ナビゲーションバーの右側の領域に編集ボタンが設定されている場合
    if (self.navigationItem.rightBarButtonItem == actionButton_) {
        // 写真表示画面を表示
        PhotoViewerViewController *photoViewerViewController = [[PhotoViewerViewController alloc]
                                                                initWithPhotoFilePath:thumbnailImageView.originalFilePath];
        [self presentModalViewController:photoViewerViewController animated:YES];
        [photoViewerViewController release];
    // 外部出力ボタンが設定されている場合
    } else if (self.navigationItem.rightBarButtonItem == exportButton_) {
        // タップされたサムネイル画像の表示欄に関連付けられている外部出力アイコンの表示を切り替え
        thumbnailImageView.exportIconImageView.hidden = !thumbnailImageView.exportIconImageView.hidden;
    // 削除ボタンが表示されている場合
    } else {
        // タップされたサムネイル画像の表示欄に関連付けられている削除アイコンの表示を切り替え
        thumbnailImageView.deleteIconImageView.hidden = !thumbnailImageView.deleteIconImageView.hidden;
    }
}

#pragma mark - デリゲートメソッド(UIActionSheetDelegate)

// アクションシートの指定された索引のボタンがタップされた時に実行される処理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 削除ボタンが選択された場合
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // ナビゲーションバーの右側の領域に削除ボタンを設定し、削除情報表示欄を表示する
        self.navigationItem.rightBarButtonItem = deleteButton_;
        deleteInformationLabel.hidden = NO;
    // 削除ボタンとキャンセルボタン以外のボタン(カメラロールにコピー)が選択された場合
    } else if (buttonIndex != [actionSheet cancelButtonIndex]) {
        // ナビゲーションバーの右側の領域に外部出力ボタンを設定し、外部出力情報表示欄を表示する
        self.navigationItem.rightBarButtonItem = exportButton_;
        exportInformationLabel.hidden = NO;
    }
}

#pragma mark - 写真の外部出力

// 次に出力すべき写真をカメラロールに出力する
- (void)exportNextPhoto {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[exportTargetPhotoFilePaths_ objectAtIndex:0]];
    [exportTargetPhotoFilePaths_ removeObjectAtIndex:0];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:error:contextInfo:), NULL);
    [image release];
}

// 画像の保存が終了した時に実行される処理
- (void)image:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo {
    // エラーオブジェクトが空でない場合
    if (error) {
        // エラーダイアログを表示
        [[Utility getInstance] showErrorDialog:PHOTO_EXPORT_FAILED_DIALOG_MESSAGE];
        
        // 各アイコンを初期化
        [self resetIcons];
        
        // ナビゲーションバーの右側の領域に編集ボタンを設定する
        self.navigationItem.rightBarButtonItem = actionButton_;
        
        // インジケータ画面を閉じる
        [indicatorViewController_.view removeFromSuperview];
    // 空である場合
    } else {
        // 写真ファイルのパスの集合が空の場合
        if ([exportTargetPhotoFilePaths_ count] == 0) {
            // 完了ダイアログを表示
            [[Utility getInstance] showDialogWithMessage:PHOTO_EXPORT_COMPLETED_DIALOG_MESSAGE title:@"コピー完了"];

            // 各アイコンを初期化
            [self resetIcons];

            // ナビゲーションバーの右側の領域に編集ボタンを設定する
            self.navigationItem.rightBarButtonItem = actionButton_;
            
            // インジケータ画面を閉じる
            [indicatorViewController_.view removeFromSuperview];
        // 空でない場合
        } else {
            // 写真を出力
            [self exportNextPhoto];
        }
    }
}

#pragma mark - 写真の削除

// 指定されたサムネイル画像の表示欄の集合に対応する写真を削除する
- (void)deletePhotoWithThumbnailImageViews:(NSArray *)thumbnailImageViews {
    // 削除に失敗したかどうかを格納
    BOOL isDeletingFailed = NO;
    
    // 指定されたサムネイル画像の表示欄の集合の各要素を参照
    for (ThumbnailImageView *thumbnailImageView in thumbnailImageViews) {
        // サムネイル画像ファイルと元の写真ファイルの削除のいずれかに失敗した場合
        if (![[NSFileManager defaultManager] removeItemAtPath:thumbnailImageView.filePath error:NULL] ||
            ![[NSFileManager defaultManager] removeItemAtPath:thumbnailImageView.originalFilePath error:NULL]) {
            // 削除失敗フラグを設定してループから抜ける
            isDeletingFailed = YES;
            break;
        }
        
        // サムネイル画像の表示欄を非表示にする
        thumbnailImageView.hidden = YES;
    }
    
    // 削除失敗フラグが設定されている場合
    if (isDeletingFailed) {
        // エラーダイアログを表示
        [[Utility getInstance] showErrorDialog:PHOTO_DELETE_FAILED_DIALOG_MESSAGE];
    // 設定されていない場合
    } else {
        // 完了ダイアログを表示
        [[Utility getInstance] showDialogWithMessage:PHOTO_DELETE_COMPLETED_DIALOG_MESSAGE title:@"削除完了"];
    }
    
    // 各アイコンを初期化
    [self resetIcons];

    // 選択された駅の写真ディレクトリ内に存在するファイル名の集合を取得
    NSString *photoDirectoryPath = [[Utility getInstance] photoDirectoryPathWithStationID:stationData_.stationID];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photoDirectoryPath error:NULL];
    
    // 写真が存在しない場合
    if (![fileNames count]) {
        // ナビゲーションバーの右側の領域を空にし、写真なしラベルを表示
        self.navigationItem.rightBarButtonItem = nil;
        noPhotoLabel.hidden = NO;
    // 存在する場合
    } else {
        // ナビゲーションバーの右側の領域に編集ボタンを設定する
        self.navigationItem.rightBarButtonItem = actionButton_;
    }
    
    // インジケータ画面を閉じる
    [indicatorViewController_.view removeFromSuperview];
}

#pragma mark - アイコンの初期化

// 各アイコンを初期化する
- (void)resetIcons {
    // 各サムネイル画像の表示欄を参照
    for (ThumbnailImageView *thumbnailImageView in photoListView.subviews) {
        // 現在参照しているサムネイル画像の表示欄に外部出力アイコンが表示されている場合
        if (!thumbnailImageView.exportIconImageView.hidden) {
            // 外部出力アイコンを非表示にする
            thumbnailImageView.exportIconImageView.hidden = YES;
        // 削除アイコンが表示されている場合
        } else if (!thumbnailImageView.deleteIconImageView.hidden) {
            // 削除アイコンを非表示にする
            thumbnailImageView.deleteIconImageView.hidden = YES;
        }
    }
}

@end
