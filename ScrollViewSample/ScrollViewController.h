//
//  ScrollViewController.h
//  ScrollViewSample
//
//  Created by Jamming on 12-2-11.
//  Copyright 2012 CVT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    UIImageView *_prevPageView;
    UIImageView *_currentPageView;
    UIImageView *_nextPageView;
    
    NSInteger _currentPageIndex;
    
    NSArray *_photoPages;
    
    NSTimer *_delayTimer;
}



@end
