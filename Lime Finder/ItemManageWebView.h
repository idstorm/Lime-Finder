//
//  ItemManageWebView.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 30..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;

@class ItemManageWebView;

@protocol ItemManageWebViewProgressDelegate <NSObject>;

@optional
-(void) webView:(ItemManageWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end

@interface ItemManageWebView : UIWebView
{
    RootViewController *rootViewController_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, assign) int resourceCount_;
@property (nonatomic, assign) int resourceCompletedCount_;
@property (nonatomic, assign) id<ItemManageWebViewProgressDelegate> progressDelegate_;

@end
