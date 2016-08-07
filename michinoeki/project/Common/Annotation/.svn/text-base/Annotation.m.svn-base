//
//  Annotation.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
// MKAnnotationクラスのプロパティに対する宣言(必須)
@synthesize coordinate;


// 指定された緯度経度情報を使用して初期化する
- (id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString *)title {
	if ((self = [super init])) {
        // スーパークラスのプロパティに設定
		coordinate = _coordinate;

        // バルーンのタイトルの設定
        title_ = [title copy];
	}

	return self;
}

// 終端処理
- (void)dealloc {
    // 各オブジェクトの解放
    [title_ release], title_ = nil;

    [super dealloc];
}

// アノテーションクリック時に表示するバルーンに設定するタイトルを返す
- (NSString *)title {
    return title_;
}

@end