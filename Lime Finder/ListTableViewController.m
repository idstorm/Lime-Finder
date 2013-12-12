//
//  ListTableViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ListTableViewController.h"
#import "RootViewController.h"
#import "ListCell.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController
@synthesize rootViewController_;
@synthesize listTableView_;
@synthesize searchString_;
@synthesize urlString_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // NSLog(@"> %@\n", nibBundleOrNil);
    }
    return self;
}


/* 초기화 */
- (id)init
{
    self = [super init];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        //listTableView_ = [[ListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        listTableView_ = [[ListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        listTableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
        listTableView_.delegate = self;
        listTableView_.dataSource = self;
        listTableView_.backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        listTableView_.backgroundView.backgroundColor = [UIColor whiteColor];
        self.view = listTableView_;
        urlString_ = @"http://";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 서브뷰를 초기화 한다.
    [self initViews];
}


/* 서브뷰를 초기화 한다 */
- (void)initViews
{
}


/* 검색 문자열 설정 */
- (void)setSearchString:(NSString *)string
{
    searchString_ = string;
    
    if([[string lowercaseString] rangeOfString:@"http://"].location == NSNotFound && [[string lowercaseString] rangeOfString:@"https://"].location == NSNotFound)
    {
        urlString_ = [[NSString alloc] initWithFormat:@"http://%@", string];
    }
    else
    {
        urlString_ = string;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma -
#pragma mark - Table view data source

/* 섹션(그룹) 수 반환 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}




/* 섹션(그룹)에 속한 항목(셀) 수 반환 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ListManager *listManager = rootViewController_.listManager_;
    return listManager.list_.count;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *list = rootViewController_.listManager_.list_;
    if (fromIndexPath.row > toIndexPath.row)
    {
        NSObject *temp = [list objectAtIndex:fromIndexPath.row];
        for (int i = fromIndexPath.row - 1; i >= toIndexPath.row; i --)
        {
            [list setObject:[list objectAtIndex:i] atIndexedSubscript:i + 1];
        }
        [list setObject:temp atIndexedSubscript:toIndexPath.row];
    }
    else
    {
        NSObject *temp = [list objectAtIndex:fromIndexPath.row];
        for (int i = fromIndexPath.row + 1; i <= toIndexPath.row; i ++)
        {
            [list setObject:[list objectAtIndex:i] atIndexedSubscript:i - 1];
        }
        [list setObject:temp atIndexedSubscript:toIndexPath.row];
    }
    [rootViewController_.listManager_ savePropertyListFile];
    [listTableView_ reloadData];
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


/* Cell의 Editing Style을 결정한다. */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


/* 섹션(그룹)에 속한 셀 객체를 반환한다. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    ListManager *listManager = rootViewController_.listManager_;
    NSDictionary *dictionary = [listManager.list_ objectAtIndex:row];
    
    NSString    *simpleTableIdentifier = @"SimpleTableIdentifier";
    ListCell    *listCell = nil;
    
    if (listCell == nil)
    {
        listCell = [[ListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        //[listCell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        [listCell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        listCell.tag = indexPath.row;
        listCell.imageView.tag = indexPath.row;
        listCell.showsReorderControl = YES;
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [listCell setListItem:dictionary];
        [listCell setCellLabelWithString:searchString_];
        
        // 이미지 뷰의 터치 제스쳐를 설정한다. //
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellImageViewTouched:)];
        gestureRecognizer.enabled = YES;
        gestureRecognizer.numberOfTapsRequired = 1;
        [listCell.imageView addGestureRecognizer:gestureRecognizer];
    }

    return listCell;
}


/* 섹션(그룹) 헤더 높이 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}


/* Cell 높이 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LIST_TABLE_VIEW_CELL_HEIGHT;
}


/* 터치가 시작되었다 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [rootViewController_.listManager_.list_ removeObjectAtIndex:indexPath.row];
    [rootViewController_.listManager_ savePropertyListFile];
    [listTableView_ beginUpdates];
    [listTableView_ deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [listTableView_ endUpdates];
    
}


#pragma mark - Table view delegate

/* 셀이 선택되었다. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [rootViewController_.mainViewController_.searchView_.searchField_ resignFirstResponder];
    ListManager *listManager = rootViewController_.listManager_;
    NSInteger row = [indexPath row];
    NSDictionary *dictionary = [listManager.list_ objectAtIndex:row];
    NSString *hostURL = [dictionary valueForKey:@"HostURL"];
    NSString *searchURL = [dictionary valueForKey:@"SearchURL"];
    NSString *encodeUTF8 = [dictionary valueForKey:@"EncodeUTF8"];
    NSString *encodeSpace = [dictionary valueForKey:@"EncodeSpace"];
    NSString *targetString = @"{query}";
    NSString *encodedSearchString = searchString_;
    
    // 검색어 인코딩 옵션이 있을경우, 검색어를 인코딩한다. //
    if ([encodeSpace isEqualToString:@"YES"]) // 검색어의 공백을 + 로 인코딩
    {
        encodedSearchString = [encodedSearchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    
    if ([encodeUTF8 isEqualToString:@"YES"])    // 검색어를 UTF8 인코딩
    {
        encodedSearchString = [encodedSearchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else // 지역 인코딩, 현재는 EUC-KR
    {
        encodedSearchString = [encodedSearchString stringByAddingPercentEscapesUsingEncoding:(0x80000000 + kCFStringEncodingEUC_KR)];
    }
    
    
    if ([searchString_ isEqualToString:@""] || searchString_ == nil) // 검색어가 없을경우 호스트주소 로딩
    {
        [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:hostURL]];
    }
    else    // 검색어가 있을경우 - 검색URL로 로딩
    {
        if([searchURL isEqualToString:@""] || searchURL == nil)
        {
            [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:hostURL]];
        }
        else // 검색 URL에 검색어 적용
        {
            searchURL = [searchURL stringByReplacingOccurrencesOfString:targetString withString:encodedSearchString];
            [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:searchURL]];
        }
    }

    // 웹뷰를 보여준다.
    [rootViewController_ showWebView];
    
    rootViewController_.webViewController_.webNavigationBar_.listButton_.selected = NO;
}


/* 엑세서리 버튼이 탭 되었다. */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (listTableView_.editing)
    {
        NSDictionary *dictionary = [rootViewController_.listManager_.list_ objectAtIndex:indexPath.row];
        rootViewController_.itemManageViewController_.itemManageState_ = ITEM_MANAGE_STATE_EDIT;
        rootViewController_.itemManageViewController_.itemIndex_ = indexPath.row;
        [rootViewController_.itemManageViewController_.itemMutableDictionary_ setDictionary:dictionary];
        [rootViewController_ showItemManageView];
    }
    */
}


/* ImageView가 터치 되었다 */
// Cell의 파비콘 이미지를 클릭하면 HOST URL로 웹 페이지를 로드 한다. //
- (void)cellImageViewTouched:(UITapGestureRecognizer *)sender
{
    ListManager *listManager = rootViewController_.listManager_;
    NSInteger row = sender.view.tag;
    NSDictionary *dictionary = [listManager.list_ objectAtIndex:row];
    NSString *hostURL = [dictionary valueForKey:@"HostURL"];
    [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:hostURL]];
    [rootViewController_ showWebView];
    [rootViewController_.webViewController_.webNavigationBar_ selectListButton:NO];
 }

@end
