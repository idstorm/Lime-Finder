//
//  InfoView.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 27..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

#define INFO_VIEW_APP_LOGO_BUTTON_TOP_BOTTOM_MARGINE    50.0
#define INFO_VIEW_APP_LOGO_BUTTON_SIDE_MARGINE          60.0
#define INFO_VIEW_APP_LOGO_BUTTON_WIDTH                 200.0
#define INFO_VIEW_APP_LOGO_BUTTON_HEIGHT                165.0
#define INFO_VIEW_TEAM_LOGO_BUTTON_TOP_BOTTOM_MARGINE   50.0
#define INFO_VIEW_TEAM_LOGO_BUTTON_SIDE_MARGINE         60.0
#define INFO_VIEW_TEAM_LOGO_BUTTON_WIDTH                200.0
#define INFO_VIEW_TEAM_LOGO_BUTTON_HEIGHT               165.0
#define INFO_VIEW_LINK_BUTTON_TOP_BOTTOM_MARGINE        215.0
#define INFO_VIEW_LINK_BUTTON_SIDE_MARGINE              60.0
#define INFO_VIEW_LINK_BUTTON_WIDTH                     200.0
#define INFO_VIEW_LINK_BUTTON_HEIGHT                    45.0
#define INFO_BUTTON_BAR_HEIGHT                          45.0
#define INFO_VIEW_VERSION_HEIGHT                        20.0
#define INFO_VIEW_CREDIT_TOP_MARGINE                    50.0
#define INFO_VIEW_CREDIT_HEIGHT                         20.0

@interface InfoView : UIView
{
    RootViewController *rootViewController_;
    UIButton           *appLogoButton_;
    UIButton           *teamLogoButton_;
    UIButton           *limeWorksLinkButton_;
}

@property (nonatomic, retain) RootViewController *rootViewController_;
@property (nonatomic, retain) UIButton  *appLogoButton_;
@property (nonatomic, retain) UIButton  *teamLogoButton_;
@property (nonatomic, retain) UIButton  *limeWorksLinkButton_;

/* 서브뷰를 초기화 한다. */
-(void)initSubViews;

/* 앱 로고 버튼이 터치되다. */
-(void)appLogoButtonTouched:(id)sender;

/* 팀 로고 버튼이 터치되다. */
-(void)teamLogoButtonTouched:(id)sender;

/* 링크 버튼이 터치되다. */
-(void)linkButtonTouched:(id)sender;

@end
