//
//  AppDelegate_iPad.h
//  ScrollViewSample
//
//  Created by Jamming on 12-2-11.
//  Copyright 2012 CVT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollViewController.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    
    ScrollViewController *_scrollViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

