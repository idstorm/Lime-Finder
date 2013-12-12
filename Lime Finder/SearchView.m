//
//  SearchView.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 10..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "RootViewController.h"
#import "SearchView.h"
#import <QuartzCore/QuartzCore.h>
#import "RegexKitLite.h"


@implementation SearchView

@synthesize rootViewController_;
@synthesize logoImageView_;
@synthesize searchField_;
@synthesize clearButton_;
@synthesize searchViewState_;
@synthesize receivedImageData_;
@synthesize suggestArray_;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        CGFloat shadowColor[] = {0, 0, 0, 1.f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpace, shadowColor);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowColor = color;
        self.layer.shadowOpacity = 0.5;
        CGColorRelease(color);
        CGColorSpaceRelease(colorSpace);
        searchViewState_ = SEARCH_VIEW_STATE_SEARCH;
        
        suggestArray_ = [[NSMutableArray alloc] init];
        
        // 서브 뷰를 초기화 한다.
        [self initSubViews];
    }
    return self;
}

// 서브 뷰를 초기화 한다. //
- (void)initSubViews
{
    // 로고
    UIImage *logoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_top_logo" ofType:@"png"]];
    logoImageView_ = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView_.frame = CGRectMake(self.bounds.size.width / 2.0 - LOGO_WIDTH / 2.0, LOGO_TOP_BOTTOM_MARGINE, LOGO_WIDTH, LOGO_HIGHT);
    [self addSubview:logoImageView_];
    
    
    // 검색 필드
    UIImage *clearButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_closs" ofType:@"png"]];
    UIView  *clearBlankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 39.0, 34.0)];
    clearButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton_ setImage:clearButtonImage forState:UIControlStateNormal];
    [clearButton_ setFrame:CGRectMake(0, 0, 34.0, 34.0)];
    [clearButton_ addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchDown];
    clearButton_.hidden = YES;
    [clearBlankView addSubview:clearButton_];
    
    UIImage *searchIconImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_search_02" ofType:@"png"]];
    UIImage *linkIconImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_url_link_02" ofType:@"png"]];
    UIButton *leftViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftViewButton setImage:searchIconImage forState:UIControlStateNormal];
    [leftViewButton setImage:linkIconImage forState:UIControlStateSelected];
    [leftViewButton addTarget:self action:@selector(leftViewButtonTouchUpedInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView  *blank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEARCH_FIELD_IMAGE_WIDTH + SEARCH_FIELD_IMAGE_SIDE_MARGINE, SEARCH_FIELD_IMAGE_HEIGHT)];
    [leftViewButton setFrame:CGRectMake(SEARCH_FIELD_IMAGE_SIDE_MARGINE / 2.0, 0, SEARCH_FIELD_IMAGE_WIDTH, SEARCH_FIELD_IMAGE_HEIGHT)];
    [blank addSubview:leftViewButton];
        
    searchField_ = [[SearchBarTextField alloc] initWithFrame:CGRectMake(self.bounds.origin.x + SEARCH_FIELD_SIDE_MARGINE, self.bounds.origin.y + SEARCH_FIELD_TOP_BOTTOM_MARGINE, SEARCH_FIELD_WIDTH, SEARCH_FIELD_HEIGHT)];
    searchField_.delegate = self;
    searchField_.keyboardType = UIKeyboardTypeDefault;
    searchField_.returnKeyType = UIReturnKeySearch;
    searchField_.borderStyle = UITextBorderStyleNone;
    searchField_.adjustsFontSizeToFitWidth = YES;
    searchField_.textColor = [UIColor whiteColor];
    searchField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField_.backgroundColor = [UIColor whiteColor];
    searchField_.leftViewMode = UITextFieldViewModeAlways;
    searchField_.leftView = blank;
    searchField_.rightViewMode = UITextFieldViewModeAlways;
    searchField_.rightView = clearBlankView;
    searchField_.placeholder = @"Search";
    [searchField_ addTarget:self action:@selector(searchFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [searchField_ addTarget:self action:@selector(searchFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [searchField_ addTarget:self action:@selector(searchFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self addSubview:searchField_];
}


/* http:// 문자를 포함시킨 URL 문자열을 가져온다. */
-(NSString *)getURLStringWithString:(NSString *)string
{
    NSString *urlString = @"";
    if([[string lowercaseString] rangeOfString:@"http://"].location == NSNotFound && [[string lowercaseString] rangeOfString:@"https://"].location == NSNotFound)
    {
        urlString = [[NSString alloc] initWithFormat:@"http://%@", string];
    }
    else
    {
        urlString = string;
    }
    return urlString;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{

}
*/


/* 서치 텍스트 필드의 수정이 시작 됨 */ 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 쉐도우 뷰를 보인다. - 터치시 키보드를 숨기는 역할을 한다.
    rootViewController_.mainViewController_.shadowScreen_.hidden = NO;
    
    if (![textField.text isEqualToString:@""] && textField.text != nil)
    {
        rootViewController_.mainViewController_.suggestListTableViewController_.tableView.hidden = NO;
    }
    
    
    
    // 만약 웹뷰가 보이는 상태이면 웹 뷰를 숨긴다. 
    [rootViewController_ hideWebView];
        
    // 메인페이지의 상태를 되돌린다.
    [rootViewController_.mainViewController_ returnTransformViews];
    
    // 링크 이미지와 링크버튼을 보인다.
    // searchViewLabel_.hidden = NO;
    
    // 수정이 시작되고, searchField의 값이 있을경우만 클리어 버튼을 보인다.
    if (![searchField_.text isEqualToString:@""] && searchField_.text != nil)
    {
        clearButton_.hidden = NO;
    }
    else
    {
        clearButton_.hidden = YES;
    }
    
    // 만약 시스템바가 활성화되어있으면, 시스템바의 상태를 해제한다.
    [rootViewController_.mainViewController_.systemBar_ resetSystemBar];

    return YES;
}


/* WebNavigationBar의 list 액션에 맞게 크기가 수정된다. */
- (void)transformViews
{
    // searchViewLabel_.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, rootViewController_.mainViewController_.view.bounds.size.width, self.bounds.size.height)];
        [searchField_ setFrame:CGRectMake(searchField_.frame.origin.x, searchField_.frame.origin.y, self.bounds.size.width - SEARCH_FIELD_SIDE_MARGINE * 2, SEARCH_FIELD_HEIGHT)];
        logoImageView_.frame = CGRectMake(self.bounds.size.width / 2.0 - LOGO_WIDTH / 2.0, LOGO_TOP_BOTTOM_MARGINE, LOGO_WIDTH, LOGO_HIGHT);
    } completion:^(BOOL finished)
     {
         
     }];
}


/* WebNavigationBar의 list 액션에 의해 수정된 크기를 되돌린다. */
- (void)returnTransformViews
{
    // searchViewLabel_.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, rootViewController_.mainViewController_.view.bounds.size.width, self.bounds.size.height)];
        [searchField_ setFrame:CGRectMake(searchField_.frame.origin.x, searchField_.frame.origin.y, self.bounds.size.width - SEARCH_FIELD_SIDE_MARGINE * 2, SEARCH_FIELD_HEIGHT)];
        logoImageView_.frame = CGRectMake(self.bounds.size.width / 2.0 - LOGO_WIDTH / 2.0, LOGO_TOP_BOTTOM_MARGINE, LOGO_WIDTH, LOGO_HIGHT);
    } completion:^(BOOL finished)
     {
         
     }];
}


/* SearchTextField의 값이 변경되었다. */
- (void)searchFieldValueChanged:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    NSString *string = textField.text;
    NSString *urlString = @"";
    
    urlString = [self getURLStringWithString:string];
    
    if ([string isEqualToString:@""] || string == nil)
    {
        clearButton_.hidden = YES;
        rootViewController_.mainViewController_.suggestListTableViewController_.view.hidden = YES;
        rootViewController_.mainViewController_.shadowScreen_.hidden = NO;
    }
    else
    {
        clearButton_.hidden = NO;
        rootViewController_.mainViewController_.suggestListTableViewController_.view.hidden = NO;

    }
    
    if (searchViewState_ == SEARCH_VIEW_STATE_SEARCH)
    {
        [rootViewController_.mainViewController_.listTableViewController_ setSearchString:string];
        [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
    }
    
    [self getSuggestSearchStringWithString:string];
}


/* URL 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender
{
    searchField_.text = @"";
    clearButton_.hidden = YES;
    [rootViewController_.mainViewController_.listTableViewController_ setSearchString:@""];
    [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
    [suggestArray_ removeAllObjects];
    [rootViewController_.mainViewController_.suggestListTableViewController_.tableView reloadData];
    rootViewController_.mainViewController_.suggestListTableViewController_.view.hidden = YES;
    rootViewController_.mainViewController_.shadowScreen_.hidden = NO;
}




/* 검색필드를 수정을 완료함 */
- (void)searchFieldEditingDidEnd:(id)sender
{
    rootViewController_.mainViewController_.shadowScreen_.hidden = YES;
    rootViewController_.mainViewController_.suggestListTableViewController_.tableView.hidden = YES;
    clearButton_.hidden = YES;
}


/* 검색필드를 수정을 완료하고 키보드 리턴 */
- (void)searchFieldEditingDidEndOnExit:(id)sender
{
    if (searchViewState_ == SEARCH_VIEW_STATE_URL_LINK)
    {
        NSString *string = searchField_.text;
        NSString *urlString = @"";
        if (![string isEqualToString:@""] && string != nil)
        {
                
                urlString = [self getURLStringWithString:string];
                [rootViewController_.webViewController_.webNavigationBar_ selectListButton:NO];
                [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:urlString]];
                [rootViewController_ showWebView];
        }
    }
    rootViewController_.mainViewController_.shadowScreen_.hidden = YES;
    rootViewController_.mainViewController_.suggestListTableViewController_.tableView.hidden = YES;
    clearButton_.hidden = YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 만약 웹뷰가 보이는 상태이면 웹 뷰를 숨긴다.
    // searchViewLabel_.hidden = NO;
    [rootViewController_.mainViewController_ returnTransformViews];
    [rootViewController_ hideWebView];
    rootViewController_.mainViewController_.shadowScreen_.hidden = YES;
    rootViewController_.mainViewController_.suggestListTableViewController_.tableView.hidden = YES;
    [searchField_ resignFirstResponder];
}


/* 서치필드 왼쪽 버튼이 터치되다 */
- (void)leftViewButtonTouchUpedInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [rootViewController_.mainViewController_.listTableViewController_ setSearchString:@""];
    [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
    button.selected = !button.selected;
    [searchField_ resignFirstResponder];
    if (button.selected)
    {
        searchViewState_ = SEARCH_VIEW_STATE_URL_LINK;
        
        searchField_.placeholder = @"URL";
        searchField_.keyboardType = UIKeyboardTypeURL;
        searchField_.returnKeyType = UIReturnKeyGo;
    }
    else
    {
        searchViewState_ = SEARCH_VIEW_STATE_SEARCH;
        searchField_.text = @"";
        searchField_.placeholder = @"Search";
        searchField_.keyboardType = UIKeyboardTypeDefault;
        searchField_.returnKeyType = UIReturnKeyGo;
    }
    
    [searchField_ becomeFirstResponder];
}


/* 연관 검색어를 가져온다. */
- (void)getSuggestSearchStringWithString:(NSString *)string;
{
    // URLRequest 생성
    NSString *queryURLString = [[NSString alloc]initWithFormat:@"http://sug.search.daum.net/search_nsuggest?mod=fxjson&code=utf_in_out&q=%@", [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"%@",queryURLString);
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:queryURLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // URLConnection 생성
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection)
    {
        receivedImageData_ = [NSMutableData data];
    }
}


/* 데이터 수신에 대한 응답이 됨 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedImageData_ setLength:0];
}


/* 데이터 수신 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedImageData_ appendData:data];
}


/* 데이터 수신 실패 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    receivedImageData_ = nil;
    [suggestArray_ removeAllObjects];
    [suggestArray_ addObject:@"관련검색어를 가져올 수 없습니다."];
    [rootViewController_.mainViewController_.suggestListTableViewController_.tableView reloadData];
}


/* 데이터 수신 완료 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *suggestString = [[NSString alloc] initWithData:receivedImageData_ encoding:NSUTF8StringEncoding];
    [self getSuggestArrayWithString:suggestString];
    // NSLog(@"%@",suggestString);
}


- (void)getSuggestArrayWithString:(NSString *)string
{
    NSString *suggestString = [[NSString alloc] initWithString:string];
    suggestString = [suggestString stringByReplacingOccurrencesOfString:@"[\"\",[],[]]\n" withString:@""];
    suggestString = [suggestString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    suggestString = [suggestString stringByReplacingOccurrencesOfString:@"]" withString:@""];
    suggestString = [suggestString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    suggestString = [suggestString stringByReplacingOccurrencesOfString:@",\n" withString:@""];
    // [suggestString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
    if ([suggestString isEqualToString:@""] || suggestString == nil)
    {
        [suggestArray_ removeAllObjects];
    }
    else
    {
        [suggestArray_ setArray:[suggestString componentsSeparatedByString:@","]];
        [suggestArray_ removeObjectAtIndex:0];

    }
    [rootViewController_.mainViewController_.suggestListTableViewController_.tableView reloadData];
}



@end
