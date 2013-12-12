//
//  MainViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableViewController.h"
#import "SearchView.h"
#import "SettingButtonBar.h"
#import "EditButtonBar.h"
#import "SystemBar.h"
#import "InfoView.h"
#import "InfoButtonBar.h"
#import "SuggestListTableViewController.h"




#define SEARCH_VIEW_HEIGHT              78.0
#define SEARCH_VIEW_TRANSFORM_HEIGHT    48.0
#define KEYBORD_BAR_HEIGHT              40.0
#define SYSTEM_BAR_HEIGHT               45.0
#define SHADOW_VIEW_HEIGHT              100.0

@class RootViewController;

@interface MainViewController : UIViewController <UISearchBarDelegate>
{
    BOOL                    isTransformed_;     // View의 크기가 변경되었는지 여부
    SearchView              *searchview_;
    SettingButtonBar        *settingButtonBar_;
    EditButtonBar           *editButtonBar_;
    SystemBar               *systemBar_;
    ListTableViewController *listTableViewController_;
    RootViewController      *rootViewController_;
    InfoView                *infoView_;
    InfoButtonBar           *infoButtonBar_;
    UIView                  *shadowScreen_;
    
    SuggestListTableViewController  *suggestListTableViewController_;
    
    
}

@property (nonatomic)         BOOL              isTransformed_;
@property (nonatomic, retain) SearchView        *searchView_;
@property (nonatomic, retain) SettingButtonBar  *settingButtonBar_;
@property (nonatomic, retain) EditButtonBar     *editButtonBar_;
@property (nonatomic, retain) SystemBar         *systemBar_;
@property (nonatomic, retain) ListTableViewController   *listTableViewController_;
@property (nonatomic, retain) RootViewController        *rootViewController_;
@property (nonatomic, retain) InfoView          *infoView_;
@property (nonatomic, retain) InfoButtonBar     *infoButtonBar_;
@property (nonatomic, retain) UIView            *shadowScreen_;

@property (nonatomic, retain) SuggestListTableViewController    *suggestListTableViewController_;


/* Subview 들을 초기화 한다. */
- (void)initSubObject;

/* WebNavigationBar의 list 액션에 맞게 크기가 수정된다. */
- (void)transformViews:(CGRect)rect;

/* WebNavigationBar의 list 액션에 의해 수정된 크기를 되돌린다. */
- (void)returnTransformViews;

/* 편집 버튼이 터치되었다. */
//- (void)editButtonTouchUpInside:(id)sender;

/* List 추가모드를 끝낸다. */
//- (void)endAddMode:(id)sender;

/* List를 수정모드로 진입한다. */
- (void)setEditMode:(id)sender;

/* List 수정모드를 끝낸다. */
- (void)endEditMode:(id)sender;

/* 시스템 바를 보인다. */
- (void)showSystemBar;

/* 편집버튼바를 보인다. */
- (void)showEditButtonBar;

/* 편집버튼바를 숨긴다. */
- (void)hideEditButtonBar;

/* 시스템 바를 숨긴다. */
- (void)hideSystemBar;

/* WebView를 숨긴다. */
- (void)hideWebView;

/* 소개 뷰를 보인다. */
- (void)showInfoView;

/* 소개 뷰를 숨긴다. */
- (void)hideInfoView;

/* 소개 뷰를 숨긴다. */
- (void)hideInfoViewNoAnimation;

/* Shadow Screen 을 탭하다 */
-(void)shadowSreenTapped:(id)sender;

@end
