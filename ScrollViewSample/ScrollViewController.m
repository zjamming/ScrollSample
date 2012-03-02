    //
//  ScrollViewController.m
//  ScrollViewSample
//
//  Created by Jamming on 12-2-11.
//  Copyright 2012 CVT. All rights reserved.
//

#import "ScrollViewController.h"


@implementation ScrollViewController


static const NSTimeInterval kDelayTime = 0.2;
#pragma mark -
#pragma mark Private 
- (void)loadPageViewsDelayed
{
    _delayTimer = nil;
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:_currentPageView];
//    [NSObject cancelPreviousPerformRequestsWithTarget:_prevPageView];
//    [NSObject cancelPreviousPerformRequestsWithTarget:_nextPageView];
    
    _currentPageView.image = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:_currentPageIndex]];
    
    if (_currentPageIndex > 0)
    {
        UIImage *prevPageImage = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:(_currentPageIndex - 1)]];
        
        if (prevPageImage != _prevPageView.image)
        {
            [_prevPageView setImage:prevPageImage];
//            [_prevPageView performSelector:@selector(setImage:) 
//                                withObject:prevPageImage
//                                afterDelay:0.1];
        }
    }
    
    if (_currentPageIndex < _photoPages.count - 1)
    {
        
        UIImage *nextPageImage = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:(_currentPageIndex + 1)]];
        
        if (nextPageImage != _prevPageView.image)
        {
            [_nextPageView setImage:nextPageImage];
//            [_nextPageView performSelector:@selector(setImage:) 
//                                withObject:nextPageImage
//                                afterDelay:0.1];
        }
    }
}

- (void)loadPageViewsDelay
{
    [_delayTimer invalidate];
    _delayTimer = [NSTimer scheduledTimerWithTimeInterval:kDelayTime
                                                   target:self
                                                 selector:@selector(loadPageViewsDelayed)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)updatePageViews
{
    _scrollView.contentSize = CGSizeMake(_photoPages.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(_currentPageIndex * _scrollView.frame.size.width, 0)];
    
    CGSize pageSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height); 
    _currentPageView.frame = CGRectMake(_scrollView.contentOffset.x, 0, 
                                        pageSize.width, pageSize.height);
    _currentPageView.image = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:_currentPageIndex]];
    
    
    _prevPageView.frame = CGRectMake(_currentPageView.frame.origin.x - pageSize.width, 0, 
                                     pageSize.width, pageSize.height);
    if (_currentPageIndex > 0)
    {
        _prevPageView.image = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:(_currentPageIndex - 1)]];
    }
    
    _nextPageView.frame = CGRectMake(_currentPageView.frame.origin.x + pageSize.width, 0, 
                                     pageSize.width, pageSize.height);
    if (_currentPageIndex < _photoPages.count - 1)
    {
        _nextPageView.image = [UIImage imageWithContentsOfFile:[_photoPages objectAtIndex:(_currentPageIndex + 1)]];
    }
    
    _currentPageView.alpha = _prevPageView.alpha = _nextPageView.alpha = 1;
}




#pragma mark -
#pragma mark UIViewController Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _currentPageIndex = 0;
        
        NSArray *photoFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"photo"];
        photoFiles = [photoFiles sortedArrayUsingSelector:@selector(compare:)];
        _photoPages = [photoFiles retain];
        
        //NSAssert((nil == _photoPages || _photoPages.count == 0), @"can't find photos!");
        
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *selfView = [[UIView alloc] initWithFrame:screenBounds];
    self.view = selfView;
    [selfView release];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = screenBounds.size;
    [self.view addSubview:_scrollView];
    
    _prevPageView = [[UIImageView alloc] initWithFrame:screenBounds];
    _prevPageView.backgroundColor = [UIColor clearColor];
    _prevPageView.clipsToBounds = YES;
    _prevPageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_prevPageView];
    
    _currentPageView = [[UIImageView alloc] initWithFrame:screenBounds];
    _currentPageView.backgroundColor = [UIColor clearColor];
    _currentPageView.clipsToBounds = YES;
    _currentPageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_currentPageView];
    
    _nextPageView = [[UIImageView alloc] initWithFrame:screenBounds];
    _nextPageView.backgroundColor = [UIColor clearColor];
    _nextPageView.clipsToBounds = YES;
    _nextPageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_nextPageView];
    
    [self updatePageViews];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    _scrollView.delegate = self;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [_photoPages release];
    [_prevPageView release];
    [_currentPageView release];
    [_nextPageView release];
    [_scrollView release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_delayTimer invalidate];
    _delayTimer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize pageSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height); 
    NSInteger page = floor((scrollView.contentOffset.x - pageSize.width / 2) / pageSize.width) + 1;
    
    if (_currentPageIndex == page || page > _photoPages.count - 1 || page < 0)
    {
        return;
    }
    
    UIImageView *tempPageView;
    if (_currentPageIndex + 1 == page)
    {
        tempPageView = _currentPageView;
        _currentPageView = _nextPageView;
        _nextPageView = _prevPageView;
        _prevPageView = tempPageView;
//        tempPageView = _prevPageView;
//        _prevPageView = _currentPageView;
//        _currentPageView = _nextPageView;
//        _nextPageView = tempPageView;
        
        NSString *thumbPath = nil;
        if ((page + 1) < _photoPages.count)
        {
            NSString *bigImage = [(NSString *)[_photoPages objectAtIndex:(page + 1)] lastPathComponent];
            NSString *bigImageName = [[bigImage componentsSeparatedByString:@".png"] objectAtIndex:0];
            thumbPath = [[NSBundle mainBundle] pathForResource:bigImageName ofType:@"png" inDirectory:@"thumb"];
        }
        _nextPageView.image = [UIImage imageWithContentsOfFile:thumbPath];
    }
    else
    {
        tempPageView = _currentPageView;
        _currentPageView = _prevPageView;
        _prevPageView = _nextPageView;
        _nextPageView = tempPageView;
        
        
        NSString *thumbPath = nil;
        if ((page - 1) >= 0)
        {
            NSString *bigImage = [(NSString *)[_photoPages objectAtIndex:(page - 1)] lastPathComponent];
            NSString *bigImageName = [[bigImage componentsSeparatedByString:@".png"] objectAtIndex:0];
            thumbPath = [[NSBundle mainBundle] pathForResource:bigImageName ofType:@"png" inDirectory:@"thumb"];
        }
        _prevPageView.image = [UIImage imageWithContentsOfFile:thumbPath];
    }
    
    _currentPageIndex = page;
    _currentPageView.frame = CGRectMake(_currentPageIndex * pageSize.width, 0, 
                                        pageSize.width, pageSize.height);
    _prevPageView.frame = CGRectMake(_currentPageView.frame.origin.x - pageSize.width, 0, 
                                     pageSize.width, pageSize.height);
    _nextPageView.frame = CGRectMake(_currentPageView.frame.origin.x + pageSize.width, 0, 
                                     pageSize.width, pageSize.height);
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadPageViewsDelay];
}


@end
