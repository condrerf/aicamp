//
//  PhotoThumbnailImageView.h
//  MichiNoEki
//
//  Created by  on 11/09/02.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// サムネイルの表示欄
@interface ThumbnailImageView : UIImageView {
    NSString *filePath;
    NSString *originalFilePath;
    UIImageView *exportIconImageView;
    UIImageView *deleteIconImageView;
}

@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, readonly) NSString *originalFilePath;
@property (nonatomic, readonly) UIImageView *exportIconImageView;
@property (nonatomic, readonly) UIImageView *deleteIconImageView;

- (id)initWithFilePath:(NSString *)_filePath originalFilePath:(NSString *)_originalFilePath;

@end
