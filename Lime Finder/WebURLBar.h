//
//  WebURLBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebURLBarTextField.h"

@class RootViewController;

@interface WebURLBar : UIView <UITextFieldDelegate>
{
    WebURLBarTextField      *urlTextField_;
    UIButton                *clearButton_;
    UIButton                *reloadButton_;
    RootViewController      *rootViewController_;
}

@property (nonatomic, retain) WebURLBarTextField    *urlTextField_;
@property (nonatomic, retain) UIButton              *clearButton_;
@property (nonatomic, retain) UIButton              *reloadButton_;
@property (nonatomic, retain) RootViewController    *rootViewController_;

/* 서브뷰를 초기화 한다. */
- (void)initViews;

/* 로딩 진행상태 표시를 시작한다. */
- (void)startProgress;

/* 진행상태를 세팅한다. */
- (void)setProgress:(NSInteger)completedCount totalCount:(NSInteger)totalCount;

/* 로딩 진행상태 표시를 끝낸다. */
- (void)endProgress;

/* URL 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender;

/* 웹페이지를 새로고침한다. */
- (void)reloadWebView:(id)sender;

/* 텍스트 필드의 값이 변경되다. */
- (void)urlTextFieldEditingChanged:(id)sender;
@end
