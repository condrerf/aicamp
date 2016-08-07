//
//  MenuTableViewController.h
//  MichiNoEki
//
//  Created by  on 11/09/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTableViewControllerDelegate;

@interface MenuTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate> {
    id<MenuTableViewControllerDelegate> delegate;
    BOOL isAlignmentRight_;
    NSArray *captions_;
}

@property (nonatomic, assign) id<MenuTableViewControllerDelegate> delegate;

- (void)resizeMenu;
- (BOOL)isShowingMenu;
- (void)showMenu;
- (void)closeMenu;
- (void)hideMenu;
- (void)unhideMenu;
- (void)moveMenuPosition:(BOOL)shows;

@end

// デリゲートプロトコル
@protocol MenuTableViewControllerDelegate<NSObject>
- (void)didSelectMenuItem:(id)sender index:(int)index;
@end