//
//  UIUnderlinedButton.m
//  MichiNoEki
//
//  Created by  on 11/10/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UnderlinedButton.h"

@implementation UnderlinedButton

- (void)drawRect:(CGRect)rect {
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;

    // 文字列の領域
    CGRect textRect = self.titleLabel.frame;
    
    // 下線の縦位置
    int underlineYPosition = textRect.origin.y + (textRect.size.height * 0.8) + descender;

    // set to same color as text
    //UIGraphicsBeginImageContext(textRect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    CGContextMoveToPoint(contextRef, textRect.origin.x, underlineYPosition);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, underlineYPosition);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);

    //UIGraphicsEndImageContext();
}

@end
