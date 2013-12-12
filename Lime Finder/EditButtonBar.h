//
//  EditButtonBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 26..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface EditButtonBar : UIView
{
    RootViewController  *rootViewController_;
    UIButton            *editButton_;
}


@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) UIButton              *editButton_;

- (void)initSubViews;

- (void)editButtonTouched:(id)sender;

@end
