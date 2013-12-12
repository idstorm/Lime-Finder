//
//  RootViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController ()


@end

@implementation RootViewController

@synthesize mainViewController_;
@synthesize webViewController_;
@synthesize itemManageViewController_;
@synthesize listManager_;
@synthesize hostReach_;
@synthesize locationManager_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // NSLog(@"> %@\n", nibBundleOrNil);
    }
    return self;
}


/* ListManager를 초기화 한다. */
- (void)initListManager
{
    listManager_ = [[ListManager alloc] init];
}


/* 서브 콘트롤러 초기화 */
- (void)initSubControllers
{
    // 메인 뷰 콘트롤러 초기화
    mainViewController_ = [[MainViewController alloc] init];
    mainViewController_.view.frame = self.view.bounds;
    [self.view insertSubview:mainViewController_.view atIndex:0];
    
    // 웹 뷰 콘트롤러 초기화 
    webViewController_ = [[WebViewController alloc] init];
    webViewController_.view.frame = CGRectMake(self.view.bounds.size.width, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    webViewController_.shadowView_.hidden = YES;
    webViewController_.webURLBar_.layer.shadowOpacity = 0.0;
    [self.view insertSubview:webViewController_.view atIndex:1];
    // 메인 뷰 콘트롤러 뷰 추가
    
    
    // 아이템관리 뷰 콘트롤러 초기화
    // 아이템 관리 컨트롤러
    itemManageViewController_ = [[ItemManageViewController alloc] init];
    itemManageViewController_.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view insertSubview:itemManageViewController_.view atIndex:2];
    
    // locationManager_ = [[CLLocationManager alloc] init];
}


/* WebView를 보여준다. */
- (void)showWebView
{
    mainViewController_.listTableViewController_.listTableView_.scrollsToTop = NO;
    webViewController_.webView_.scrollView.scrollsToTop = YES;
    itemManageViewController_.webView_.scrollView.scrollsToTop = NO;
    
    if (!webViewController_.lockScreen_.hidden)
        webViewController_.lockScreen_.hidden = YES;
    
    webViewController_.shadowView_.hidden = NO;
    webViewController_.webURLBar_.layer.shadowOpacity = 0.5;

    [UIView animateWithDuration:0.2 animations:^{
        /* 애니메이션 블록 시작 */
        [webViewController_.view setFrame:CGRectMake(self.view.bounds.origin.x, webViewController_.view.bounds.origin.y, webViewController_.view.bounds.size.width, webViewController_.view.bounds.size.height)];
        /* 애니메이션 블록 끝 */
    } completion:^(BOOL finished) {
    }];
}


/* WebView를 숨긴다. */
- (void)hideWebView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        /* 애니메이션 블록 시작 */
        webViewController_.view.frame = CGRectMake(self.view.bounds.size.width, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        /* 애니메이션 블록 끝 */
    } completion:^(BOOL finished) {
        mainViewController_.listTableViewController_.listTableView_.scrollsToTop = YES;
        webViewController_.webView_.scrollView.scrollsToTop = NO;
        [webViewController_.webView_ stopLoading];
        itemManageViewController_.webView_.scrollView.scrollsToTop = NO;
        
        webViewController_.webURLBar_.layer.shadowOpacity = 0.0;
        webViewController_.shadowView_.hidden = YES;
    }];
    
}

/* 아이템 관리 뷰를 보인다. */
- (void)showItemManageView
{
    mainViewController_.listTableViewController_.listTableView_.scrollsToTop = NO;
    webViewController_.webView_.scrollView.scrollsToTop = NO;
    itemManageViewController_.webView_.scrollView.scrollsToTop = YES;
    [itemManageViewController_ setItemValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        // 애니메이션 블록 시작 //
        [itemManageViewController_.view  setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, itemManageViewController_.view.bounds.size.width, itemManageViewController_.view.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished)
    {
        [itemManageViewController_ setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
    }];
}

/* 아이템 관리 뷰를 숨긴다. */
- (void)hideItemManageView
{
    [itemManageViewController_ resetView]; // 아이템 관리 뷰를 재 설정 한다.
    [UIView animateWithDuration:0.3 animations:^{
        // 애니메이션 블록 시작 //
       [itemManageViewController_.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, itemManageViewController_.view.bounds.size.width, itemManageViewController_.view.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
        mainViewController_.listTableViewController_.listTableView_.scrollsToTop = NO;
        webViewController_.webView_.scrollView.scrollsToTop = YES;
        itemManageViewController_.webView_.scrollView.scrollsToTop = NO;
    }];
}


/* 뷰가 로드 되었다. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ListManager를 초기화 한다.
    [self initListManager];
    
    // 서브 콘트롤러 초기화
    [self initSubControllers];
}


/* 접속이 가능한지 체크 */
- (BOOL)isReachableWithHost:(NSString *)string
{
    if (string)
    {
        NSString *hostURL = [NSString stringWithString:string];
        hostURL = [hostURL lowercaseString];
        hostURL = [hostURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        hostURL = [hostURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        hostReach_ = [Reachability reachabilityWithHostName: hostURL];
        //[hostReach_ startNotifier];
    }
    else
    {
        hostReach_ = [Reachability reachabilityForInternetConnection];
    }
    
    switch ([hostReach_ currentReachabilityStatus])
    {
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            break;
        case NotReachable:
            return NO;
            break;
        default:
            break;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIViewControllerDelegateMethod
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
