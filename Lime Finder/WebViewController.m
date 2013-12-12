//
//  WebViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "WebViewController.h"
#import "WebView.h"
#import "WebNavigationBar.h"
#import "WebURLBar.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface WebViewController ()

@end

@implementation WebViewController

@synthesize rootViewController_;
@synthesize webURLBar_;
@synthesize webView_;
@synthesize webNavigationBar_;
@synthesize moreView_;
@synthesize shadowView_;
@synthesize shadowScreen_;
@synthesize lockScreen_;
@synthesize hideTimer_;
@synthesize contentOffset_;
@synthesize timerCount_;
@synthesize listButton_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        hideTimer_ = nil;
        timerCount_ = 0;
    }
    return self;
}


/* 뷰가 로드 됨 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // 서브뷰를 초기화 한다.
    [self initViews];

}


/* 뷰가 나타남 */
-(void)viewDidAppear:(BOOL)animated
{

}


/* 서브 뷰를 초기화 한다. */
- (void)initViews
{
    CGFloat shadowColorArray[] = {0, 0, 0, 1.0};
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    CGColorRef shadowColor = CGColorCreate(colorSpace, shadowColorArray);
    // WebViewController View 그림자 //
    shadowView_ = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowView_.backgroundColor = [UIColor whiteColor];
    shadowView_.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    shadowView_.layer.shadowRadius = 5.0;
    shadowView_.layer.shadowColor = shadowColor;
    shadowView_.layer.shadowOpacity = 0.5;
    shadowView_.hidden = YES;
    [self.view addSubview:shadowView_];
     
    // 웹 뷰 초기화 //
    //webView_ = [[WebView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    webView_ = [[WebView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT)];
    [webView_ setScalesPageToFit:YES];
    webView_.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(WEB_URL_BAR_HEIGHT, 0, 0, 0);
    // webView_.scrollView.contentInset = UIEdgeInsetsMake(WEB_URL_BAR_HEIGHT, 0, WEB_NAVIGATION_BAR_HEIGHT, 0);
    webView_.scrollView.contentInset = UIEdgeInsetsMake(WEB_URL_BAR_HEIGHT, 0, 0, 0);
    webView_.scrollView.delegate = self;
    webView_.delegate = self;
    webView_.autoresizesSubviews = YES;
    contentOffset_ = webView_.scrollView.contentOffset;
   [self.view addSubview:webView_];
    
    // 리스트 버튼 초기화 //
    UIImage *listButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bottom_btn_list" ofType:@"png"]];
    listButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton_ setImage:listButtonImage forState:UIControlStateNormal];
    [listButton_ setImage:listButtonImage forState:UIControlStateSelected];
    [listButton_ setImage:listButtonImage forState:UIControlStateHighlighted];
    listButton_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - listButtonImage.size.height / 2.0, listButtonImage.size.width / 2.0, listButtonImage.size.height / 2.0);
    [listButton_ addTarget:self action:@selector(listButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    listButton_.alpha = 0.3;
    [self.view addSubview:listButton_];
    
    
    // Shadow Screen //
    shadowScreen_ = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowScreen_.backgroundColor = [UIColor blackColor];
    shadowScreen_.hidden = YES;
    shadowScreen_.alpha = 0.8;
    UITapGestureRecognizer *shadowScreenTabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowSreenTapped:)];
    [shadowScreen_ addGestureRecognizer:shadowScreenTabGestureRecognizer];
    [self.view addSubview:shadowScreen_];
    
    // MoreView //
    moreView_ = [[MoreView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height + 20.0, MORE_VIEW_WIDTH, MORE_VIEW_HEIGHT)];
    moreView_.backgroundColor = [UIColor whiteColor];
    moreView_.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    moreView_.layer.shadowRadius = 5.0;
    moreView_.layer.shadowColor = shadowColor;
    moreView_.layer.shadowOpacity = 0.5;
    //moreView_.hidden = YES;
    [self.view addSubview:moreView_];

    // URL 바 초기화 //
    webURLBar_ = [[WebURLBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, WEB_URL_BAR_HEIGHT)];
    webURLBar_.backgroundColor = [UIColor whiteColor];
    //webURLBar_.hidden = YES;
    [self.view addSubview:webURLBar_];
    
    // lock screen //
    lockScreen_ = [[UIView alloc] initWithFrame:self.view.bounds];
    lockScreen_.backgroundColor = [UIColor clearColor];
    lockScreen_.hidden = YES;
    UITapGestureRecognizer *lockScreenTabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockSreenTapped:)];
    [lockScreen_ addGestureRecognizer:lockScreenTabGestureRecognizer];
    [self.view addSubview:lockScreen_];
    
    // 네비게이션 바 초기화 //
    webNavigationBar_ = [[WebNavigationBar alloc] initWithFrame:(CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - WEB_NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, WEB_NAVIGATION_BAR_HEIGHT)) webView:webView_];
    webNavigationBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:webNavigationBar_];
    
    CGColorRelease(shadowColor);
    CGColorSpaceRelease(colorSpace);
}


/* 메모리 경고를 수신 받음 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* URL로 웹 컨텐츠를 요청한다. */
-(void)requestWithURL:(NSURL *)url
{
    //[webView_ loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    
    /* 네트워크에 연결이 가능한지를 검사한다. */
    if ([rootViewController_ isReachableWithHost:nil])
    {
        // [webView_ stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
        [webView_ loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"네트워크에 연결할 수 없습니다!" message:@"3G 또는 Wifi 상태를 확인해 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
       [alertView show];
    }
}


/* MoreView를 나타낸다. */
- (void)showMoreView
{
    // MoreViewCell 들을 초기화 한다.
    [moreView_ initMoreViewCellList];
    
    shadowScreen_.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        // 애니메이션 블록 시작 //
        [moreView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - moreView_.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, moreView_.bounds.size.width, moreView_.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
        // 완료 블록 시작 //
        [UIView animateWithDuration:0.1 animations:^{
            // 애니메이션 블록 시작 //
            [moreView_ setFrame:CGRectMake(self.view.bounds.origin.x, moreView_.frame.origin.y + 5.f, moreView_.bounds.size.width, moreView_.bounds.size.height)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
            
            // 완료 블록 끝 //
        }];
        // 완료 블록 끝 //
    }];
}


/* MoreView를 숨긴다. */
- (void)hideMoreView
{
    shadowScreen_.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        // 애니메이션 블록 시작 //
        [moreView_ setFrame:CGRectMake(self.view.bounds.origin.x, moreView_.frame.origin.y - 5.f, moreView_.bounds.size.width, moreView_.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
        // 완료 블록 시작 //
        [UIView animateWithDuration:0.3 animations:^{
            // 애니메이션 블록 시작 //
            [moreView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height + 20.0, moreView_.bounds.size.width, moreView_.bounds.size.height)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
            
            // 완료 블록 끝 //
        }];
        // 완료 블록 끝 //
    }];
}

/* Shadow Screen 을 탭하다 */
-(void)shadowSreenTapped:(id)sender
{
    UIButton *iconButton = [webNavigationBar_.subviews objectAtIndex:4];
    if (iconButton.selected)
    {
        [self hideMoreView];
        iconButton.selected = NO;
    }

    if(webURLBar_.urlTextField_.editing)
        [webURLBar_.urlTextField_ resignFirstResponder];
    
    shadowScreen_.hidden = YES;
}

/* Lock Screen 을 탭하다 */
-(void)lockSreenTapped:(id)sender
{
    UIButton *button = [webNavigationBar_.subviews objectAtIndex:0];
    [webNavigationBar_ actionList:button];
}


#pragma -
#pragma mark - UIWebViewDelegate Method

/* 리퀘스트 로드의 시작 여부를 묻다. */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 네트워크 인디케이터를 켠다.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // 진행바를 초기화 한다. 
    webView_.resourceCompletedCount_ = 0;
    webView_.resourceCount_ = 0;
    [webURLBar_ endProgress];
    
    // WebURLBar 뷰의 텍스트필트 객체에 URL을 갱신한다.
    NSURL *url = request.mainDocumentURL;
    NSString *urlString = [url absoluteString];
    webURLBar_.urlTextField_.text = urlString;
    
    [self removeHideTimer];
    hideTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(hideTimerCheck:) userInfo:nil repeats:YES];
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self removeHideTimer];
    // WebURLBar와 WebNavigationBar의 위치 초기화
    // [webURLBar_ setFrame:CGRectMake(webURLBar_.frame.origin.x, self.view.bounds.origin.y, webURLBar_.bounds.size.width, WEB_URL_BAR_HEIGHT)];
    
    
    [self removeHideTimer];
    hideTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(hideTimerCheck:) userInfo:nil repeats:YES];
}


/* WebView의 로드가 완료됨 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 로딩 진행 바 초기화
    webView_.resourceCompletedCount_ = 0;
    webView_.resourceCount_ = 0;
    [webURLBar_ endProgress];
    
    // 네이게이션 버튼 활성화
    UIButton *backwardButton = [webNavigationBar_.subviews objectAtIndex:1];
    UIButton *forwardButton = [webNavigationBar_.subviews objectAtIndex:2];
    if (webView_.canGoBack)
    {
        backwardButton.enabled = YES;
    }
    else
    {
        backwardButton.enabled = NO;
    }
    if (webView_.canGoForward)
    {
        forwardButton.enabled = YES;
    }
    else
    {
        forwardButton.enabled = NO;
    }
   
    webURLBar_.reloadButton_.hidden = NO;
    
    [self removeHideTimer];
    hideTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(hideTimerCheck:) userInfo:nil repeats:YES];
    
    // 웹 뷰 초기화
    // webView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


/* 페이지 로드가 실패되다. */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // [webView_ stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
    [self removeHideTimer];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     webURLBar_.reloadButton_.hidden = YES;
}



/* 화면 로테이트가 되었다. */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.webURLBar_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, WEB_URL_BAR_HEIGHT)];
    [self.webView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.webNavigationBar_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
    webNavigationBar_.hidden = NO;
}


#pragma -
#pragma mark - UIScrollViewDelegate Method

/* 웹뷰가 스크롤되었다. */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"%f", webView_.scrollView.contentOffset.y);
    // NSLog(@"%f", webView_.scrollView.contentSize.height);
    
    //if (!scrollView.dragging)
    //    return;
    
    CGPoint webURLBarOrigin = webURLBar_.frame.origin;
    CGPoint webNavigationBarOrigin = webNavigationBar_.frame.origin;
    CGFloat offset = scrollView.contentOffset.y - contentOffset_.y;     // 스크롤이 이동된 거리
    
    if (scrollView.contentOffset.y < - WEB_URL_BAR_HEIGHT && contentOffset_.y > -WEB_URL_BAR_HEIGHT)
    {
        [webURLBar_ setFrame:CGRectMake(webURLBarOrigin.x, 0, webURLBar_.frame.size.width, webURLBar_.frame.size.height)];
        //[webNavigationBar_ setFrame:CGRectMake(webNavigationBarOrigin.x, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
    }
    
    if(offset < 0 && scrollView.contentOffset.y >= - WEB_URL_BAR_HEIGHT)
    {
        webURLBarOrigin.y = webURLBarOrigin.y - offset;
        if (webURLBarOrigin.y > 0)
            webURLBarOrigin.y = 0;
        
        [webURLBar_ setFrame:CGRectMake(webURLBarOrigin.x, webURLBarOrigin.y, webURLBar_.frame.size.width, WEB_URL_BAR_HEIGHT)];
        
        webNavigationBarOrigin.y = webNavigationBarOrigin.y + offset;
        
        if (webNavigationBarOrigin.y < self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT)
            webNavigationBarOrigin.y =  self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT;
        
        //[webNavigationBar_ setFrame:CGRectMake(webNavigationBarOrigin.x, webNavigationBarOrigin.y, webNavigationBar_.frame.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
        contentOffset_ = scrollView.contentOffset;
    }
    else if (offset > 0)
    {
        webURLBarOrigin.y = webURLBarOrigin.y - offset;
        if (webURLBarOrigin.y < - WEB_URL_BAR_HEIGHT)
            webURLBarOrigin.y = - WEB_URL_BAR_HEIGHT;
        
        [webURLBar_ setFrame:CGRectMake(webURLBarOrigin.x, webURLBarOrigin.y, webURLBar_.frame.size.width, WEB_URL_BAR_HEIGHT)];
        
        contentOffset_ = scrollView.contentOffset;
        
        if (scrollView.dragging)
        {
            webNavigationBarOrigin.y = webNavigationBarOrigin.y + offset;
            if (webNavigationBarOrigin.y > self.view.bounds.size.height)
                webNavigationBarOrigin.y =  self.view.bounds.size.height;
            //[webNavigationBar_ setFrame:CGRectMake(webNavigationBarOrigin.x, webNavigationBarOrigin.y, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
        }
    }
}


// 스크롤이 완료 되었을 때의 바 애니메이션
- (void)scrollCompleteBarAnimaiton
{
    CGPoint webURLBarOrigin = webURLBar_.frame.origin;
    CGPoint webNavigationBarOrigin = webNavigationBar_.frame.origin;
    
    
    // WebURLBar 애니메이션 //
     if (webURLBarOrigin.y > - WEB_URL_BAR_HEIGHT && webURLBarOrigin.y < - WEB_URL_BAR_HEIGHT / 2)
    {
        [UIView animateWithDuration:0.3f animations:^{
            // 애니메이션 블록 시작 //
            [webURLBar_ setFrame:CGRectMake(webURLBar_.frame.origin.x, self.view.bounds.origin.y - WEB_URL_BAR_HEIGHT, webURLBar_.bounds.size.width, WEB_URL_BAR_HEIGHT)];
            
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            if (webView_.scrollView.contentOffset.y < 1.0 && webView_.scrollView.contentOffset.y > - WEB_URL_BAR_HEIGHT)
                webView_.scrollView.contentOffset = CGPointMake(webView_.scrollView.contentOffset.x, 1.0);
            // 완료 블록 끝 //
        }];
    }
    else if (webURLBarOrigin.y >= - WEB_URL_BAR_HEIGHT / 2 && webURLBarOrigin.y < self.view.bounds.origin.y)
    {
        [UIView animateWithDuration:0.3f animations:^{
            // 애니메이션 블록 시작 //
            [webURLBar_ setFrame:CGRectMake(webURLBar_.frame.origin.x, self.view.bounds.origin.y, webURLBar_.bounds.size.width, WEB_URL_BAR_HEIGHT)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
            if (webView_.scrollView.contentOffset.y < 1.0 && webView_.scrollView.contentOffset.y > - WEB_URL_BAR_HEIGHT)
                webView_.scrollView.contentOffset = CGPointMake(webView_.scrollView.contentOffset.x, - WEB_URL_BAR_HEIGHT);
            // 완료 블록 끝 //
        }];
    }
    
    // WebNavigationBar 애니메이션 //
    if (webNavigationBarOrigin.y > self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT && webNavigationBarOrigin.y < self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT / 2 )
    {
        // 완료 블록 시작 //
        // webView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        // 완료 블록 끝 //
        [UIView animateWithDuration:0.3f animations:^{
            // 애니메이션 블록 시작 //
            //[webNavigationBar_ setFrame:CGRectMake(webNavigationBar_.frame.origin.x, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
        }];
    }
    else if (webNavigationBarOrigin.y >= self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT / 2 && webNavigationBarOrigin.y < self.view.bounds.size.height)
    {
        // 완료 블록 시작 //
        // webView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        // 완료 블록 끝 //
        [UIView animateWithDuration:0.3f animations:^{
            // 애니메이션 블록 시작 //
            //[webNavigationBar_ setFrame:CGRectMake(webNavigationBar_.frame.origin.x, self.view.bounds.size.height, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //[webURLBar_ setFrame:CGRectMake(webURLBar_.frame.origin.x, self.view.bounds.origin.y, webURLBar_.bounds.size.width, WEB_URL_BAR_HEIGHT)];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // [self scrollCompleteBarAnimaiton];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //[self scrollCompleteBarAnimaiton];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self scrollCompleteBarAnimaiton];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self scrollCompleteBarAnimaiton];
}
                          
                          
/* webURLBar 와 WebNavigationBar를 숨기는 시간을 정한다. */
- (void)hideTimerCheck:(NSTimer *)theTimer
{
    timerCount_ = timerCount_ + 0.05;
    if (timerCount_ >= 2.0)
    {
        if (webView_.scrollView.contentOffset.y <= - WEB_URL_BAR_HEIGHT)
        {
            timerCount_ = 0;
            return;
        }
        [UIView animateWithDuration:0.2f animations:^{
            [webURLBar_ setFrame:CGRectMake(webURLBar_.frame.origin.x, self.view.bounds.origin.y - WEB_URL_BAR_HEIGHT, webURLBar_.bounds.size.width, WEB_URL_BAR_HEIGHT)];
            if (webView_.scrollView.contentOffset.y < 1.0 && webView_.scrollView.contentOffset.y > - WEB_URL_BAR_HEIGHT)
                webView_.scrollView.contentOffset = CGPointMake(webView_.scrollView.contentOffset.x, - WEB_URL_BAR_HEIGHT);
            //[webNavigationBar_ setFrame:CGRectMake(webNavigationBar_.frame.origin.x, self.view.bounds.size.height, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
            if (self.lockScreen_.hidden == NO)
            {
                [UIView animateWithDuration:0.3f animations:^{
                    //[webNavigationBar_ setFrame:CGRectMake(webNavigationBar_.frame.origin.x, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
                    // 애니메이션 블록 끝 //
                } completion:^(BOOL finished) {
                }];
            }
            // 완료 블록 끝 //
        }];
        [self removeHideTimer];
    }
}
                              
                       
/* 타이머의 시간을 초기화 한다. */
- (void)resetHideTimerTimer
{
    timerCount_ = 0;
}
                          
/* 타이머를 종료 한다. */
- (void)removeHideTimer
{
    timerCount_ = 0;
    [hideTimer_ invalidate];
    hideTimer_ = nil;
}

- (void)listButtonTouched:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        //[webNavigationBar_ setFrame:CGRectMake(webNavigationBar_.frame.origin.x, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT, webNavigationBar_.bounds.size.width, WEB_NAVIGATION_BAR_HEIGHT)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
    }];
}


@end
