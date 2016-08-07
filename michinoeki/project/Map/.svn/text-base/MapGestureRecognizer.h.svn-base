//
//  MapGestureRecognizer.h
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapGestureRecognizerDelegate;

@interface MapGestureRecognizer : UIGestureRecognizer {
    id<MapGestureRecognizerDelegate> delegate;
}

@property (nonatomic, assign) id<MapGestureRecognizerDelegate> delegate;

@end

// デリゲートプロトコル
@protocol MapGestureRecognizerDelegate<NSObject>
@optional
- (void)mapTouched;
- (void)mapMoved;
- (void)mapStopped;
@end