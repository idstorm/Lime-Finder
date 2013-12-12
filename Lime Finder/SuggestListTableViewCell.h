//
//  SuggestListTableViewCell.h
//  Lime Finder
//
//  Created by idstorm on 13. 6. 7..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMLabel.h"

#define SUGGEST_LIST_TABLE_VIEW_CELL_HEIGHT                     40.0
#define SUGGEST_LIST_TABLE_VIEW_CELL_LABEL_SIDE_MARGINE         20.0
#define SUGGEST_LIST_TABLE_VIEW_CELL_LABEL_HEIGHT               30.0
#define SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_WIDTH           49.0
#define SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_HEIGHT          39.0
#define SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_SIDE_MARGINE    10.0

@class RootViewController;

@interface SuggestListTableViewCell : UITableViewCell
{
    RootViewController  *rootViewController_;
    LMLabel             *label_;
    UIButton            *suggestAddButton_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) LMLabel               *label_;
@property (nonatomic, retain) UIButton              *suggestAddButton_;



- (void)suggestAddButtonTouched:(id)sender;

@end
