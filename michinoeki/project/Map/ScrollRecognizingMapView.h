//
//  ScrollRecognizingMapView.h
//  MichiNoEki
//
//  Created by  on 11/11/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 

@protocol MapViewScrollDelegate;

// スクロールイベント検出機能付きの地図画面
@interface ScrollRecognizingMapView : MKMapView<UIScrollViewDelegate> {
    id<MapViewScrollDelegate> scrollDelegate;
}

@property (nonatomic, assign) id<MapViewScrollDelegate> scrollDelegate;

@end

// デリゲートプロトコル
@protocol MapViewScrollDelegate<NSObject>
- (void)mapViewDidScroll;
@end