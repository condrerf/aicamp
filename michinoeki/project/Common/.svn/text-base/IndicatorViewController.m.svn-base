//
//  IndicatorViewController.m
//  MichiNoEki
//
//  Created by  on 11/10/03.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "IndicatorViewController.h"

@implementation IndicatorViewController

@synthesize messageLabel;
@synthesize message;

- (id)init {
    self = [self initWithNibName:@"Indicator" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 設定されたメッセージをメッセージ表示欄に設定
    messageLabel.text = message;
}

- (void)viewDidUnload {
    [self setMessageLabel:nil];

    [super viewDidUnload];
}

- (void)dealloc {
    // 各オブジェクトの解放
    [message release], message = nil;
    
    // 各コントロールの解放
    [messageLabel release], messageLabel = nil;
    
    [super dealloc];
}

// 指定されたメッセージを設定する
- (void)setMessage:(NSString *)_message {
    // メッセージの格納
    [message release];
    message = [_message copy];
    
    // メッセージ表示欄にメッセージを設定
    messageLabel.text = message;
}

@end
