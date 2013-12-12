//
//  ItemManageButtonBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ItemManageButtonBar : UIView
{
    RootViewController  *rootViewController_;
    UIButton            *closeButton_;
}


@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) UIButton              *closeButton_;

- (void)initSubViews;

- (void)closeButtonTouched:(id)sender;
@end
