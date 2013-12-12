//
//  ItemManageViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 13..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManageButtonBar.h"
#import "MessageView.h"
#import "CloseMessageView.h"
#import "Step01View.h"
#import "Step02View.h"
#import "Step03View.h"
#import "Step04View.h"
#import "Step05View.h"
#import "ItemManage.h"
#import "ItemManageWebView.h"

#define ITEM_MANAGE_BUTTON_BAR_HEIGHT   45.0

@class RootViewController;

@interface ItemManageViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>
{
    RootViewController       *rootViewController_;
    
    NSInteger                itemIndex_;
    
    ItemManageButtonBar      *itemManageButtonBar_;
    ItemManageWebView        *webView_;
    MessageView              *messageView_;
    CloseMessageView         *closeMessageView_;
    //Step01View               *step01View_;
    Step02View               *step02View_;
    Step03View               *step03View_;
    Step04View               *step04View_;
    Step05View               *step05View_;
    
    ItemManageState                 itemManageState_;
    ItemManageSequence              itemManageSequence_;
    ItemManageStringEncodingType    itemManageStringEncodingType_;
    
    NSMutableDictionary      *itemMutableDictionary_;
    
    NSString                 *prevSearchURL_;
    NSString                 *searchURLString_;
    NSTimer                  *messageTimer_;
    float                    messageTimerCounter_;
    
    UIView                   *shadowScreen_;
    
    
}

@property (nonatomic, retain)   RootViewController    *rootViewController_;

@property (nonatomic)           NSInteger             itemIndex_;

@property (nonatomic, retain)   ItemManageButtonBar   *itemManageButtonBar_;
@property (nonatomic, retain)   ItemManageWebView     *webView_;
@property (nonatomic, retain)   MessageView           *messageView_;
@property (nonatomic, retain)   CloseMessageView      *closeMessageView_;
@property (nonatomic, retain)   Step01View            *step01View_;
@property (nonatomic, retain)   Step02View            *step02View_;
@property (nonatomic, retain)   Step03View            *step03View_;
@property (nonatomic, retain)   Step04View            *step04View_;
@property (nonatomic, retain)   Step05View            *step05View_;
@property (nonatomic)           ItemManageState                 itemManageState_;
@property (nonatomic)           ItemManageSequence              itemManageSequence_;
@property (nonatomic)           ItemManageStringEncodingType    itemManageStringEncodingType_;

@property (nonatomic, retain)   NSMutableDictionary   *itemMutableDictionary_;

@property (nonatomic, retain)   NSString              *prevSearchURL_;
@property (nonatomic, retain)   NSString              *searchURLString_;
@property (nonatomic, retain)   NSTimer               *messageTimer_;
@property (nonatomic)           float                 messageTimerCounter_;

@property (nonatomic, retain)   UIView                *shadowScreen_;

/* 서브 뷰를 초기화 한다. */
- (void)initSubViews;

/* ItemManageView를 초기화 한다. */
- (void)resetView;

/* 각 설정 뷰에 아이템 값을 설정한다 .*/
- (void)setItemValue;

/* URL로 웹 컨텐츠를 요청한다. */
- (void)requestWithURL:(NSURL *)url;

/* String으로 웹 컨텐츠를 요청한다. */
- (void)requestWithString:(NSString *)string;

/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence;

/* 메세지뷰의 왼쪽 버튼이 터치되다. */
- (void)messageViewLeftButtonTouched:(id)sender;

/* 메세지뷰의 오른쪽 버튼이 터치되다. */
- (void)messageViewRightButtonTouched:(id)sender;

/* 아이템 관리 뷰를 종료한다. */
- (void)closeItemManageView;

/* 클로즈 메세지뷰의 왼쪽 버튼이 터치되다. */
- (void)closeMessageViewLeftButtonTouched:(id)sender;

/* 클로즈 메세지뷰의 오른쪽 버튼이 터치되다. */
- (void)closeMessageViewRightButtonTouched:(id)sender;

/* 메세지뷰를 보인다. */
- (void)showMessageView:(BOOL)messageViewHidden;

/* 메세지뷰를 숨긴다. */
- (void)hideMessageView:(BOOL)messageViewHidden;

/* 클로즈 메세지뷰를 보인다. */
- (void)showCloseMessageView:(BOOL)messageViewHidden;

/* 클로즈 메세지뷰를 숨긴다. */
- (void)hideCloseMessageView:(BOOL)messageViewHidden;

/* 클로즈 메세지뷰를 숨기 후, 메세지뷰를 보여준다.*/
- (void)showMessageViewAfterHideCloseMessageView:(BOOL)messageViewHidden;

/* 메세지뷰를 숨기 후, 클로즈 메세지뷰 보여준다.*/
- (void)showCloseMessageViewAfterHideMessageView:(BOOL)messageViewHidden;

/* Shadow Screen 을 탭하다 */
- (void)shadowSreenTapped:(id)sender;

/* LimeFiner Query URL 유효성 체크 */
- (BOOL)limeFinderQueryURLValidCheck:(NSString *)urlString;

/* URL 을 LimeFiner Query 문자열로 반환한다. */
- (NSString *)getLimeFinderQueryURLStringWithURLString:(NSString *)string;

/* WebView가 Data 수신할때 마다 호출된다. */
- (void)loadedFromWebViewResourceData;

/* URL 사용가능 확인창의 지연을 준다. 로딩을 다시 하면 타이머가 초기화 된다. */
-(void)messageTimerCheck:(NSTimer *)theTimer;

/* 메세지 타이머의 시간을 초기화 한다. */
-(void)resetMessageTimer;

/* 타이머를 종료 한다. */
- (void)removeMessageTimer;

- (void)keyboardWillAnimate:(NSNotification *)notification;


- (void)webViewTapped:(id)sender;

@end
