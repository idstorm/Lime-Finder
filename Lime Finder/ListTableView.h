//
//  ListTableView.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 24..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ListTableView : UITableView
{
    RootViewController  *rootViewController_;
}

@property (nonatomic, retain) RootViewController *rootViewController_;

@end
