//
//  ListTableViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 22..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableView.h"

#define LIST_TABLE_VIEW_CELL_HEIGHT 45.0

@class RootViewController;

@interface ListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    RootViewController *rootViewController_;
    ListTableView *listTableView_;
    NSString *searchString_;
    NSString *urlString_;
}

@property (nonatomic, retain) RootViewController  *rootViewController_;
@property (nonatomic, retain) ListTableView *listTableView_;
@property (nonatomic, retain) NSString  *searchString_;
@property (nonatomic, retain) NSString  *urlString_;


/* 서브뷰를 초기화 한다 */
- (void)initViews;

/* 검색 문자열 설정 */
- (void)setSearchString:(NSString *)string;

/* ImageView가 터치 되었다 */
- (void)cellImageViewTouched:(UITapGestureRecognizer *)sender;



@end
