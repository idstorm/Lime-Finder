//
//  ListCell.h
//  Lime Finder
//
//  Created by idstorm on 13. 4. 25..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ListCell : UITableViewCell
{
    RootViewController *rootViewController_;
    NSMutableDictionary *listItemMutableDictionary_;
    CGSize          faviconSize_;
    UIImage         *faviconImage_;
    UIImage         *faviconDefaultImage_;
    UIImageView     *faviconImageView_;
    NSMutableData   *receivedImageData_;
    NSString        *faviconImagePath_;
}

@property (nonatomic, retain) RootViewController    *rootViewController_;
@property (nonatomic, retain) NSMutableDictionary   *listItemMutableDictionary_;
@property (nonatomic)         CGSize        faviconSize_;
@property (nonatomic, retain) UIImage       *faviconImage_;
@property (nonatomic, retain) UIImage       *faviconDefaultImage_;
@property (nonatomic, retain) UIImageView   *faviconImageView_;
@property (nonatomic, retain) NSMutableData *receivedImageData_;
@property (nonatomic, retain) NSString      *faviconImagePath_;

/* 서브 뷰를 초기화 한다. */
- (void)initViews;

/* 즐겨찾기아이템 항목을 설정한다. */
- (void)setListItem:(NSDictionary *)dictionary;

/* 검색어가 입력되었다. */
- (void)setCellLabelWithString:(NSString *)string;

/* 파비콘을 추가한다. */
- (void)setFaviconImage:(UIImage *)faviconImage;

/* ImageView가 터치 되었다 */
- (void)imageViewTouched:(UITapGestureRecognizer *)sender;

/* editButton이 터치 되다. */
- (void)editButtonTouched:(id)sender;

/* 주어진 URL문자열로 NSURL을 반환한다. */
- (NSURL *)getFaviconURLWithURLString:(NSString *)string;

@end
