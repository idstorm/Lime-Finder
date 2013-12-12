//
//  SearchBarTextField.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 23..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarTextField : UITextField
{
    CGFloat completed_;
    UIImage *urlTextFieldBackgroundImage_;
    BOOL    showProgress_;
}

@property (nonatomic) CGFloat completed_;
@property (nonatomic, retain) UIImage *urlTextFieldBackgroundImage_;
@property (nonatomic) BOOL showProgress_;

// 진행상태를 설정하고, 컨텍스트를 갱신한다.
- (void)setProgress:(CGFloat)complete;

@end
