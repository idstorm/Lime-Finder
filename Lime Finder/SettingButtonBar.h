//
//  SettingButtonBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 23..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SettingButtonBar : UIView
{
    RootViewController  *rootViewController_;
    UIButton           *settingButton_; 
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) UIButton              *settingButton_;


- (void)initSubViews;

- (void)settingButtonTouched:(id)sender;

@end
