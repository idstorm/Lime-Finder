//
//  SystemBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 10..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_BAR_ICON_WIDTH 63.0

@class RootViewController;

@interface SystemBar : UIView <UIAlertViewDelegate>
{
    RootViewController  *rootViewController_;
    UIButton    *listButton_;
    NSArray *iconList_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain)   UIButton    *listButton_;
@property (nonatomic, retain)   NSArray    *iconList_;


/* 아이콘 버튼을 초기화 한다. */
- (void)initIconButtonList;
- (void)actionSet:(id)sender;
- (void)actionEdit:(id)sender;
- (void)actionAdd:(id)sender;
- (void)actionReset:(id)sender;
- (void)actionInfo:(id)sender;

/* 시스템바 항목을 초기화 한다. */
// 열린 항목을 모두 닫는다.
- (void)resetSystemBar;
@end
