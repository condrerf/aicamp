//
//  Categories.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Categories.h"
#import "Constants.h"

@implementation NSDate(Extensions)
// 指定された文字列を日付に変換し、それを返す
+ (NSDate *)dateFromString:(NSString *)date_string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:date_string];
    [dateFormatter release];
    return date;
}
@end

@implementation NSMutableString(Extensions)
// 自身が空でない場合は、前に改行コードを付与して文字列を追加する
- (void)appendStringWithBreakCodeIfNotEmpty:(NSString *)string {
    if (self.length > 0) [self appendString:@"\n"];
    [self appendString:string];
}

// 自身が空でない場合は、前に「・」を付与して文字列を追加する
- (void)appendStringWithBulletIfNotEmpty:(NSString *)string {
    if (self.length > 0) [self appendString:@"・"];
    [self appendString:string];
}
@end

@implementation UIView(Extensions)
// 自身の背景色を指定された色にする
- (void)setColor:(UIColor *)color {
    // 色が設定されていない場合は処理を中断
    if (!color) return;

    // 指定された色の領域を生成し、自身に上乗せ
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = color;
    [self insertSubview:view atIndex:0];
    [view release];
}

// 指定された2つの色から成るグラデーションを自身に設定する
- (void)setGradationFrom:(UIColor *)startColor To:(UIColor *)endColor {
    // 色が設定されていない場合は処理を中断
    if (!startColor || !endColor) return;

    // 画像領域の取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 各色の色情報の設定
    CGFloat components[8];
    const CGFloat *colors = CGColorGetComponents(startColor.CGColor);
    const CGFloat *colors2 = CGColorGetComponents(endColor.CGColor);
    
    for (int i = 0; i < 4; i++) {
        components[i] = colors[i];
        components[i + 4] = colors2[i];
    }
    
    // グラデーションデータの生成
    CGFloat locations[2] = {0.0, 1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    // グラデーションの実行
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // メモリの解放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}
@end

@implementation UITabBar(Extensions)
// 自身の描画を行う
// @Override
- (void)drawRect:(CGRect)rect {
    // 自身にグラデーションの色を設定
    [self setGradationFrom:BAR_GRADATION_START_COLOR To:BAR_GRADATION_END_COLOR];

    // 自身の持つ各アイコンの色を設定
    // [self recolorIconsWithColor:TAB_BAR_ICON_COLOR topAlpha:TAB_BAR_ICON_TOP_ALPHA bottomAlpha:TAB_BAR_ICON_BOTTOM_ALPHA];
}

// 自身の持つ各アイコンの色を指定された色にする(グラデーションなし)
- (void)recolorIconsWithColor:(UIColor *)color {
//    [self recolorIconsWithColor:color topAlpha:1.0 bottomAlpha:1.0
//                    shadowColor:nil shadowOffset:CGSizeZero shadowBlur:CGFLOAT_MAX];
////    [self.tabBarController.tabBar recolorIconsWithColor:[UIColor greenColor]
////                                             startAlpha:0.0
////                                               endAlpha:1.0
////                                            shadowColor:[UIColor redColor]
////                                           shadowOffset:CGSizeMake(0.0f, 0.0f) 
////                                             shadowBlur:3.0f];
}

// 自身の持つ各アイコンの色を指定された色にする(グラデーションあり)
- (void)recolorIconsWithColor:(UIColor *)color topAlpha:(CGFloat)topAlpha bottomAlpha:(CGFloat)bottomAlpha {
//    [self recolorIconsWithColor:color topAlpha:topAlpha bottomAlpha:bottomAlpha
//                    shadowColor:nil shadowOffset:CGSizeZero shadowBlur:CGFLOAT_MAX];
}

// 自身の持つ各アイコンの色を指定された色にすると共に、影を指定された色・位置・ぼかし具合にする
- (void)recolorIconsWithColor:(UIColor *)color
                     topAlpha:(CGFloat)topAlpha
                  bottomAlpha:(CGFloat)bottomAlpha
                  shadowColor:(UIColor *)shadowColor
                 shadowOffset:(CGSize)shadowOffset
                   shadowBlur:(CGFloat)shadowBlur {
//    // 色が設定されていない場合は処理を中断
//    if (!color) return;
//
//    // タブバーの各項目を参照
//    for (UITabBarItem *item in [self items]) {
//        // 現在参照している要素に対して各メソッドが実装されている場合
//        if ([item respondsToSelector:@selector(selectedImage)] &&
//            [item respondsToSelector:@selector(setSelectedImage:)] &&
//            [item respondsToSelector:@selector(_updateView)]) {
//            CGFloat locations[] = {0.0, 1.0};
//            CGFloat components[] = {1.0, 1.0, 1.0, 1.0 - topAlpha, 1.0, 1.0, 1.0, 1.0 - bottomAlpha};
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace,
//                                                                              components,
//                                                                              locations,
//                                                                              (size_t) 2);
//            
//            // 描画領域の設定
//            CGRect contextRect;
//            contextRect.origin.x = 0.0f;
//            contextRect.origin.y = 0.0f;
//            contextRect.size = [[item selectedImage] size];
//            
//            // 画像の大きさと座標の設定
//            UIImage *itemImage = [item image];
//            CGSize itemImageSize = [itemImage size];
//            CGPoint itemImagePosition; 
//            itemImagePosition.x = floorf((contextRect.size.width - itemImageSize.width) / 2);
//            itemImagePosition.y = floorf((contextRect.size.height - itemImageSize.height) / 2);
//            
//            // 描画処理の開始
//            UIGraphicsBeginImageContext(contextRect.size);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            
//            // 影の色が設定されている場合は、影を設定
//            if(shadowColor) CGContextSetShadowWithColor(context, shadowOffset, shadowBlur, [shadowColor CGColor]);
//            
//            // 透過レイヤーの開始
//            CGContextBeginTransparencyLayer(context, NULL);
//            
//            // 画像の描画
//            CGContextScaleCTM(context, 1.0, -1.0);
//            CGContextClipToMask(context,
//                                CGRectMake(itemImagePosition.x, -itemImagePosition.y, 
//                                           itemImageSize.width, -itemImageSize.height),
//                                [itemImage CGImage]);
//            CGContextSetFillColorWithColor(context, [color CGColor]);
//            contextRect.size.height = -contextRect.size.height;
//            CGContextFillRect(context, contextRect);
//            
//            // グラデーションの設定
//            CGPoint startPoint = CGPointMake(0.0, 0.0);
//            CGPoint endPoint = CGPointMake(0.0, contextRect.size.height);
//            CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, 0);
//            
//            // 透過レイヤーの終了
//            CGContextEndTransparencyLayer(context);
//            
//            // 生成した画像を設定
//            [item setSelectedImage:UIGraphicsGetImageFromCurrentImageContext()];
//            
//            // 描画処理の終了
//            UIGraphicsEndImageContext();
//            
//            // メモリの解放
//            CGColorSpaceRelease(colorSpace);
//            CGGradientRelease(colorGradient);
//            
//            // 更新の実行(※プライベートAPI)
//            [item _updateView];
//        }
//    }
}
@end

@implementation UILabel(Extensions)
// 自身の大きさを再設定する
- (void)resize {
    int maximumHeight = 1000;
    CGSize size = [self.text sizeWithFont:self.font
                        constrainedToSize:CGSizeMake(self.bounds.size.width, maximumHeight)
                            lineBreakMode:self.lineBreakMode];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, size.height);
}
@end

