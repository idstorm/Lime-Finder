//
//  WebURLBarTextField.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebURLBarTextField : UITextField
{
    CGFloat completed_;
    UIImage *urlTextFieldBackgroundImage_;
    BOOL    showProgress_;
}

@property (nonatomic) CGFloat completed_;
@property (nonatomic, retain) UIImage *urlTextFieldBackgroundImage_;
@property (nonatomic) BOOL showProgress_;

/* 진행상태를 설정하고, 컨텍스트를 갱신한다. */
- (void)setProgress:(CGFloat)complete;

/* 진행상태를 표시한다. */
- (void)showProgressBar;

/* 진행상태를 숨긴다. */
- (void)hideProgressBar;

@end