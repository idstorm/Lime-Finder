//
//  WebViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebURLBar.h"
#import "WebView.h"
#import "WebNavigationBar.h"
#import "MoreView.h"

#define WEB_URL_BAR_HEIGHT          48.0
#define WEB_NAVIGATION_BAR_HEIGHT   45.0
#define MORE_VIEW_WIDTH             480.0
#define MORE_VIEW_HEIGHT            148.0

@class RootViewController;

@interface WebViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>
{
    RootViewController  *rootViewController_;
    WebURLBar           *webURLBar_;
    WebView             *webView_;
    WebNavigationBar    *webNavigationBar_;
    MoreView            *moreView_;
    UIView              *shadowView_;
    UIView              *shadowScreen_;
    UIView              *lockScreen_;
    NSTimer             *hideTimer_;
    
    UIButton            *listButton_;
    
    CGPoint             contentOffset_;
    float               timerCount_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) WebURLBar             *webURLBar_;
@property (nonatomic, retain) WebView               *webView_;
@property (nonatomic, retain) WebNavigationBar      *webNavigationBar_;
@property (nonatomic, retain) MoreView              *moreView_;
@property (nonatomic, retain) UIView                *shadowView_;
@property (nonatomic, retain) UIView                *shadowScreen_;
@property (nonatomic, retain) UIView                *lockScreen_;
@property (nonatomic, retain) NSTimer               *hideTimer_;
@property (nonatomic, retain) UIButton              *listButton_;

@property (nonatomic)         float                 timerCount_;
@property (nonatomic)         CGPoint               contentOffset_;

/* URL로 웹 컨텐츠를 요청한다. */
-(void)requestWithURL:(NSURL *)url;

/* MoreView를 나타낸다. */
- (void)showMoreView;

/* MoreView를 숨긴다. */
- (void)hideMoreView;

/* 스크롤이 완료 되었을 때의 바 애니메이션 */
- (void)scrollCompleteBarAnimaiton;

/* Shadow Screen 을 탭하다 */
-(void)shadowSreenTapped:(id)sender;

/* Lock Screen 을 탭하다 */
-(void)lockSreenTapped:(id)sender;

/* webURLBar 와 WebNavigationBar를 숨기는 시간을 정한다. */
-(void)hideTimerCheck:(NSTimer *)theTimer;

/* 타이머의 시간을 초기화 한다. */
-(void)resetHideTimerTimer;

/* 타이머를 종료 한다. */
- (void)removeHideTimer;

- (void)listButtonTouched:(id)sender;


@end
