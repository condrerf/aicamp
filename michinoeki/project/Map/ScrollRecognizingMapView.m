//
//  ScrollRecognizingMapView.m
//  MichiNoEki
//
//  Created by  on 11/11/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollRecognizingMapView.h"


@implementation ScrollRecognizingMapView

@synthesize scrollDelegate;

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if ([scrollDelegate respondsToSelector:@selector(mapViewDidScroll)]) [scrollDelegate mapViewDidScroll];
}

@end
