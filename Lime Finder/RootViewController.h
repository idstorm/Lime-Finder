//
//  RootViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "WebViewController.h"
#import "ListManager.h"
#import "Reachability.h"
#import "ItemManageViewController.h"
#import <CoreLocation/CoreLocation.h>



@interface RootViewController : UIViewController
{
    MainViewController  *mainViewController_;
    WebViewController   *webViewController_;
    ItemManageViewController    *itemManageViewController_;
    ListManager         *listManager_;
    Reachability        *hostReach_;
    CLLocationManager   *locationManager_;
}

@property (nonatomic, retain) MainViewController        *mainViewController_;
@property (nonatomic, retain) WebViewController         *webViewController_;
@property (nonatomic, retain) ItemManageViewController  *itemManageViewController_;
@property (nonatomic, retain) ListManager               *listManager_;
@property (nonatomic, retain) Reachability              *hostReach_;
@property (nonatomic, retain) CLLocationManager         *locationManager_;


/* ListManager를 초기화 한다. */
- (void)initListManager;

/* 서브 콘트롤러 초기화 */
- (void)initSubControllers;

/* WebView를 보여준다. */
- (void)showWebView;

/* WebView를 숨긴다. */
- (void)hideWebView;

/* 아이템 관리 뷰를 보인다. */
- (void)showItemManageView;

/* 아이템 관리 뷰를 숨긴다. */
- (void)hideItemManageView;

/* 접속이 가능한지 체크 */
- (BOOL)isReachableWithHost:(NSString *)string;




@end
