//
//  SuggestListTableViewController.h
//  Lime Finder
//
//  Created by idstorm on 13. 6. 6..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SuggestListTableViewController : UITableViewController
{
    RootViewController  *rootViewController_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;

@end
