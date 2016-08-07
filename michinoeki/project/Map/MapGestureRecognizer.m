//
//  MapGestureRecognizer.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapGestureRecognizer.h"

@implementation MapGestureRecognizer

@synthesize delegate;

// 指が触れた時
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(mapTouched)]) [self.delegate mapTouched];
}

// 触れている指が動いた時
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(mapMoved)]) [self.delegate mapMoved];
}

// 指が離れた時
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // デリゲートオブジェクトが設定され、メソッドが実装されている場合は、メソッドを実行
    if ([self.delegate respondsToSelector:@selector(mapStopped)]) [self.delegate mapStopped];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

// 別の画面に切り替わった時
- (void)reset {
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event {
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

@end