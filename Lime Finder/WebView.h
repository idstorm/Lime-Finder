//
//  WebView.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 25..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@class WebView;

@protocol WebViewProgressDelegate <NSObject>;

@optional
-(void) webView:(WebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end


@interface WebView : UIWebView
{
    RootViewController *rootViewController_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, assign) int resourceCount_;
@property (nonatomic, assign) int resourceCompletedCount_;
@property (nonatomic, assign) id<WebViewProgressDelegate> progressDelegate_;


/* 서브뷰를 추가한다. */
- (void)initViews;

@end
