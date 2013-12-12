//
//  WebView.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 25..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "WebView.h"
#import "RootViewController.h"
#import "WebViewController.h"

@interface UIWebView ()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end

@implementation WebView

@synthesize progressDelegate_;
@synthesize resourceCount_;
@synthesize resourceCompletedCount_;
@synthesize rootViewController_;


/* 뷰 초기화 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        // 서브뷰를 추가한다. 
        [self initViews];
    }
    return self;
}


/* 서브뷰를 추가한다. */
- (void)initViews
{
    
    
}


/* 레이아웃이 변경되었을 경우 호출 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.top, 0);
}


/* 로딩 프로그래스 시작 */
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    // 네트워크 인디케이터를 켠다.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    [rootViewController_.webViewController_.webURLBar_ startProgress];
    [rootViewController_.webViewController_.webURLBar_ setProgress:resourceCompletedCount_ totalCount:resourceCount_];
    return [NSNumber numberWithInt:resourceCount_++];
}


/* 로딩 프로그래스 오류 발생 */
- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    resourceCompletedCount_++;

    if ([self.progressDelegate_ respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
     {
     [self.progressDelegate_ webView:self didReceiveResourceNumber:resourceCompletedCount_ totalResources:resourceCount_];
     }
    
    [rootViewController_.webViewController_.webURLBar_ setProgress:resourceCompletedCount_ totalCount:resourceCount_];
    // [rootViewController_.webViewController_.webURLBar_ endProgress];
   
    if(resourceCompletedCount_ == resourceCount_)
    {
        resourceCompletedCount_ = 0;
        resourceCount_ = 0;
        [rootViewController_.webViewController_.webURLBar_ endProgress];
        //NSLog(@"전체 완료");
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog(@"수신 오류 발생 count:%d total:%d", resourceCompletedCount_, resourceCount_);
}


/* 로딩 데이터 소스 수신 완료 */
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    resourceCompletedCount_++;
    
    if ([self.progressDelegate_ respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
    {
     [self.progressDelegate_ webView:self didReceiveResourceNumber:resourceCompletedCount_ totalResources:resourceCount_];
    }
    
    [rootViewController_.webViewController_.webURLBar_ setProgress:resourceCompletedCount_ totalCount:resourceCount_];
        
    if(resourceCompletedCount_ == resourceCount_)
    {
        resourceCompletedCount_ = 0;
        resourceCount_ = 0;
        [rootViewController_.webViewController_.webURLBar_ endProgress];
        //NSLog(@"전체 완료");
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //NSLog(@"데이터 수신 완료 count:%d total:%d", resourceCompletedCount_, resourceCount_);
}


/* 수퍼 뷰에서 뷰가 제가되다 */
- (void)removeFromSuperview
{
    [rootViewController_ hideWebView];
    [super removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
