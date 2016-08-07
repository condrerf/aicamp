//
//  PhotoStationListViewController.m
//  MichiNoEki
//
//  Created by  on 11/08/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoStationListViewController.h"
#import "Constants.h"
#import "Utility.h"
#import "StationDataListWithoutDetail.h"
#import "LocationManager.h"
#import "PhotoStationListTableCell.h"
#import "PhotoListViewController.h"

// 非公開メソッドのカテゴリ
@interface PhotoStationListViewController(PrivateMethods)
- (void)reset;
- (void)savePhotoToStationID:(int)stationID;
- (void)redisplayImagePickerView;
- (void)showStationSelectView;
- (void)exportNextPhoto;
- (void)deletePhoto;
@end

@implementation PhotoStationListViewController

@synthesize shootingButton;
@synthesize actionButton;

#pragma mark - 初期化・終端処理

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // 使用されている端末にカメラ機能が搭載されている場合(※搭載されていない場合はタブバーから写真画面のアイコンが非表示になるが、当メソッドは実行される)
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 撮影画面の初期化(※UIImagePickerControllerクラスに対して2回以上initを行うとメモリ漏れが発生するため、インスタンス変数として格納)
            imagePickerController_ = [[UIImagePickerController alloc] init];
            imagePickerController_.delegate = self;
            
            // カメラ画面の高さを格納
            imagePickerViewHeight_ = imagePickerController_.view.bounds.size.height;
        }
    }
    
    return self;
}

- (void)viewDidUnload {
    // 各コントロールの解放
    [self setShootingButton:nil];
    [self setActionButton:nil];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [photoCounts_ release], photoCounts_ = nil;
    [takenPhoto_ release], takenPhoto_ = nil;
    [photoFilePaths_ release], photoFilePaths_ = nil;
    
    // 各コントロールの解放
    [shootingButton release], shootingButton = nil;
    [actionButton release], actionButton = nil;
    [indicatorViewController_ release], indicatorViewController_ = nil;
    [imagePickerController_ release], imagePickerController_ = nil;

    [super dealloc];
}

#pragma mark - 画面の表示・非表示時のイベント

// 画面の表示開始時に実行される処理
- (void)viewWillAppear:(BOOL)animated {
    // 画面を再設定
    [self reset];
}

#pragma mark - テーブルに関するイベント

// 選択可能な行数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StationDataListWithoutDetail getInstance].stationDataList count];
}

// テーブルビューが操作され、指定されたセルの表示が要求された時に実行される処理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルを格納
    static NSString *CellIdentifier = @"PhotoStationListTableCell";
    PhotoStationListTableCell *cell = (PhotoStationListTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = (PhotoStationListTableCell *) [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    // 現在参照しているセルの行番号に応じた駅データを格納
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];

    // 各コントロールを表示
    cell.stationImageView.image = [UIImage imageNamed:
                                   [NSString stringWithFormat:STATION_IMAGE_FILE_FORMAT, stationData.stationID]];
    cell.nameLabel.text = stationData.name;
    cell.photoCountLabel.text = [NSString stringWithFormat:PHOTO_COUNT_TEXT_FORMAT, [[photoCounts_ objectAtIndex:indexPath.row] intValue]];

    return cell;
}

// 指定された行のセルが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 遷移先で表示される戻るボタンを設定(※設定しないと、当画面のナビゲーションバーの文字列がボタンに設定される)
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"駅一覧"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    [backButtonItem release];

    // 写真一覧画面のオブジェクトを生成
    StationData *stationData = [[StationDataListWithoutDetail getInstance].stationDataList objectAtIndex:indexPath.row];
    PhotoListViewController *photoListViewController = [[PhotoListViewController alloc] initWithStationID:stationData.stationID];
    
    // 写真一覧画面を表示
    [self.navigationController pushViewController:photoListViewController animated:YES];
    
    // オブジェクトを解放
    [photoListViewController release];
    
    // 行選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ボタンイベント

// 撮影ボタンがタップされた時に実行される処理
- (IBAction)shootingButtonTouchUp {
    // カメラ機能を使用するように設定
    imagePickerController_.sourceType = UIImagePickerControllerSourceTypeCamera;

    // 撮影画面を表示
    [self presentModalViewController:imagePickerController_ animated:YES];

    // ステータスバーを非表示にする
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

// 編集ボタンがタップされた時に実行される処理
- (IBAction)actionButtonTouchUp {
    // アクションシートを格納
    UIActionSheet *actionSheet;
    
    // 使用されている機種にカメラロール機能が搭載されていない場合
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        // 写真のカメラロールへの出力ボタンがないアクションシートを設定
        actionSheet = [[UIActionSheet alloc] initWithTitle:PHOTO_ACTION_SHEET_TITLE delegate:self cancelButtonTitle:@"キャンセル"
                                    destructiveButtonTitle:PHOTO_STATION_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE
                                         otherButtonTitles:nil];
    // 搭載されている場合
    } else {
        // 写真のカメラロールへの出力ボタンを含むアクションシートを設定
        actionSheet = [[UIActionSheet alloc] initWithTitle:PHOTO_ACTION_SHEET_TITLE delegate:self cancelButtonTitle:@"キャンセル"
                                        destructiveButtonTitle:PHOTO_STATION_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE
                                             otherButtonTitles:PHOTO_STATION_LIST_ACTION_SHEET_EXPORT_BUTTON_TITLE, nil];
    }
    
    // アクションシートを表示
    [actionSheet showFromTabBar:self.tabBarController.tabBar];        
    [actionSheet release];
}

#pragma mark - デリゲートメソッド(UIActionSheetDelegate)

// アクションシートの指定された索引のボタンがタップされた時に実行される処理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 削除ボタンが選択された場合
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // 写真の削除確認ダイアログを表示
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.tag = PHOTO_DELETE_CONFIRMATION_DIALOG_TAG;
        alertView.delegate = self;
        alertView.title = @"確認";
        alertView.message = PHOTO_STATION_LIST_DELETE_CONFIRMATION_DIALOG_MESSAGE;
        [alertView addButtonWithTitle:@"はい"];
        [alertView addButtonWithTitle:@"いいえ"];
        [alertView show];
        [alertView release];
        // 削除ボタンとキャンセルボタン以外のボタン(カメラロールにコピー)が選択された場合
    } else if (buttonIndex != [actionSheet cancelButtonIndex]) {
        // 写真の外部出力確認ダイアログを表示
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.tag = PHOTO_EXPORT_CONFIRMATION_DIALOG_TAG;
        alertView.delegate = self;
        alertView.title = @"確認";
        alertView.message = PHOTO_STATION_LIST_EXPORT_CONFIRMATION_DIALOG_MESSAGE;
        [alertView addButtonWithTitle:@"はい"];
        [alertView addButtonWithTitle:@"いいえ"];
        [alertView show];
        [alertView release];
    }
}

// アラートダイアログのボタンが押された時に実行される処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 「いいえ」が選択された場合は、処理を中断
    if (buttonIndex != 0) return;
    
    // インジケータ画面のメッセージを格納
    NSString *indicatorMessage;
    
    // 出力確認ダイアログが表示されていた場合
    if (alertView.tag == PHOTO_EXPORT_CONFIRMATION_DIALOG_TAG) {
        // 写真ファイルのパスの集合を初期化
        if (!photoFilePaths_) {
            photoFilePaths_ = [[NSMutableArray alloc] init];
        } else {
            [photoFilePaths_ removeAllObjects];
        }
        
        // 駅データの集合の各要素を参照
        for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
            // 現在参照している駅データに該当する駅の写真ファイルの集合を取得
            NSString *photoDirectoryPath = [[Utility getInstance] photoDirectoryPathWithStationID:stationData.stationID];
            NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photoDirectoryPath error:NULL];
            
            // ファイル名の各要素を参照
            for (NSString *fileName in fileNames) {
                // 現在参照しているファイル名がサムネイルファイルのものでない場合
                if (![fileName hasSuffix:PHOTO_THUMBNAIL_FILE_SUFFIX]) {
                    // ディレクトリパスにファイル名を付加した文字列を写真ファイルのパスとして集合に追加
                    [photoFilePaths_ addObject:[photoDirectoryPath stringByAppendingPathComponent:fileName]];
                }
            }
        }

        // 写真のカメラロールへの出力の実行
        [self performSelector:@selector(exportNextPhoto) withObject:nil afterDelay:0];
        
        // インジケータ画面のメッセージを設定
        indicatorMessage = PHOTO_EXPORT_INDICATOR_MESSAGE;
    // 削除確認ダイアログが表示されていた場合
    } else {
        // 写真の削除の実行
        [self performSelector:@selector(deletePhoto) withObject:nil afterDelay:0];
        
        // インジケータ画面のメッセージを設定
        indicatorMessage = PHOTO_DELETE_INDICATOR_MESSAGE;
    }
    
    // インジケータ画面を表示
    if (!indicatorViewController_) indicatorViewController_ = [[IndicatorViewController alloc] init];
    indicatorViewController_.message = indicatorMessage;
    [self.navigationController.view addSubview:indicatorViewController_.view];
}

// 次に出力すべき写真をカメラロールに出力する
- (void)exportNextPhoto {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[photoFilePaths_ objectAtIndex:0]];
    [photoFilePaths_ removeObjectAtIndex:0];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:error:contextInfo:), NULL);
    [image release];
}

// 画像の保存が終了した時に実行される処理
- (void)image:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo {
    // エラーオブジェクトが空でない場合
    if (error) {
        // エラーダイアログを表示してインジケータ画面を閉じる
        [[Utility getInstance] showErrorDialog:PHOTO_EXPORT_FAILED_DIALOG_MESSAGE];
        [indicatorViewController_.view removeFromSuperview];
    // 空である場合
    } else {
        // 写真ファイルのパスの集合が空の場合
        if ([photoFilePaths_ count] == 0) {
            // 完了ダイアログを表示してインジケータ画面を閉じる
            [[Utility getInstance] showDialogWithMessage:PHOTO_EXPORT_COMPLETED_DIALOG_MESSAGE title:@"コピー完了"];
            [indicatorViewController_.view removeFromSuperview];
        // 空でない場合
        } else {
            // 写真を出力
            [self exportNextPhoto];
        }
    }
}

// 写真を削除する
- (void)deletePhoto {
    // 削除に失敗したかどうかを格納
    BOOL isDeletingFailed = NO;
    
    // 駅データの集合の各要素を参照
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        // 現在参照している駅データに該当する駅の写真ファイルのディレクトリを取得
        NSString *photoDirectoryPath = [[Utility getInstance] photoDirectoryPathWithStationID:stationData.stationID];
        
        // ディレクトリが存在する場合
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoDirectoryPath isDirectory:NULL]) {
            // ディレクトリの削除に失敗した場合
            if (![[NSFileManager defaultManager] removeItemAtPath:photoDirectoryPath error:NULL]) {
                // エラーダイアログを表示
                [[Utility getInstance] showErrorDialog:PHOTO_DELETE_FAILED_DIALOG_MESSAGE];
                
                // 削除失敗フラグを設定してループから抜ける
                isDeletingFailed = YES;
                break;
            }
        }
    }
    
    // 画面を再設定
    [self reset];

    // 削除失敗フラグが設定されていない場合は、完了ダイアログを表示
    if (!isDeletingFailed) [[Utility getInstance] showDialogWithMessage:PHOTO_DELETE_COMPLETED_DIALOG_MESSAGE title:@"削除完了"];
    
    // インジケータ画面を閉じる
    [indicatorViewController_.view removeFromSuperview];
}

#pragma mark - デリゲートメソッド(UIImagePickerControllerDelegate)

// 撮影画面で[use]ボタンがタップされた時に実行される処理
- (void)imagePickerController:(UIImagePickerController*)picker 
        didFinishPickingImage:(UIImage*)image 
                  editingInfo:(NSDictionary*)editingInfo {
    // 撮影された写真の格納
    [takenPhoto_ release];
    takenPhoto_ = [image retain];
    
    // 位置情報が取得可能である場合
    if ([[LocationManager getInstance] locationServicesEnabled]) {
        // 現在位置の更新に関する通知を受け取ったらメソッドを実行するように設定
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showStationSelectView)
                                                     name:LOCATION_UPDATE_SUCCEEDED_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showStationSelectView)
                                                     name:LOCATION_UPDATE_FAILED_NOTIFICATION
                                                   object:nil];
        
        // 現在位置の更新を開始
        [[LocationManager getInstance] startUpdatingLocation];
    // 取得できない場合
    } else {
        // アクションシートを表示
        [self showStationSelectView];
    }
}

// 撮影画面で[cancel]ボタンがタップされた時に実行される処理
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    // カメラ画面の高さが変更されている(撮影し、自動的に最寄駅に保存した)場合は、元の高さに戻す(次回表示時に正常に表示されなくなるため)
    if (imagePickerController_.view.frame.size.height != imagePickerViewHeight_) {
        imagePickerController_.view.frame = CGRectMake(0, 0, imagePickerController_.view.frame.size.width, imagePickerViewHeight_);
    }

    // ステータスバーを表示した上で写真画面を閉じる
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - デリゲートメソッド(PhotoStationSelectViewDelegate)

// 写真の保存先の駅の選択画面で駅が選択された時に実行される処理
- (void)photoStationSelectViewCellSelectedStationID:(int)stationID {
    // 選択されたIDの駅に写真を保存
    [self savePhotoToStationID:stationID];
}

// 写真の保存先の駅の選択画面でキャンセルボタンがタップされた時に実行される処理
- (void)photoStationSelectViewCancelButtonTouched {
    // 写真の保存先の駅の選択画面を閉じる(→自動的に撮影画面が初期化される)
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - 再設定

// 画面の再設定を行う
- (void)reset {
    // 写真存在フラグを格納
    BOOL photoExists = NO;
    
    // 各駅の写真枚数を格納
    NSMutableArray *photoCounts = [[NSMutableArray alloc] initWithCapacity:[[StationDataListWithoutDetail getInstance].stationDataList count]];

    // 駅データの集合の各要素を参照
    for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
        // 現在参照している駅データに該当する駅の写真ファイルの枚数÷2を写真枚数として設定(通常ファイルとサムネイルファイルが存在するため)
        NSString *photoDirectoryPath = [[Utility getInstance] photoDirectoryPathWithStationID:stationData.stationID];
        NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photoDirectoryPath error:NULL];
        int photoCount = [fileNames count] / 2;
        
        // 写真枚数を集合に追加
        NSNumber *photoCountNumber = [[NSNumber alloc] initWithInt:photoCount];
        [photoCounts addObject:photoCountNumber];
        [photoCountNumber release];
        
        // 写真枚数が0でない場合は、写真存在フラグを設定
        if (photoCount) photoExists = YES;
    }
    
    // ナビゲーションバーの右側の領域に対し、写真存在フラグが設定されている場合は編集ボタンを設定し、設定されていない場合は空にする
    self.navigationItem.rightBarButtonItem = photoExists ? actionButton : nil;
    
    // 写真枚数変更フラグを格納
    BOOL isPhotoCountChanged = NO;

    // 各駅の写真枚数がインスタンス変数に設定されている(初回以外)場合
    if (photoCounts_) {
        // 各駅の写真枚数の各要素を参照
        for (int i = 0; i < [[StationDataListWithoutDetail getInstance].stationDataList count]; i++) {
            // 現在参照している駅の写真枚数が前回と異なる場合
            if ([[photoCounts objectAtIndex:i] intValue] != [[photoCounts_ objectAtIndex:i] intValue]) {
                // 写真枚数変更フラグを設定してループから抜ける
                isPhotoCountChanged = YES;
                break;
            }
        }
    }
    
    // 各駅の写真枚数をインスタンス変数に格納
    [photoCounts_ release];
    photoCounts_ = photoCounts;
    
    // 写真枚数変更フラグが設定されている場合は、一覧を再描画
    if (isPhotoCountChanged) [self.tableView reloadData];
}

#pragma mark - 撮影に関する処理

// 指定されたIDの駅に写真を保存する
- (void)savePhotoToStationID:(int)stationID {
    // Documentsフォルダ内の、指定された駅の写真ディレクトリを取得
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *photoDirectoryPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:PHOTO_DIRECTORY_FORMAT, stationID]];
    
    // 指定された駅の写真ディレクトリが存在しない場合
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:photoDirectoryPath isDirectory:&isDirectory]) {
        // ディレクトリの作成に失敗した場合
        if(![[NSFileManager defaultManager] createDirectoryAtPath:photoDirectoryPath
                                      withIntermediateDirectories:YES attributes:nil error:NULL]) {
            // エラーダイアログを表示
            [[Utility getInstance] showErrorDialog:PHOTO_SAVE_ERROR_DIALOG_MESSAGE];

            // 自動的に最寄駅に保存するように設定されている場合は、カメラ画面を再表示
            if ([ConfigurationData getInstance].savesToNearestStationAutomatically) [self redisplayImagePickerView];

            // 処理を中断
            return;
        }
    }
    
    // 撮影された写真画像データを生成
    NSData *photoImageData = UIImageJPEGRepresentation(takenPhoto_, 1.0);
    
    // 写真の中心を切り抜いた内容になるように、写真のサムネイルの描画領域を設定
    CGRect photoThumbnailDrawingRect;
    
    if (takenPhoto_.size.width > takenPhoto_.size.height) {
        int thumbnailWidth = PHOTO_THUMBNAIL_SIZE * ((double) 4 / 3);
        photoThumbnailDrawingRect.origin.x = -(thumbnailWidth - PHOTO_THUMBNAIL_SIZE) / 2;;
        photoThumbnailDrawingRect.origin.y = 0;
        photoThumbnailDrawingRect.size.width = thumbnailWidth;
        photoThumbnailDrawingRect.size.height = PHOTO_THUMBNAIL_SIZE;
    } else {
        int thumbnailHeight = PHOTO_THUMBNAIL_SIZE * ((double) 4 / 3);
        photoThumbnailDrawingRect.origin.x = 0;
        photoThumbnailDrawingRect.origin.y = -(thumbnailHeight - PHOTO_THUMBNAIL_SIZE) / 2;
        photoThumbnailDrawingRect.size.width = PHOTO_THUMBNAIL_SIZE;
        photoThumbnailDrawingRect.size.height = thumbnailHeight;
    }
    
    // 写真のサムネイル画像データの生成
    UIGraphicsBeginImageContext(CGSizeMake(PHOTO_THUMBNAIL_SIZE, PHOTO_THUMBNAIL_SIZE));  
    [takenPhoto_ drawInRect:photoThumbnailDrawingRect];  
    NSData *photoThumbnailImageData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 1.0);
    UIGraphicsEndImageContext();
    
    // 現在時刻の文字列の生成
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    // 写真とサムネイルの画像ファイルのパスを設定
    NSString *photoImageFilePath = [photoDirectoryPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg", currentDateString]];
    NSString *photoThumbnailImageFilePath = [photoDirectoryPath stringByAppendingPathComponent:
                                             [NSString stringWithFormat:@"%@%@", currentDateString, PHOTO_THUMBNAIL_FILE_SUFFIX]];
    
    // いずれかのファイルの保存に失敗した場合
    if (![photoImageData writeToFile:photoImageFilePath atomically:YES] ||
        ![photoThumbnailImageData writeToFile:photoThumbnailImageFilePath atomically:YES]) {
        // 写真の画像ファイルが存在する場合(サムネイルファイルの保存に失敗)は、写真の画像ファイルを削除
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoImageFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:photoImageFilePath error:NULL];
        }
        
        // エラーダイアログを表示
        [[Utility getInstance] showErrorDialog:PHOTO_SAVE_ERROR_DIALOG_MESSAGE];
        
        // 自動的に最寄駅に保存するように設定されている場合は、カメラ画面を再表示
        if ([ConfigurationData getInstance].savesToNearestStationAutomatically) [self redisplayImagePickerView];
        
        // 処理を中断
        return;
    }
    
    // 自動的に最寄駅に保存するように設定されている場合
    if ([ConfigurationData getInstance].savesToNearestStationAutomatically) {
        // カメラ画面を再表示
        [self redisplayImagePickerView];
    // 設定されていない場合
    } else {
        // 写真の保存先の駅の選択画面を閉じる(→自動的に撮影画面が初期化される)
        [self.modalViewController dismissModalViewControllerAnimated:YES];
    }
}

// カメラ画面を再表示する
- (void)redisplayImagePickerView {
    // 現在表示されているカメラ画面を一旦閉じて再表示
    [self.modalViewController dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:imagePickerController_ animated:NO];
    
    // 画面の表示位置を調整(間隔を置かずに再表示すると上端に空白ができてしまうため)
    imagePickerController_.view.frame = CGRectMake(0, -1, imagePickerController_.view.frame.size.width, imagePickerController_.view.frame.size.height + 1);
}

// 駅選択画面を表示する
- (void)showStationSelectView {
    // 通知の受信設定を解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 取得した現在地の位置情報を設定(※取得に失敗した場合は0が格納)
    CLLocationCoordinate2D currentLocation = [LocationManager getInstance].location;

    // 最寄駅のIDを格納
    int nearestStationID = 0;
    
    // 現在地の位置情報の取得に成功した場合
    if (currentLocation.latitude != 0 && currentLocation.longitude != 0) {
        // 最寄駅のデータを取得
        double nearestStationDistance = DBL_MAX;
        
        for (StationData *stationData in [StationDataListWithoutDetail getInstance].stationDataList) {
            // 現在参照している駅から現在位置までの距離を算出
            double distance = sqrt(pow(currentLocation.latitude - stationData.location.latitude, 2) +
                                   pow(currentLocation.longitude - stationData.location.longitude, 2));

            // 算出した距離が、これまでの最寄距離よりも近い場合
            if (distance < nearestStationDistance) {
                // 最寄距離を更新し、現在参照している駅データのIDを最寄駅のIDに設定
                nearestStationDistance = distance;
                nearestStationID = stationData.stationID;
            }
        }
    }
    
    // 自動的に最寄駅に保存するように設定されており、最寄駅のIDが取得できた場合
    if ([ConfigurationData getInstance].savesToNearestStationAutomatically && nearestStationID) {
        // 最寄駅に写真を保存
        [self savePhotoToStationID:nearestStationID];
    // 設定されていないか、IDが取得できなかった場合
    } else {
        // 写真の保存先選択画面を表示
        PhotoStationSelectViewController *photoStationSelectViewController = [[PhotoStationSelectViewController alloc] initWithNearestStationID:nearestStationID];
        photoStationSelectViewController.delegate = self;
        [self.modalViewController presentModalViewController:photoStationSelectViewController animated:YES];
    }
}

@end
