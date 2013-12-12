//
//  SearchView.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 10..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBarTextField.h"

//#define REG_EXP @"^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$"

#define REG_EXP @"(?:\\b(?:(?:(?:(ftp|https?|mailto|telnet):\\/\\/)?(?:((?:[\\w$\\-_\\.\\+\\!\\*\\\'\\(\\),;\\?&=]|%[0-9a-f][0-9a-f])+(?:\\:(?:[\\w$\\-_\\.\\+\\!\\*\\\'\\(\\),;\\?&=]|%[0-9a-f][0-9a-f])+)?)\\@)?((?:[\\d]{1,3}\\.){3}[\\d]{1,3}|(?:[a-z0-9]+\\.|[a-z0-9][a-z0-9\\-]+[a-z0-9]\\.)+(?:biz|com|info|name|net|org|pro|aero|asia|cat|coop|edu|gov|int|jobs|mil|mobi|museum|tel|travel|ero|gov|post|geo|cym|arpa|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|me|md|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sk|sl|sm|sn|sr|st|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|za|zm|zw)|localhost)\\b(?:\\:([\\d]+))?)|(?:(file):\\/\\/\\/?)?([a-z]:))(?:\\/((?:(?:[\\w$\\-\\.\\+\\!\\*\\(\\),;:@=ㄱ-ㅎㅏ-ㅣ가-힣]|%[0-9a-f][0-9a-f]|&(?:nbsp|lt|gt|amp|cent|pound|yen|euro|sect|copy|reg);)*\\/)*)([^\\s\\/\\?:\\\"\\\'<>\\|#]*)(?:[\\?:;]((?:\\b[\\w]+(?:=(?:[\\w\\$\\-\\.\\+\\!\\*\\(\\),;:=ㄱ-ㅎㅏ-ㅣ가-힣]|%[0-9a-f][0-9a-f]|&(?:nbsp|lt|gt|amp|cent|pound|yen|euro|sect|copy|reg);)*)?\\&?)*))*(#[\\w\\-ㄱ-ㅎㅏ-ㅣ가-힣]+)?)?)"

#define SEARCH_VIEW_TRANSFORM_HEIGHT            48.0
#define LOGO_TOP_BOTTOM_MARGINE                 5.0
#define LOGO_WIDTH                              122.5
#define LOGO_HIGHT                              24.0
#define TITLE_BAR_HEIGHT                        40.0
#define SEARCH_FIELD_WIDTH                      300.0
#define SEARCH_FIELD_HEIGHT                     34.0
#define SEARCH_FIELD_SIDE_MARGINE               10.0
#define SEARCH_FIELD_TOP_BOTTOM_MARGINE         34.0
#define SEARCH_FIELD_IMAGE_SIDE_MARGINE         10
#define SEARCH_FIELD_IMAGE_TOP_BOTTOM_MARGINE   10
#define SEARCH_FIELD_IMAGE_WIDTH                30
#define SEARCH_FIELD_IMAGE_HEIGHT               34
#define SEARCH_VIEW_LABEL_SIDE_MARGINE          5
#define SEARCH_VIEW_LABEL_TOP_BOTTOM_MARGINE    10
#define SEARCH_VIEW_LABEL_WIDTH                 280
#define SEARCH_VIEW_LABEL_HEIGHT                15

/* 관리 상태 */
typedef enum
{
    SEARCH_VIEW_STATE_SEARCH,
    SEARCH_VIEW_STATE_URL_LINK
} SEARCH_VIEW_STATE;

@class RootViewController;

@interface SearchView : UIView <UITextFieldDelegate>
{
    RootViewController  *rootViewController_;
    UIImageView         *logoImageView_;
    SearchBarTextField  *searchField_;
    UIButton            *clearButton_;
    SEARCH_VIEW_STATE   searchViewState_;
    
    NSMutableData       *receivedImageData_;
    NSMutableArray      *suggestArray_;
    
    
    
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) UIImageView           *logoImageView_;
@property (nonatomic, retain) SearchBarTextField    *searchField_;
@property (nonatomic, retain) UIButton              *clearButton_;
@property (nonatomic) SEARCH_VIEW_STATE             searchViewState_;
@property (nonatomic, retain) NSMutableData         *receivedImageData_;
@property (nonatomic, retain) NSMutableArray        *suggestArray_;

/* 서브 뷰를 초기화 한다. */
- (void)initSubViews;

/* http:// 문자를 포함시킨 URL 문자열을 가져온다. */
-(NSString *)getURLStringWithString:(NSString *)string;

/* SearchTextField의 값이 변경되었다. */
- (void)searchFieldValueChanged:(id)sender;

/* 검색필드를 수정을 완료함 */
- (void)searchFieldEditingDidEnd:(id)sender;

/* 검색필드를 수정을 완료하고 키보드 리턴 */
- (void)searchFieldEditingDidEndOnExit:(id)sender;

/* WebNavigationBar의 list 액션에 맞게 크기가 수정된다. */
- (void)transformViews;

/* WebNavigationBar의 list 액션에 의해 수정된 크기를 되돌린다. */
- (void)returnTransformViews;

/* URL 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender;

/* 서치필드 왼쪽 버튼이 터치되다 */
- (void)leftViewButtonTouchUpedInside:(id)sender;

/* 연관 검색어를 가져온다. */
- (void)getSuggestSearchStringWithString:(NSString *)string;

- (void)getSuggestArrayWithString:(NSString *)string;
@end
