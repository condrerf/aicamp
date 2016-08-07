//
//  Constants.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/** 全体 */

// 画面の番号
typedef enum {
    Map = 0,
    StationInfo,
    Photo,
    Configuration
} ViewName;

// アプリケーションの処理開始時(起動・ロックの解除・デスクトップメニューから再開)の通知名
#define APPLICATION_DID_BECOME_ACTIVE_NOTIFICATION @"APPLICATION_DID_BECOME_ACTIVE_NOTIFICATION"

// アプリケーションの処理停止時(端末のロック・デスクトップメニューへ移動・電源切断)の通知名
#define APPLICATION_WILL_RESIGN_ACTIVE_NOTIFICATION @"APPLICATION_WILL_RESIGN_ACTIVE_NOTIFICATION"

// データベース名
#define DATABASE_NAME @"database.sqlite"

// 祝日のプロパティーリスト名
#define NATIONAL_HOLIDAY_PROPERTY_LIST_NAME @"NationalHoliday"

// バーのグラデーションの開始色
// #define BAR_GRADATION_START_COLOR [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]
// #define BAR_GRADATION_START_COLOR [UIColor colorWithRed:0.608 green:0.788 blue:0.682 alpha:1.0]
// #define BAR_GRADATION_START_COLOR [UIColor colorWithRed:0.427 green:0.694 blue:0.541 alpha:1.0]
#define BAR_GRADATION_START_COLOR [UIColor colorWithRed:0 green:0.5 blue:0.75 alpha:1]

// バーのグラデーションの終了色
// #define BAR_GRADATION_END_COLOR [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]
// #define BAR_GRADATION_END_COLOR [UIColor colorWithRed:0.055 green:0.427 blue:0.204 alpha:1.0]
#define BAR_GRADATION_END_COLOR [UIColor colorWithRed:0 green:0.25 blue:0.5 alpha:1]

//// タブバーのアイコンの色
//#define TAB_BAR_ICON_COLOR [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]
//
//// タブバーのアイコンの上端のアルファ値
//#define TAB_BAR_ICON_TOP_ALPHA 0.0
//
//// タブバーのアイコンの下端のアルファ値
//#define TAB_BAR_ICON_BOTTOM_ALPHA 1.0

// 透過対象の表示欄のアルファ値
#define TRANSPARENT_VIEW_ALPHA_VALUE 0.7

// 透過対象の表示欄の表示切り替え秒数
#define TRANSPARENT_VIEW_TOGGLE_TIME 1

// 駅の画像ファイルの書式
#define STATION_IMAGE_FILE_FORMAT @"%02d.gif"

// 駅データのIDの変数名
#define STATION_DATA_STATION_ID_VARIABLE_NAME @"stationID"

// 駅データのふりがなの変数名
#define STATION_DATA_RUBI_VARIABLE_NAME @"rubi"


/** 地図画面 */

// プルダウンメニューのセルの高さ
#define PULL_DOWN_MENU_CELL_HEIGHT 40

// プルダウンメニューのセルのフォントサイズ
#define PULL_DOWN_MENU_CELL_FONT_SIZE 14

// プルダウンメニューのアニメーション時間
#define PULL_DOWN_MENU_ANIMATION_DURATION 0.2

// 現在位置ボタンの標準の画像の名前
#define CURRENT_LOCATION_BUTTON_DEFAULT_IMAGE_NAME @"current_location.png"

// 現在位置ボタンのメニューのセルの見出し
#define CURRENT_LOCATION_BUTTON_MENU_CELL_CAPTIONS @"現在位置", @"位置を追跡"

// 現在位置ボタンのメニューのセルの見出し(状態変更時)
#define CURRENT_LOCATION_BUTTON_MENU_CELL_CAPTIONS2 @"現在位置", @"追跡を終了"

// 初期表示時の地図を表示する範囲の緯度経度
#define INITIAL_MAP_RANGE_DEGREE 0.5

// 郡上市役所の緯度経度（岐阜県の地理的な中心地）
#define GUJO_CITY_OFFICE_LATITUDE 35.748569
#define GUJO_CITY_OFFICE_LONGITUDE 136.964368

// 現在位置のアノテーションのタイトル
#define CURRENT_LOCATION_ANNOTATION_TITLE @"現在地"

// 駅のアノテーションの画像ファイル名
#define STATION_ANNOTATION_IMAGE_FILE_NAME @"annotation_station.png"

// 駅のアノテーションの画像ファイル名
#define VISITED_STATION_ANNOTATION_IMAGE_FILE_NAME @"annotation_visited_station.png"

// 現在選択されている駅のアノテーションの画像ファイル名
#define SELECTED_STATION_ANNOTATION_IMAGE_FILE_NAME @"annotation_selected_station.png"

// 閉店中の駅のアノテーションの画像ファイル名
#define CLOSING_STATION_ANNOTATION_IMAGE_FILE_NAME @"annotation_closing_station.png"

// 閉店中かつ訪問済みの駅のアノテーションの画像ファイル名
#define CLOSING_VISITED_STATION_ANNOTATION_IMAGE_FILE_NAME @"annotation_closing_visited_station.png"

// 駅のアノテーションのタイトルの書式
#define STATION_ANNOTATION_TITLE_FORMAT @"%d.%@"

// アノテーションが変わった駅の通知の書式
#define ANNOTATION_CHANGED_STATION_NOTIFICATION_FORMAT @"%@の\n%@時間になりました"

// 通知タイマーの間隔
#define NOTIFICATION_TIMER_INTERVAL 2

// 現在位置更新の再試行回数
#define LOCATION_UPDATE_RETRY_COUNT 5

// 現在位置を更新してから現在までの経過時間の有効秒数
#define VALID_LOCATION_UPDATE_INTERVAL 5

// 位置精度の最大有効値(単位:メートル)
#define MAX_VALID_LOCATION_ACCURACY 200

// 現在位置更新時の通知名
#define LOCATION_UPDATE_SUCCEEDED_NOTIFICATION @"LOCATION_UPDATE_SUCCEEDED_NOTIFICATION"

// 現在位置更新失敗時の通知名
#define LOCATION_UPDATE_FAILED_NOTIFICATION @"LOCATION_UPDATE_FAILED_NOTIFICATION"

// 現在位置更新時のメッセージ
#define LOCATION_UPDATE_MESSAGE @"現在位置を取得しています"

// 現在位置更新失敗時のメッセージ
#define LOCATION_UPDATE_FAILED_MESSAGE @"現在位置の取得に\n失敗しました。"

// 現在位置表示時の地図を表示する範囲の緯度経度
#define CURRENT_LOCATION_MAP_RANGE_DEGREE 0.1

// 現在位置追跡タイマーの間隔
#define TRACKING_TIMER_INTERVAL 1

// 訪問情報記録の可否判定時の、駅の緯度経度の誤差の許容範囲(1度＝111.32km)
#define STATION_DEGREE_ERROR_ACCEPTABLE_RANGE 0.002

// 駅訪問時のメッセージ
#define STATION_VISITED_MESSAGE @"%@への\n訪問情報を記録しました。"

// 経路の出発地のアノテーションのタイトル
#define SOURCE_LOCATION_ANNOTATION_TITLE @"出発地"

// 経路の線の太さ
#define ROUTE_LINE_WIDTH 5

// 経路の線のアルファ値
#define ROUTE_LINE_ALPHA_VALUE 0.7

// 経路ボタンのメニューの「経路を消去」の見出し
#define ROUTE_BUTTON_MENU_DELETE_ROUTES_CAPTION @"経路を消去"

// 経路情報表示時の地図を表示する範囲の緯度経度
#define ROUTE_INFO_MAP_RANGE_DEGREE 0.006

// 経路情報の出発地→目的地の文字列の書式
#define ROUTE_INFO_FROM_TO_TEXT_FORMAT @"%@→%@"

// 現在の道程の中心位置の画像ファイル名
#define CURRENT_STEP_CENTER_LOCATION_IMAGE_FILE_NAME @"circle.png"

// 現在の道程の中心位置のの画像のアルファ値
#define CURRENT_STEP_CENTER_LOCATION_IMAGE_ALPHA_VALUE 0.5

// 現在の道程の中心位置のアニメーション時間
#define CURRENT_STEP_CENTER_LOCATION_ANIMATION_DURATION 0.5


/** 駅一覧画面 */

// 駅一覧のセルの高さ
#define STATION_LIST_CELL_HEIGHT 60

// 訪問済みの駅に設定する文字列の書式
#define VISITED_STATION_TEXT_FORMAT @"%d年%d月%d日訪問"

// 未訪問の駅に設定する文字列
#define NOT_VISITED_STATION_TEXT @"未訪問"

// 訪問済みの駅の文字色
#define VISITED_STATION_TEXT_COLOR [UIColor colorWithRed:0.0 green:0.8 blue:0.2 alpha:1.0]

// 未訪問の駅の文字色
#define NOT_VISITED_STATION_TEXT_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]

// 経路検索の初期化が行われていない時のメッセージ
#define ROUTING_NOT_INITIALIZED_MESSAGE @"経路検索の設定を\n初期化しています。"


/** 駅情報画面 */

// 駅情報画面のラベルの余幅
#define STATION_INFO_LABEL_MARGIN 10

// 営業時間の文字列の書式
#define SHOP_HOUR_TEXT_FORMAT @"%d:%02d〜%d:%02d"

// 営業時間(土日祝祭日)の文字列の書式
#define SHOP_HOUR_HOLIDAY_TEXT @"土日祝祭日"

// 標準項目の文字列の書式
#define STANDARD_ITEM_TEXT_FORMAT @"%@(上記以外)"

// 曜日の各文字列
#define DAYS_OF_THE_WEEK @"日月火水木金土"

// 定休日がない場合の文字列
#define NO_HOLIDAY_TEXT @"年中無休"

// 「土日祝以外」の文字列
#define EXCEPT_HOLIDAY_TEXT @"土日祝以外"

// 「祝祭日の場合は前日」の文字列
#define PREVIOUS_DAY_IF_NATIONAL_HOLIDAY_TEXT @"祝祭日の場合は前日"

// 「祝祭日の場合は翌日」の文字列
#define NEXT_DAY_IF_NATIONAL_HOLIDAY_TEXT @"祝祭日の場合は翌日"

// 電話確認ダイアログのメッセージ
#define TELEPHONE_CONFIRMATION_DIALOG_MESSAGE @"電話をかけてよろしいですか？"

// 経路検索時のメッセージ
#define ROUTING_MESSAGE @"経路を検索しています"

// ネットワークの原因による経路検索失敗時のメッセージ
#define ROUTING_FAILED_FOR_NETWORK_MESSAGE @"インターネットに接続できない\nため、経路を検索できません。"

// Google Maps APIの処理成功時のステータス
#define GOOGLE_MAPS_API_STATUS_OK @"OK"

// Google Maps APIの使用上限超過時のステータス
#define GOOGLE_MAPS_API_STATUS_OVER_QUERY_LIMIT @"OVER_QUERY_LIMIT"

// 経路検索失敗時のメッセージ
#define ROUTING_FAILED_MESSAGE @"経路検索に失敗しました。"

// 使用上限超過時のメッセージ
#define ROUTING_OVER_QUERY_LIMIT_MESSAGE @"検索回数超過のため失敗しました。\nしばらく後に再実行してください。"


/** 写真画面共通 */

// アクションシートのタイトル
#define PHOTO_ACTION_SHEET_TITLE @"写真に関する操作"

// 写真の外部出力確認ダイアログのタグ
#define PHOTO_EXPORT_CONFIRMATION_DIALOG_TAG 1

// 写真の削除確認ダイアログのタグ
#define PHOTO_DELETE_CONFIRMATION_DIALOG_TAG 2

// 写真の外部出力中のインジケータのメッセージ
#define PHOTO_EXPORT_INDICATOR_MESSAGE @"写真をカメラロールにコピーしています"

// 写真の削除中のインジケータのメッセージ
#define PHOTO_DELETE_INDICATOR_MESSAGE @"写真を削除しています"

// 写真の外部出力失敗ダイアログのメッセージ
#define PHOTO_EXPORT_FAILED_DIALOG_MESSAGE @"写真のコピーに失敗しました。"

// 写真の外部出力完了ダイアログのメッセージ
#define PHOTO_EXPORT_COMPLETED_DIALOG_MESSAGE @"写真のコピーが完了しました。"

// 写真の削除失敗ダイアログのメッセージ
#define PHOTO_DELETE_FAILED_DIALOG_MESSAGE @"削除に失敗しました。"

// 写真の削除完了ダイアログのメッセージ
#define PHOTO_DELETE_COMPLETED_DIALOG_MESSAGE @"削除が完了しました。"


/** 駅一覧(写真)画面 */

// 保存枚数の文字列の書式
#define PHOTO_COUNT_TEXT_FORMAT @"保存枚数：%d枚"

// アクションシートの削除ボタンのタイトル
#define PHOTO_STATION_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE @"初期化"

// アクションシートの外部出力ボタンのタイトル
#define PHOTO_STATION_LIST_ACTION_SHEET_EXPORT_BUTTON_TITLE @"カメラロールにコピー"

// 写真の外部出力確認ダイアログのメッセージ
#define PHOTO_STATION_LIST_EXPORT_CONFIRMATION_DIALOG_MESSAGE @"全ての写真をカメラロールに\nコピーしてもよろしいですか？"

// 写真の削除確認ダイアログのメッセージ
#define PHOTO_STATION_LIST_DELETE_CONFIRMATION_DIALOG_MESSAGE @"全ての写真を\n削除してもよろしいですか？"


/** 写真撮影画面 */

// 写真ディレクトリの書式
#define PHOTO_DIRECTORY_FORMAT @"photo/station%02d"

// 写真のサムネイルファイルの末尾
#define PHOTO_THUMBNAIL_FILE_SUFFIX @"s.jpg"

// 写真のサムネイルの大きさ
#define PHOTO_THUMBNAIL_SIZE 75

// 写真のサムネイルの境界線の幅
#define PHOTO_THUMBNAIL_BORDER_WIDTH 2


/** 写真の保存先の駅選択画面 */

// 最寄駅ボタンの文字列の書式
#define NEAREST_STATION_BUTTON_FORMAT @"最寄駅(%@)"

// 最寄駅の検索に失敗した時の最寄駅ボタンの文字列
#define NEAREST_STATION_BUTTON_TEXT_SEARCH_FAILED @"最寄駅の検索に失敗しました"

// 写真保存エラーダイアログのメッセージ
#define PHOTO_SAVE_ERROR_DIALOG_MESSAGE @"写真の保存に失敗しました"


/** 写真一覧画面 */

// 外部出力アイコンのファイル名
#define EXPORT_ICON_FILE_NAME @"export.png"

// 削除アイコンのファイル名
#define DELETE_ICON_FILE_NAME @"delete.png"

// アクションシートの削除ボタンのタイトル
#define PHOTO_LIST_ACTION_SHEET_DELETE_BUTTON_TITLE @"削除"

// アクションシートの外部出力ボタンのタイトル
#define PHOTO_LIST_ACTION_SHEET_EXPORT_BUTTON_TITLE @"カメラロールにコピー"

// 写真の外部出力確認ダイアログのメッセージ
#define PHOTO_LIST_EXPORT_CONFIRMATION_DIALOG_MESSAGE @"選択された写真をカメラロールに\nコピーしてもよろしいですか？"

// 写真の削除確認ダイアログのメッセージ
#define PHOTO_LIST_DELETE_CONFIRMATION_DIALOG_MESSAGE @"選択された写真を\n削除してもよろしいですか？"


/** 写真閲覧画面 */

// 保存日の文字列の書式
#define SAVED_DATE_TEXT_FORMAT @"%d年%d月%d日　%d時%d分保存"


/** 設定画面 */

// 選択欄の高さ
#define SEGMENTED_CONTROLLER_HEIGHT 30

// 「駅一覧の順序」のキー
#define STATION_LIST_ORDER_TYPE_KEY @"STATION_LIST_ORDER_TYPE_KEY"

// 「地図画面を表示している時、開店・閉店時間になった駅を通知する」のキー
#define NOTIFIES_STATION_KEY @"NOTIFIES_STATION"

// 「経路検索時に有料道路を使用しない」のキー
#define AVOIDS_TOLL_ROAD_KEY @"AVOIDS_TOLL_ROAD"

// 「周辺の駅検索時の検索数」のキー
#define ROUTING_COUNT_KEY @"ROUTING_COUNT"

// 「写真撮影時、自動的に最寄駅に保存する」のキー
#define SAVES_TO_NEAREST_STATION_AUTOMATICALLY_KEY @"SAVES_TO_NEAREST_STATION_AUTOMATICALLY"

// 「駅一覧の順序」の初期値
#define STATION_LIST_ORDER_TYPE_DEFAULT_VALUE 0

// 「地図画面を表示している時、開店・閉店時間になった駅を通知する」の初期値
#define NOTIFIES_STATION_DEFAULT_VALUE 1

// 「経路検索時に有料道路を使用しない」の初期値
#define AVOIDS_TOLL_ROAD_DEFAULT_VALUE 0

// 「周辺の駅検索時の検索数」の初期値
#define ROUTING_COUNT_DEFAULT_VALUE 3

// 「写真撮影時、自動的に最寄駅に保存する」の初期値
#define SAVES_TO_NEAREST_STATION_AUTOMATICALLY_DEFAULT_VALUE 1