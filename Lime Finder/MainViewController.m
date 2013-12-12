//
//  MainViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "MainViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize listTableViewController_;
@synthesize searchView_;
@synthesize settingButtonBar_;
@synthesize editButtonBar_;
@synthesize systemBar_;
@synthesize rootViewController_;
@synthesize isTransformed_;
@synthesize shadowScreen_;
@synthesize infoView_;
@synthesize infoButtonBar_;
@synthesize suggestListTableViewController_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


/* Subview 들을 초기화 한다. */
- (void)initSubObject
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // listTableView 추가 //
    CGRect listTableViewRect_ = CGRectMake(self.view.bounds.origin.x, SEARCH_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCH_VIEW_HEIGHT - SYSTEM_BAR_HEIGHT);
    
    // TargetTableView 추가
    listTableViewController_ = [[ListTableViewController alloc] init];
    [self addChildViewController:listTableViewController_];
    listTableViewController_.view.frame = listTableViewRect_;
    [self.view addSubview:listTableViewController_.view];
    
    // Shadow Screen //
    shadowScreen_ = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowScreen_.backgroundColor = [UIColor blackColor];
    shadowScreen_.hidden = YES;
    shadowScreen_.alpha = 0.8;
    UITapGestureRecognizer *shadowScreenTabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowSreenTapped:)];
    [shadowScreen_ addGestureRecognizer:shadowScreenTabGestureRecognizer];
    [self.view addSubview:shadowScreen_];
    
    // 연관검색어 테이블 뷰를 추가한다.
    suggestListTableViewController_ = [[SuggestListTableViewController alloc] init];
    suggestListTableViewController_.tableView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + SEARCH_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCH_VIEW_HEIGHT);
    suggestListTableViewController_.tableView.hidden = YES;
    suggestListTableViewController_.tableView.dataSource = suggestListTableViewController_;
    suggestListTableViewController_.tableView.delegate = suggestListTableViewController_;
    suggestListTableViewController_.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:suggestListTableViewController_.tableView];
    
    // 검색 뷰를 추가 한다. //
    searchView_ = [[SearchView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, SEARCH_VIEW_HEIGHT)];
    [self.view addSubview:searchView_];
   
    // 소개 뷰를 추가한다. //
    infoView_ = [[InfoView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height + 5.0, self.view.bounds.size.width, self.view.bounds.size.height + 5.0 - SYSTEM_BAR_HEIGHT)];
    infoView_.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView_];
    
    // 세팅버튼 바 //
    settingButtonBar_ = [[SettingButtonBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - SYSTEM_BAR_HEIGHT, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
    settingButtonBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:settingButtonBar_];
    
    // 편집 바 //
    editButtonBar_ = [[EditButtonBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - SYSTEM_BAR_HEIGHT, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
    editButtonBar_.hidden = YES;
    editButtonBar_.alpha = 0.0;
    editButtonBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:editButtonBar_];
    
    // 소개 바 //
    infoButtonBar_ = [[InfoButtonBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - SYSTEM_BAR_HEIGHT, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
    infoButtonBar_.hidden = YES;
    infoButtonBar_.alpha = 0.0;
    infoButtonBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:infoButtonBar_];
    
    // 시스템 바 //
    systemBar_ = [[SystemBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - SYSTEM_BAR_HEIGHT, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
    systemBar_.hidden = YES;
    systemBar_.alpha = 0.0;
    systemBar_.backgroundColor = [UIColor colorWithRed:(70.0 / 255.0) green:(198.0 / 255.0) blue:(207.0 / 255.0) alpha:1.0];
    [self.view addSubview:systemBar_];
}


/* 뷰가 로드 됨 */
- (void)viewDidLoad
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *windows = [application windows];
    UIWindow *window = [windows objectAtIndex:0];
    rootViewController_ = (RootViewController *)window.rootViewController;
    isTransformed_ = NO;
    
    self.view.userInteractionEnabled = YES;
    
    [super viewDidLoad];
	
    // SubView들 초기화 
    [self initSubObject];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* 터치가 시작되다 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {

    }
}


/* WebNavigationBar의 list 액션에 맞게 크기가 수정된다. */
- (void)transformViews:(CGRect)rect
{
    if (!isTransformed_)
    {
        [self.view setFrame:rect];
        [searchView_ transformViews];
        //[listTableViewController_.view setFrame:CGRectMake(listTableViewController_.view.frame.origin.x, SEARCH_VIEW_TRANSFORM_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCH_VIEW_HEIGHT - searchView_.bounds.size.height)];
        [listTableViewController_.view setFrame:CGRectMake(listTableViewController_.view.frame.origin.x, SEARCH_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCH_VIEW_HEIGHT - SYSTEM_BAR_HEIGHT)];
        [self hideSystemBar];
        isTransformed_ = YES;
    }
}


/* WebNavigationBar의 list 액션에 의해 수정된 크기를 되돌린다. */
- (void)returnTransformViews
{
    if (isTransformed_)
    {
        isTransformed_ = NO;
        [UIView animateWithDuration:0.2 animations:^{
            // 애니메이션 블록 시작 //
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, rootViewController_.view.bounds.size.width, self.view.frame.size.height)];
            [listTableViewController_.view setFrame:CGRectMake(listTableViewController_.view.frame.origin.x, SEARCH_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - SEARCH_VIEW_HEIGHT - SYSTEM_BAR_HEIGHT)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished)
        {
            // rootViewController_.mainViewController_.searchView_.searchViewLabel_.hidden = NO;
        }];
        
        // 서치뷰의 수정된 크기를 되돌린다. 
        [searchView_ returnTransformViews];
    }
}


/* List 추가모드를 끝낸다. */
/*
- (void)endAddMode:(id)sender
{
    [self.listTableViewController_.listTableView_ reloadData];
}
*/

/* List 수정모드로 들어간다. */
- (void)setEditMode:(id)sender
{
    if (self.listTableViewController_.listTableView_.editing == NO)
    {
        [self.listTableViewController_.listTableView_ setEditing:YES animated:YES];
    }
}


/* List 수정모드를 끝낸다. */
- (void)endEditMode:(id)sender
{
    if (rootViewController_.mainViewController_.listTableViewController_.listTableView_.editing) // 편집중이었을 경우 편집을 종료 하고, 데이터를 리로드 한다.
    {
        [self.listTableViewController_.listTableView_ reloadData];
        [self.listTableViewController_.listTableView_ setEditing:NO animated:YES];
    }
}


/* WebView를 숨긴다. */
- (void)hideWebView
{
    if (isTransformed_)
    {
        WebViewController *webViewController = rootViewController_.webViewController_;
        [self returnTransformViews];
        
        // UIWebViewController 뷰 애니메이션
        [UIView animateWithDuration:0.4 animations:^{
            // 애니메인션 블록 시작 //
            [webViewController.view setFrame:CGRectMake(webViewController.view.bounds.size.width, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished)
         {
             [webViewController.webNavigationBar_ selectListButton:NO];
             [rootViewController_ hideWebView];
             
             // WebViewController View 위치 초기화
             webViewController.view.frame = CGRectMake(self.view.bounds.size.width, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
             webViewController.shadowView_.hidden = YES;
             webViewController.webURLBar_.layer.shadowOpacity = 0.0;             
         }];
    }
}


/* 소개 뷰를 보인다. */
- (void)showInfoView
{
    infoButtonBar_.hidden = NO;
    systemBar_.hidden = YES;
    infoButtonBar_.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        // 애니메이션 블록 시작 //
        [infoView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - 5.0, infoView_.bounds.size.width, infoView_.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
        // 완료 블록 시작 //
        [UIView animateWithDuration:0.1 animations:^{
            // 애니메이션 블록 시작 //
            [infoView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, infoView_.bounds.size.width, infoView_.bounds.size.height)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
            
            // 완료 블록 끝 //
        }];
        // 완료 블록 끝 //
    }];
}


/* 소개 뷰를 숨긴다. */
- (void)hideInfoView
{
    UIButton *button = [systemBar_.subviews objectAtIndex:4];

    if (!button.selected)
        return;
    
    systemBar_.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        // 애니메이션 블록 시작 //
        [infoView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - 5.0, infoView_.bounds.size.width, infoView_.bounds.size.height)];
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished) {
        // 완료 블록 시작 //
        [UIView animateWithDuration:0.3 animations:^{
            // 애니메이션 블록 시작 //
            [infoView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, infoView_.bounds.size.width, infoView_.bounds.size.height)];
            // 애니메이션 블록 끝 //
        } completion:^(BOOL finished) {
            // 완료 블록 시작 //
                infoButtonBar_.alpha = 0.0;
                button.selected = NO;
                infoButtonBar_.hidden = YES;
            // 완료 블록 끝 //
        }];
        // 완료 블록 끝 //
    }];
}


/* 애니메이션 없이 소개 뷰를 숨긴다. */
- (void)hideInfoViewNoAnimation
{
    UIButton *button = [systemBar_.subviews objectAtIndex:4];
    
    if (!button.selected)
        return;
    
    [infoView_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, infoView_.bounds.size.width, infoView_.bounds.size.height)];
    button.selected = NO;
    systemBar_.hidden = NO;
    infoButtonBar_.hidden = YES;
}


/* 시스템 바를 보인다. */
- (void)showSystemBar
{
    [self returnTransformViews];
    [rootViewController_ hideWebView];
    systemBar_.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        // 애니메이션 블록 시작 //
        systemBar_.alpha = 1.0;
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished)
    {
        
    }];
}


/* 시스템 바를 숨긴다. */
- (void)hideSystemBar
{
    // 시스템바 상태를 모두 해제 한다. 
    [systemBar_ resetSystemBar];
    [UIView animateWithDuration:0.2 animations:^{
        // 애니메이션 블록 시작 //
        //[systemBar_ setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.bounds.size.width, SYSTEM_BAR_HEIGHT)];
        systemBar_.alpha = 0.0;
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished)
    {
        systemBar_.hidden = YES;
    }];
}


/* 편집버튼바를 보인다. */
- (void)showEditButtonBar
{
    editButtonBar_.hidden = NO;
    systemBar_.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        editButtonBar_.alpha = 1.0;
    } completion:^(BOOL finished)
     {
         
     }];
}

/* 편집버튼바를 숨긴다. */
- (void)hideEditButtonBar
{
    editButtonBar_.hidden = YES;
    UIButton *button = [systemBar_.subviews objectAtIndex:1];
    button.selected = NO;
    [self endEditMode:self];
    systemBar_.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        // 애니메이션 블록 시작 //
        systemBar_.alpha = 1.0;
        // 애니메이션 블록 끝 //
    } completion:^(BOOL finished)
     {
         
     }];
}


/* Shadow Screen 을 탭하다 */
-(void)shadowSreenTapped:(id)sender
{
    [searchView_.searchField_ resignFirstResponder];
    shadowScreen_.hidden = YES;
}


#pragma mark - UIViewControllerDelegateMethod
- (BOOL)shouldAutorotate
{
    return NO;
}


@end

















