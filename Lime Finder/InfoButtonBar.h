//
//  InfoButtonBar.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface InfoButtonBar : UIView
{
    RootViewController  *rootViewController_;
    UIButton            *infoButton_;
}


@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) UIButton              *infoButton_;

- (void)initSubViews;

- (void)infoButtonTouched:(id)sender;
@end
