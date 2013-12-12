//
//  MoreView.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

#define MORE_VIEW_CELL_WIDTH    63.0
#define MORE_VIEW_CELL_HEIGHT   71.0
#define MORE_VIEW_CELL_COLS     5
#define MORE_VIEW_LINE_WIDTH    1.0.0

@class RootViewController;

@interface MoreView : UIView <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    RootViewController *rootViewController_;
    NSArray *cellListArray_;
}

@property (nonatomic, retain) NSArray   *cellListArray_;
@property (nonatomic, retain) RootViewController *rootViewController_;

/* MoreViewCell 들을 초기화 한다. */
- (void)initMoreViewCellList;

- (void)actionSafari:(id)sender;
- (void)actionEmail:(id)sender;
- (void)actionFacebook:(id)sender;
- (void)actionTwitter:(id)sender;
- (void)actionKaKaoTalk:(id)sender;
- (void)actionMyPeople:(id)sender;
- (void)actionMessage:(id)sender;
- (void)actionKaKaoStory:(id)sender;

- (BOOL)canOpenSafari;
- (BOOL)canOpenEmail;
- (BOOL)canOpenFacebook;
- (BOOL)canOpenTwitter;
- (BOOL)canOpenKaKaoTalk;
- (BOOL)canOpenMyPeople;
- (BOOL)canOpenMessage;
- (BOOL)canOpenKaKaoStory;

@end
