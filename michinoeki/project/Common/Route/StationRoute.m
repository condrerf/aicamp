//
//  StationRoute.m
//  MichiNoEki
//
//  Created by  on 11/09/16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StationRoute.h"
#import "ConfigurationData.h"
#import "GoogleDirectionsXMLParser.h"
#import "RouteObject.h"
#import "StepObject.h"
#import "NSString+Extension.h"

@implementation StationRoute

@synthesize routeObject;
@synthesize sourceStationData;
@synthesize destinationStationData;

#pragma mark - 初期化・終端処理

// 指定された出発地の座標と目的地の座標を使用して自身を生成する
- (id)initWithSourceLocation:(CLLocationCoordinate2D)sourceLocation destinationLocation:(CLLocationCoordinate2D)destinationLocation {
    self = [super init];
    
    if (self) {
        // 出発地と目的地の文字列を生成
        NSString *origin = [NSString stringWithFormat:@"%f,%f", sourceLocation.latitude, sourceLocation.longitude];
        NSString *destination = [NSString stringWithFormat:@"%f,%f", destinationLocation.latitude, destinationLocation.longitude];
        
        // Google Maps APIへの問い合わせ内容を設定
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://maps.google.com/maps/api/directions/xml"];
        [urlString appendString:@"?origin="];
        [urlString appendString:[origin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [urlString appendString:@"&destination="];
        [urlString appendString:[destination stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([ConfigurationData getInstance].avoidsTollRoad) [urlString appendString:@"&avoid=tolls"];
        [urlString appendString:@"&sensor=false"];
        [urlString appendString:@"&language=ja"];
        
        // APIへの問い合わせを実行
        NSError *error = nil;
        NSString *directionString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] 
                                                             encoding:NSUTF8StringEncoding 
                                                                error:&error];
        
        // 経路データを生成
        GoogleDirectionsXMLParser *xmlParser = [[GoogleDirectionsXMLParser alloc] init];
        routeObject = [[xmlParser loadXmlString:directionString] retain];
        [xmlParser release];
    }

    return self;
}

- (void)dealloc {
    // 各オブジェクトの解放
    [routeObject release], routeObject = nil;
    [sourceStationData release], sourceStationData = nil;
    [destinationStationData release], destinationStationData = nil;
    
    [super dealloc];
}

#pragma mark - 駅データに関する処理

// 指定された索引の道程の開始位置の座標を返す
- (CLLocationCoordinate2D)startLocationWithStepIndex:(int)stepIndex {
    StepObject *stepObject = [routeObject.steps objectAtIndex:stepIndex];
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = stepObject.startLocationLat;
    startLocation.longitude = stepObject.startLocationLng;
    return startLocation;
}

// 指定された索引の道程の情報を返す
- (NSString *)informationWithStepIndex:(int)stepIndex {
    // 指定された索引の道程データを格納
    StepObject *stepObject = [routeObject.steps objectAtIndex:stepIndex];

    // APIから取得したHTMLの道程情報の文字列からタグと空白を除去した文字列を道程情報として格納する
    NSString *information = [[stepObject.htmlInstructions stringByConvertingHTMLToPlainText] stringByReplacingOccurrencesOfString:@" "
                                                                                                                       withString:@""];

    // HTMLの道程情報に含まれるdivタグの値を取得
    NSRegularExpression *divRegularExpression =[NSRegularExpression regularExpressionWithPattern:@"<div.*>(.+)</div>"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
    NSTextCheckingResult *divCheckingResult = [divRegularExpression firstMatchInString:stepObject.htmlInstructions
                                                                        options:0
                                                                          range:NSMakeRange(0, stepObject.htmlInstructions.length)];
    
    // 検査結果の各要素を参照(※0番目には文字列全体の範囲が格納されている)
    for (int i = 1; i < divCheckingResult.numberOfRanges; i++) {
        // divタグの値を取得
        NSString *divValue = [stepObject.htmlInstructions substringWithRange:[divCheckingResult rangeAtIndex:i]];

        // divタグの値に含まれる「目的地」の位置を取得
        NSRange destinationStringRange = [divValue rangeOfString:@"目的地"];
        
        // divタグの値に「目的地」が含まれている場合
        if (destinationStringRange.location != NSNotFound) {
            // 値の前に改行コードを付加した値で置換
            NSString *breakCodeAddedDestinationString = [NSString stringWithFormat:@"\n%@", divValue];
            information = [information stringByReplacingOccurrencesOfString:divValue withString:breakCodeAddedDestinationString];
        // 含まれていない場合
        } else {
            // 道程情報から値を除去
            information = [information stringByReplacingOccurrencesOfString:divValue withString:@""];
        }
    }

    // 正規表現の各文字列を格納
    NSArray *regularExpressionStrings = [[NSArray alloc] initWithObjects:@"(\\(.*\\))", @"(（.*）)", nil];
    
    // 正規表現の各文字列を参照
    for (NSString *regularExpressionString in regularExpressionStrings) {
        // 道程情報から除去対象の文字列が含まれているかどうかを検査
        NSRegularExpression *removeStringRegularExpression =[NSRegularExpression regularExpressionWithPattern:regularExpressionString
                                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                                   error:nil];
        NSTextCheckingResult *removeStringCheckingResult = [removeStringRegularExpression firstMatchInString:information
                                                                                                options:0
                                                                                                  range:NSMakeRange(0, information.length)];

        // 検査結果の各要素を参照(※0番目には文字列全体の範囲が格納されている)
        for (int i = 1; i < removeStringCheckingResult.numberOfRanges; i++) {
            // 道程情報から除去対象の文字列を除去
            NSString *removeString = [information substringWithRange:[removeStringCheckingResult rangeAtIndex:i]];
            information = [information stringByReplacingOccurrencesOfString:removeString withString:@""];
        }
    }
    
    // オブジェクトを解放
    [regularExpressionStrings release];
    
    // 最初の道程が指定されている場合は、そのままの内容を返す
    if (stepIndex == 0) return information;
    
    // 指定された道程の索引の1つ前の道程データに格納されている距離の文字列を取得
    StepObject *previousStepObject = [routeObject.steps objectAtIndex:stepIndex - 1];
    NSString *distanceText = [previousStepObject.distanceText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 前に距離を付加した情報を返す
    return [NSString stringWithFormat:@"%@移動し、\n%@", distanceText, information];
}

@end
