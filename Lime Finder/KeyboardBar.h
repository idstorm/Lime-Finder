//
//  KeyboardBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_SIZE 38.0

@interface KeyboardBar : UIView
{
    UIButton *pullDownButton_;
}

@property (nonatomic, retain) UIButton  *pullDownButton_;

/* 서브뷰를 추가한다. */
- (void)initSubViews;

@end
