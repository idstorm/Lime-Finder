//
//  WebNavigationBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 27..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebView.h"

@class RootViewController;

#define WEB_NAVIGATION_BAR_ICON_WIDTH 63.0

@interface WebNavigationBar : UIView
{
    
    WebView *webView_;
    RootViewController  *rootViewController_;
    
    CGSize barPortraitSideMargin_;
    CGSize barLandscapeSideMargin_;
    CGSize iconPortraitSize_;
    CGSize iconLandscapeSize_;

    NSInteger   iconCount_;
    UIButton    *listButton_;
    
    NSDictionary *barPropertyList_;
}

@property (nonatomic, retain) WebView   *webView_;
@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic) CGSize    barPortraitSideMargin_;
@property (nonatomic) CGSize    barLandscapeSideMargin_;
@property (nonatomic) CGSize    iconPortraitSize_;
@property (nonatomic) CGSize    iconLandscapeSize_;

@property (nonatomic) NSInteger iconCount_;
@property (nonatomic, retain)   UIButton    *listButton_;

@property (nonatomic, retain)   NSDictionary    *barPropertyList_;

- (id)initWithFrame:(CGRect)frame webView:(WebView *)webView;

- (void)initIconButtonList;

/* 리스트 아이콘 터치 */
- (void)actionList:(id)sender;

/* 리스트 아이콘 버튼 선택 */
- (void)selectListButton:(BOOL)select;

/* 뒤로가기 아이콘 터치 */
- (void)actionBackward:(id)sender;

/* 앞으로가기 아이콘 터치 */
- (void)actionForward:(id)sender;

/* 홈 아이콘 터치 */
- (void)actionHome:(id)sender;

/* 즐겨찾기 추가 */
- (void)actionAddList:(id)sender;

/* 더보기 아이콘 터치 */
- (void)actionMore:(id)sender;

@end
