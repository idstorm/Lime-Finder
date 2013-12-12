//
//  ItemManageViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 13..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ItemManageViewController.h"
#import "RootViewController.h"

#define URL_BAR_HEIGHT                          40.0
#define MESSAGE_VIEW_HEIGHT                     129.0
#define CLOSE_MESSAGE_VIEW_HEIGHT               129.0

#define QUERY_STRING                           @"라임파인더"



@interface ItemManageViewController ()

@end

@implementation ItemManageViewController

@synthesize rootViewController_;

@synthesize itemIndex_;

@synthesize itemManageButtonBar_;
@synthesize webView_;
@synthesize messageView_;
@synthesize closeMessageView_;
@synthesize itemManageSequence_;
@synthesize itemManageState_;
@synthesize itemManageStringEncodingType_;
@synthesize itemMutableDictionary_;

//@synthesize step01View_;
@synthesize step02View_;
@synthesize step03View_;
@synthesize step04View_;
@synthesize step05View_;

@synthesize prevSearchURL_;
@synthesize searchURLString_;
@synthesize messageTimer_;
@synthesize messageTimerCounter_;

@synthesize shadowScreen_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        itemManageState_ = ITEM_MANAGE_STATE_ADD;
        itemManageSequence_ = ITEM_MANAGE_SEQUENCE_STEP_01_01;
        itemManageStringEncodingType_ = ITEM_MANAGE_STRING_ENCODING_TYPE_UTF8;
        itemMutableDictionary_ = [[NSMutableDictionary alloc] init];
        itemIndex_ = -1;
        prevSearchURL_ = @"";
        searchURLString_ = @"";
        messageTimer_ = nil;
        messageTimerCounter_ = 0;
    }
    return self;
}


/* 서브 뷰를 초기화 한다. */
- (void)initSubViews
{
    // WebView //
    webView_ = [[ItemManageWebView alloc] initWithFrame:webView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + URL_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - WEB_NAVIGATION_BAR_HEIGHT)];
    
    webView_.delegate = self;
    webView_.hidden = YES;
    [webView_ setScalesPageToFit:YES];
    //UITapGestureRecognizer *webViewTabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapped:)];
    // [webView_ addGestureRecognizer:webViewTabGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [self.view addSubview:webView_];
    
    // Shadow Screen //
    shadowScreen_ = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowScreen_.backgroundColor = [UIColor blackColor];
    shadowScreen_.hidden = YES;
    shadowScreen_.alpha = 0.8;
    UITapGestureRecognizer *shadowScreenTabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowSreenTapped:)];
    [shadowScreen_ addGestureRecognizer:shadowScreenTabGestureRecognizer];
    [self.view addSubview:shadowScreen_];
    
    // Message View //
    messageView_ = [[MessageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT)];
    messageView_.backgroundColor = [UIColor whiteColor];
    messageView_.hidden = YES;
    messageView_.messageLabel_.text = @"";
    [messageView_.leftButton_ addTarget:self action:@selector(messageViewLeftButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [messageView_.rightButton_ addTarget:self action:@selector(messageViewRightButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageView_];
    
    // Close Message View //
    closeMessageView_ = [[CloseMessageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT)];
    closeMessageView_.backgroundColor = [UIColor whiteColor];
    closeMessageView_.hidden = YES;
    closeMessageView_.messageLabel_.text = @"";
    [closeMessageView_.leftButton_ addTarget:self action:@selector(closeMessageViewLeftButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [closeMessageView_.rightButton_ addTarget:self action:@selector(closeMessageViewRightButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMessageView_];
    
    // Step01View //
    //step01View_ = [[Step01View alloc] initWithFrame:self.view.bounds];
    //step02View_.hidden = YES;
    //[self.view addSubview:step01View_];
    
    // Step02View //
    step02View_ = [[Step02View alloc] initWithFrame:self.view.bounds];
    step02View_.hidden = YES;
    [self.view addSubview:step02View_];
    
    // Step03View //
    step03View_ = [[Step03View alloc] initWithFrame:self.view.bounds];
    step03View_.frame = CGRectMake(step03View_.bounds.origin.x, -step03View_.bounds.size.height, step03View_.bounds.size.width, step03View_.bounds.size.height);
    step03View_.hidden = YES;
    [self.view addSubview:step03View_];
    
    // Step04View //
    step04View_ = [[Step04View alloc] initWithFrame:self.view.bounds];
    step04View_.frame = CGRectMake(step04View_.bounds.origin.x, -step04View_.bounds.size.height, step04View_.bounds.size.width, step04View_.bounds.size.height);
    step04View_.hidden = YES;
    [self.view addSubview:step04View_];
    
    // Step05View //
    step05View_ = [[Step05View alloc] initWithFrame:self.view.bounds];
    step05View_.frame = CGRectMake(step05View_.bounds.origin.x, -step05View_.bounds.size.height, step05View_.bounds.size.width, step05View_.bounds.size.height);
    step05View_.hidden = YES;
    [self.view addSubview:step05View_];
    
    // 추가 바 //
    itemManageButtonBar_ = [[ItemManageButtonBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - SYSTEM_BAR_HEIGHT, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
    itemManageButtonBar_.hidden = NO;
    itemManageButtonBar_.alpha = 1.0;
    itemManageButtonBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:itemManageButtonBar_];
}


/* ItemManageView를 초기화 한다. */
- (void)resetView
{
    [itemMutableDictionary_ removeAllObjects];
    [messageView_ resetView];
    [closeMessageView_ resetView];
    [webView_ stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
    //[step01View_ resetView];
    [step02View_ resetView];
    [step03View_ resetView];
    [step04View_ resetView];
    [step05View_ resetView];
    
    messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
    messageView_.hidden = YES;
    closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
    closeMessageView_.hidden = YES;
    //step01View_.frame = CGRectMake(step01View_.bounds.origin.x, step01View_.bounds.origin.y, step01View_.bounds.size.width, step01View_.bounds.size.height);
    step02View_.frame = CGRectMake(step02View_.bounds.origin.x, -step02View_.bounds.size.height, step02View_.bounds.size.width, step02View_.bounds.size.height);
    step03View_.frame = CGRectMake(step03View_.bounds.origin.x, -step03View_.bounds.size.height, step03View_.bounds.size.width, step03View_.bounds.size.height);
    step04View_.frame = CGRectMake(step04View_.bounds.origin.x, -step04View_.bounds.size.height, step04View_.bounds.size.width, step04View_.bounds.size.height);
    step05View_.frame = CGRectMake(step05View_.bounds.origin.x, -step05View_.bounds.size.height, step05View_.bounds.size.width, step05View_.bounds.size.height);
    step02View_.hidden = NO;
    step02View_.hidden = YES;
    step03View_.hidden = YES;
    step04View_.hidden = YES;
    step05View_.hidden = YES;
    itemIndex_ = -1;
    itemManageState_ = ITEM_MANAGE_STATE_ADD;
    itemManageSequence_ = ITEM_MANAGE_SEQUENCE_STEP_01_01;
    itemManageStringEncodingType_ = ITEM_MANAGE_STRING_ENCODING_TYPE_UTF8;
    shadowScreen_.hidden = YES;
    itemManageButtonBar_.closeButton_.selected = NO;
    [self removeMessageTimer];
    [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_01_01];
}


/* 각 설정 뷰에 아이템 값을 설정한다 .*/
- (void)setItemValue
{
    
    NSString *hostURL = [itemMutableDictionary_ valueForKey:@"HostURL"];
    if (![hostURL isEqualToString:@""] && hostURL != nil)
        step02View_.urlLabel_.text = hostURL;
    
    
    NSString *title = [itemMutableDictionary_ valueForKey:@"Title"];
    if (![title isEqualToString:@""] && title != nil)
        step02View_.itemManageTextField_.text = title;

    [self requestWithString:hostURL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *windows = [application windows];
    UIWindow *window = [windows objectAtIndex:0];
    rootViewController_ = (RootViewController *)window.rootViewController;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initSubViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* URL로 웹 컨텐츠를 요청한다. */
-(void)requestWithURL:(NSURL *)url
{
    /* 네트워크에 연결이 가능한지를 검사한다. */
    if ([rootViewController_ isReachableWithHost:nil])
    {
        [webView_ loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"네트워크에 연결할 수 없습니다!" message:@"3G 또는 Wifi 상태를 확인해 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}


/* String으로 웹 컨텐츠를 요청한다. */
-(void)requestWithString:(NSString *)string
{
    NSString *urlString;
    
    if([[string lowercaseString] rangeOfString:@"http://"].location == NSNotFound && [[string lowercaseString] rangeOfString:@"https://"].location == NSNotFound)
        urlString = [[NSString alloc] initWithFormat:@"http://%@", string];
    else
        urlString = string;
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
   
    [self requestWithURL:url];
}


/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence
{
    itemManageSequence_ = sequence;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        {
            webView_.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                if (messageView_.hidden == NO)
                    messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
                if (closeMessageView_.hidden == NO)
                    closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
            } completion:^(BOOL finished) {
                messageView_.hidden = YES;
                step02View_.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    step02View_.frame = CGRectMake(step02View_.frame.origin.x, 0, step02View_.bounds.size.width, step02View_.bounds.size.height);
                } completion:^(BOOL finished) {
                    if (![step02View_.itemManageTextField_.text isEqualToString:@""] && step02View_.itemManageTextField_.text != nil)
                    {
                        [messageView_ setState:MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM];
                        [self showMessageView:NO];
                    }
                }];
            }];
        }
            break;

        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (messageView_.hidden == NO)
                    messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
                if (closeMessageView_.hidden == NO)
                    closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
            } completion:^(BOOL finished) {
                messageView_.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    if (step02View_.hidden == NO)
                        step02View_.frame = CGRectMake(step02View_.bounds.origin.x, step02View_.bounds.origin.y - (step02View_.bounds.size.height - URL_BAR_HEIGHT), step02View_.bounds.size.width, step02View_.bounds.size.height);
                } completion:^(BOOL finished) {
                    step03View_.hidden = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        step03View_.backgroundColor = [UIColor whiteColor];
                        step03View_.helpImageView_.hidden = NO;
                        step03View_.helpLabel_.hidden = YES;
                        step03View_.frame = CGRectMake(step03View_.frame.origin.x, step03View_.bounds.origin.y, step03View_.bounds.size.width, step03View_.bounds.size.height);
                    } completion:^(BOOL finished) {
                        step02View_.hidden = NO;
                        [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST];
                        [self showMessageView:NO];
                    }];
                }];
            }];
        }
            break;
            
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (messageView_.hidden == NO)
                    messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
                if (closeMessageView_.hidden == NO)
                    closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
            } completion:^(BOOL finished) {
                messageView_.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    step03View_.backgroundColor = [[UIColor alloc] initWithRed:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0];
                    step03View_.helpImageView_.hidden = YES;
                    step03View_.helpLabel_.hidden = NO;
                    step03View_.frame = CGRectMake(step03View_.bounds.origin.x, step03View_.bounds.origin.y - (step03View_.bounds.size.height - URL_BAR_HEIGHT), step03View_.bounds.size.width, step03View_.bounds.size.height);
                } completion:^(BOOL finished) {
                    shadowScreen_.hidden = YES;
                }];
            }];
        }
            break;
            
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (messageView_.hidden == NO)
                    messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
                if (closeMessageView_.hidden == NO)
                    closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
            } completion:^(BOOL finished) {
                messageView_.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    if (step02View_.hidden == NO)
                        step02View_.frame = CGRectMake(step02View_.bounds.origin.x, step02View_.bounds.origin.y - (step02View_.bounds.size.height - URL_BAR_HEIGHT), step02View_.bounds.size.width, step02View_.bounds.size.height);
                } completion:^(BOOL finished) {
                    step03View_.hidden = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        step03View_.backgroundColor = [UIColor whiteColor];
                        step03View_.helpImageView_.hidden = NO;
                        step03View_.helpLabel_.hidden = YES;
                        step03View_.frame = CGRectMake(step03View_.frame.origin.x, step03View_.bounds.origin.y, step03View_.bounds.size.width, step03View_.bounds.size.height);
                    } completion:^(BOOL finished) {
                        step02View_.hidden = NO;
                        [self showMessageView:NO];
                    }];
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}


/* 아이템 관리 뷰를 종료한다. */
-(void)closeItemManageView
{
    if (itemManageButtonBar_.closeButton_.selected)
    {
        switch (itemManageSequence_)
        {
            case ITEM_MANAGE_SEQUENCE_STEP_02_01:
            case ITEM_MANAGE_SEQUENCE_STEP_02_02:
                [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM];
                break;
            case ITEM_MANAGE_SEQUENCE_STEP_03_01:
                [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST];
                break;
            case ITEM_MANAGE_SEQUENCE_STEP_03_02:
            case ITEM_MANAGE_SEQUENCE_STEP_03_03:
                [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID];
                break;
            default:
                break;
        }
        [self showCloseMessageViewAfterHideMessageView:NO];
    }
    else
    {
        switch (itemManageSequence_)
        {
            case ITEM_MANAGE_SEQUENCE_STEP_02_01:
            {
                [step02View_.itemManageTextField_ resignFirstResponder];
                [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
            }
            case ITEM_MANAGE_SEQUENCE_STEP_02_02:
            {
                [step02View_.itemManageTextField_ resignFirstResponder];
                [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_02];
            }
                break;
            case ITEM_MANAGE_SEQUENCE_STEP_03_01:
            {
                [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_01];
            }
                break;
            case ITEM_MANAGE_SEQUENCE_STEP_03_02:
            {
                [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_02];
            }
                break;
            case ITEM_MANAGE_SEQUENCE_STEP_03_03:
            {
                [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_03];
            }
                break;
            default:
                break;
        }
        //[self hideMessageView:YES];
        //[self hideCloseMessageView:YES];
    }
}


/* 메세지뷰의 왼쪽 버튼이 터치되다. */
- (void)messageViewLeftButtonTouched:(id)sender
{
    switch (messageView_.messageViewState_)
    {
        // URL 이름 입력 대화상자의 왼쪽 버튼이 선택되다.
        case MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM_LEFT];
            [step02View_.itemManageTextField_ becomeFirstResponder];
        }
            break;
            
        // 추가 검색URL 확인  대화상자의 왼쪽 버튼이 선택되다.
        case MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST_LEFT];
            // 완료한다.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"즐겨찾기가 등록되었습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        }
            break;
            
        // 재 검색 한다.
        case MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID_LEFT];
            // 검색어 입력단계로 이동한다.
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_02];
        }
        default:
            break;
    }
}


/* 메세지뷰의 오른쪽 버튼이 터치되다. */
- (void)messageViewRightButtonTouched:(id)sender
{
    switch (messageView_.messageViewState_)
    {
            
        // 등록을 완료하고, 추가 키워드 검색URL을 입력하는 단계로 진행함
        case MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM_RIGHT];
            // 즐겨찾기를 리스트에 저장한다.
            NSString *titleString = step02View_.itemManageTextField_.text;
           
            if (itemManageState_ == ITEM_MANAGE_STATE_ADD) // 새로 추가하는 경우
            {
                
                [itemMutableDictionary_ setObject:titleString forKey:@"Title"];
                [rootViewController_.listManager_ addList:itemMutableDictionary_];
                itemIndex_ = rootViewController_.listManager_.list_.count - 1;
            }
            else    // 수정인 경우
            {
                [itemMutableDictionary_ setObject:titleString forKey:@"Title"];
                [rootViewController_.listManager_ updateList:itemMutableDictionary_ atIndex:itemIndex_];
            }

            [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];

            // 검색어 입력단계로 이동한다.
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_01];
        }
            break;
            
        // 검색어 키워드 입력 단계로 진행함
        case MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST_RIGHT];
            
            // 신규 등록일 경우, HostURL로 링크를 이동한다. 
            // 편집일 경우, 저장되어있는 검색 링크로 이동한다.
            // 이동할 URL은 {query} 를 QUERY_STRING으로 변경해서 이동한다.
            
            NSURL *url = nil;
            if (itemManageState_ == ITEM_MANAGE_STATE_ADD)
            {
                NSString *searchURL = [itemMutableDictionary_ objectForKey:@"HostURL"];
                url = [[NSURL alloc] initWithString:searchURL];
            }
            else if (itemManageState_ == ITEM_MANAGE_STATE_EDIT)
            {
                /*
                NSString *encodedSearchString = [itemMutableDictionary_ objectForKey:@"SearchURL"];
                if (![encodedSearchString isEqualToString:@""] && encodedSearchString != nil)
                {
                    encodedSearchString = [encodedSearchString stringByReplacingOccurrencesOfString:@"{query}" withString:@""];
                    NSString *encodeUTF8 = [itemMutableDictionary_ objectForKey:@"EncodeUTF8"];
                    if ([encodeUTF8 isEqualToString:@"YES"])    // 검색어를 UTF8 인코딩
                    {
                        encodedSearchString = [encodedSearchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                    else // 지역 인코딩 현재는 EUC-KR
                    {
                        encodedSearchString = [encodedSearchString stringByAddingPercentEscapesUsingEncoding:(0x80000000 + kCFStringEncodingEUC_KR)];
                    }
                    url = [[NSURL alloc] initWithString:encodedSearchString];
                    
                }
                else
                {
                    NSString *searchURL = [itemMutableDictionary_ objectForKey:@"HostURL"];
                    url = [[NSURL alloc] initWithString:searchURL];
                }
                */
                NSString *searchURL = [itemMutableDictionary_ objectForKey:@"HostURL"];
                url = [[NSURL alloc] initWithString:searchURL];
            }
            [self requestWithURL:url];
            
            // 검색어 입력단계로 이동한다.
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_02];
        }
            break;
            
        // 검색어 링크를 사용할 수 있어 다음단계로 넘어간다.  
        case MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID:
        {
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID_RIGHT];
            NSString *searchURLString = searchURLString_;
            [itemMutableDictionary_ setObject:searchURLString forKey:@"SearchURL"];
            
            // UTF-8 인코딩을 설정한다.
            if (itemManageStringEncodingType_ == ITEM_MANAGE_STRING_ENCODING_TYPE_UTF8)
            {
                [rootViewController_.itemManageViewController_.itemMutableDictionary_ setObject:@"YES" forKey:@"EncodeUTF8"];
            }
            else
            {
                [rootViewController_.itemManageViewController_.itemMutableDictionary_ setObject:@"NO" forKey:@"EncodeUTF8"];
            }
            
            // Space Encoding을 설정한다.
            [rootViewController_.itemManageViewController_.itemMutableDictionary_ setObject:@"NO" forKey:@"EncodeSpace"];
            [rootViewController_.listManager_ updateList:itemMutableDictionary_ atIndex:itemIndex_];
            [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
           
            // 완료한다.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"즐겨찾기 및 검색 URL이\n등록되었습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        }
            break;
        default:
            break;
    }
}


/* 클로즈 메세지뷰의 왼쪽 버튼이 터치되다. */
- (void)closeMessageViewLeftButtonTouched:(id)sender
{
    switch (closeMessageView_.closeMessageViewState_)
    {
        case CLOSE_MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM:
        {
            [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM_LEFT];
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
        }
            break;
        case CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST:
        {
            [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST];
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_01];
        }
            break;
        case CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID:
        {
            [closeMessageView_ setState:CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID_LEFT];
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID];
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_02];
        }
            break;
        default:
            break;
    }
    itemManageButtonBar_.closeButton_.selected = NO;
    
}


/* 클로즈 메세지뷰의 오른쪽 버튼이 터치되다. */
- (void)closeMessageViewRightButtonTouched:(id)sender
{
    [rootViewController_ hideItemManageView];
}


/* 메세지뷰를 보인다. */
-(void) showMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    
    if (messageView_.hidden == NO)
        return;
    
    shadowScreen_.hidden = messageViewHidden;
    messageView_.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        messageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}


/* 메세지뷰를 숨긴다. */
-(void) hideMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    
    if (messageView_.hidden == YES)
        return;
    
    [UIView animateWithDuration:0.3 animations:^{
        messageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        shadowScreen_.hidden = messageViewHidden;
        messageView_.hidden = YES;
    }];
}


/* 클로즈 메세지뷰를 보인다. */
-(void) showCloseMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    
    if (closeMessageView_.hidden == NO)
        return;
    
    shadowScreen_.hidden = messageViewHidden;
    closeMessageView_.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height, self.view.bounds.size.width, CLOSE_MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}


/* 클로즈 메세지뷰를 숨긴다. */
-(void) hideCloseMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    
    if (closeMessageView_.hidden == YES)
        return;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height - CLOSE_MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, CLOSE_MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        shadowScreen_.hidden = messageViewHidden;
        closeMessageView_.hidden = YES;
    }];
}


/* 클로즈 메세지뷰를 숨기 후, 메세지뷰를 보여준다.*/
-(void) showMessageViewAfterHideCloseMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    shadowScreen_.hidden = messageViewHidden;
    [UIView animateWithDuration:0.3 animations:^{
        closeMessageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height - CLOSE_MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, CLOSE_MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        closeMessageView_.hidden = YES;
        [self showMessageView:NO];
    }];
}


/* 메세지뷰를 숨기 후, 클로즈 메세지뷰 보여준다.*/
-(void) showCloseMessageViewAfterHideMessageView:(BOOL)messageViewHidden
{
    UIView *currentStepView = nil;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            currentStepView = step02View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        case ITEM_MANAGE_SEQUENCE_STEP_03_03:
        {
            currentStepView = step03View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_04_01:
        {
            currentStepView = step04View_;
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_05_01:
        {
            currentStepView = step05View_;
        }
            break;
        default:
            break;
    }
    
    shadowScreen_.hidden = messageViewHidden;
    [UIView animateWithDuration:0.3 animations:^{
        messageView_.frame = CGRectMake(self.view.bounds.origin.x, currentStepView.frame.origin.y + currentStepView.bounds.size.height - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        closeMessageView_.hidden = YES;
        [self showCloseMessageView:NO];
    }];
}


/* Shadow Screen 을 탭하다 */
-(void)shadowSreenTapped:(id)sender
{
    switch (itemManageSequence_)
    {
        
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
        {
            [step02View_.itemManageTextField_ resignFirstResponder];
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_02_02:
        {
            [step02View_.itemManageTextField_ resignFirstResponder];
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_02];
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_01:
        {
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_01];
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        {
            [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_02];
        }
            break;
        default:
            break;

    }
    
    if (itemManageButtonBar_.closeButton_.selected)
        itemManageButtonBar_.closeButton_.selected = NO;
    
    //[self hideMessageView:YES];
    //[self hideCloseMessageView:YES];
}

-(void)webViewTapped:(id)sender
{
    // NSLog(@"WebViewTab......");
}


/* LimeFiner Query URL 유효성 체크 */
- (BOOL)limeFinderQueryURLValidCheck:(NSString *)urlString
{
    // 문자열이 공백 혹은 nil 이 아닐때
    if (![urlString isEqualToString:@""] && urlString != nil)
    {
        // QUERY_STRING 문자열이 있는지 확인한다.
        NSRange range = [urlString rangeOfString:QUERY_STRING options:NSCaseInsensitiveSearch];
        if(range.location == NSNotFound)
        {
            // URL 인코딩된 문자열이 발견되지 않았을경우  URL ENCODING 문자열로 재 확인한다.
            NSString *urlEncodingString = [QUERY_STRING stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            range = [urlString rangeOfString:urlEncodingString options:NSCaseInsensitiveSearch];
            if(range.location == NSNotFound)
            {
                // URL ENCODING 문자열도 발견되지 않았을 경우 ECU_KR 문자열로 재 확인한다.
                NSString *eucKREncodingString = [QUERY_STRING stringByAddingPercentEscapesUsingEncoding:(0x80000000 + kCFStringEncodingEUC_KR)];
                range = [urlString rangeOfString:eucKREncodingString options:NSCaseInsensitiveSearch];
                if(range.location == NSNotFound)
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
            else
            {
                return YES;
            }
        }
        else
        {
            return YES;
        }
    }
    return NO;
}


/* URL 을 LimeFiner Query 문자열로 반환한다. */
- (NSString *)getLimeFinderQueryURLStringWithURLString:(NSString *)string
{
    NSString *urlString = [[NSString alloc] initWithString:string ];
    
    if ([urlString rangeOfString:@"http://"].location == NSNotFound && [urlString rangeOfString:@"https://"].location == NSNotFound)
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    
    // {query} 문자열이 있는지 확인한다.
    NSRange range = [urlString rangeOfString:QUERY_STRING options:NSCaseInsensitiveSearch];
    if(range.location == NSNotFound)
    {
        // {query} 문자열이 발견되지 않았을 경우  URL ENCODING 문자열로 재 확인한다.
        NSString *urlEncodingString = [QUERY_STRING stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        range = [urlString rangeOfString:urlEncodingString options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound)
        {
            // URL ENCODING 문자열도 발견되지 않았을 경우 ECU_KR 문자열로 재 확인한다.
            NSString *eucKREncodingString = [QUERY_STRING stringByAddingPercentEscapesUsingEncoding:(0x80000000 + kCFStringEncodingEUC_KR)];
            range = [urlString rangeOfString:eucKREncodingString options:NSCaseInsensitiveSearch];
            if (range.location == NSNotFound)
            {
                
            }
            else
            {
                // 발견되었을경우 발견된 문자열을 {query}로 바꾼 후 searchURLTextField_의 문자열로 저장한다.
                urlString = [urlString stringByReplacingCharactersInRange:range withString:@"{query}"];
                itemManageStringEncodingType_ = ITEM_MANAGE_STRING_ENCODING_TYPE_LOCALE;
            }
        }
        else
        {
            // 발견되었을경우 발견된 문자열을 {query}로 바꾼 후 searchURLTextField_의 문자열로 저장한다.
            urlString = [urlString stringByReplacingCharactersInRange:range withString:@"{query}"];
        }
    }
    else 
    {
        // 발견되었을경우 발견된 문자열을 {query}로 바꾼 후 문자열을 반환한다.
        range = [urlString rangeOfString:QUERY_STRING options:NSCaseInsensitiveSearch];
        urlString = [urlString stringByReplacingCharactersInRange:range withString:@"{query}"];
    }
    return urlString;
}

- (void)keyboardWillAnimate:(NSNotification *)notification
{
    [self removeMessageTimer];
}

/* WebView가 Data 수신할때 마다 호출된다. */
- (void)loadedFromWebViewResourceData
{
    //[self resetMessageTimer];
    switch (itemManageSequence_)
    {
            // Step 03 //
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        {
            // URL을 검사하여, 검색URL로 등록이 가능한지를 판단해서, 메세지를 보낸다.
            if ([self limeFinderQueryURLValidCheck:[webView_ stringByEvaluatingJavaScriptFromString:@"location.href"]])
            {
                if (![prevSearchURL_ isEqualToString:[webView_ stringByEvaluatingJavaScriptFromString:@"location.href"]])
                {
                    [messageView_ setState:MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID];
                    [self setSequence:ITEM_MANAGE_SEQUENCE_STEP_03_03];
                    // 페이지가 완료되면 쉐도우 뷰를 보인다.
                    searchURLString_ = [self getLimeFinderQueryURLStringWithURLString:[webView_ stringByEvaluatingJavaScriptFromString:@"location.href"]];
                    // shadowScreen_.hidden = NO;
                }
                prevSearchURL_ = [webView_ stringByEvaluatingJavaScriptFromString:@"location.href"];
            }
            else
            {

            }
        }
            break;
            
        default:
            break;
    }
}

/* URL 사용가능 확인창의 지연을 준다. 로딩을 다시 하면 타이머가 초기화 된다. */
-(void)messageTimerCheck:(NSTimer *)theTimer
{
    messageTimerCounter_ = messageTimerCounter_ + 0.05;
    if (messageTimerCounter_ >= 3.0)
    {
        [self showMessageView:NO];
        [self removeMessageTimer];
    }
}


/* 메세지 타이머의 시간을 초기화 한다. */
-(void)resetMessageTimer
{
    messageTimerCounter_ = 0;
}


/* 타이머를 종료 한다. */
- (void)removeMessageTimer
{
    messageTimerCounter_ = 0;
    [messageTimer_ invalidate];
    messageTimer_ = nil;
}


#pragma -
#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 네트워크 인디케이터를 켠다.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    prevSearchURL_ = @"";
    // WebURLBar 뷰의 텍스트필트 객체에 URL을 갱신한다.
    // step03View_.itemManageTextField_.text = urlString;
    
    [self removeMessageTimer];
    
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_03_02:
        {
            shadowScreen_.hidden = YES;
            messageView_.hidden = YES;
            messageView_.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - MESSAGE_VIEW_HEIGHT, self.view.bounds.size.width, MESSAGE_VIEW_HEIGHT);
            webView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    return true;
}


/* WebView의 로드가 완료되다 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 웹 뷰 초기화
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


/* 페이지 로드가 실패되다. */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    switch (itemManageSequence_)
    {
            // Step 1 //
        case ITEM_MANAGE_SEQUENCE_STEP_01_02:
        {
            messageView_.hidden = NO;
            [self removeMessageTimer];
            [messageView_ setState:MESSAGE_VIEW_STATE_STEP_01_URL_INVALID];
            messageTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(messageTimerCheck:) userInfo:nil repeats:YES];
        }
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma -
#pragma mark - UIScrollViewDelegate Method

/* 웹뷰가 스크롤되었다. */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resetMessageTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   [self resetMessageTimer];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetMessageTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resetMessageTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self resetMessageTimer];
}

#pragma -
#pragma mark - UIAlertViewDelegate Protocol

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [rootViewController_ hideItemManageView];
}


@end
