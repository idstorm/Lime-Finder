//
//  ListManager.h
//  XSearch
//
//  Created by idstorm on 13. 4. 18..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_LIST_FILE_NAME @"DefaultItemList.plist"
#define LIST_FILE_NAME         @"ItemList.plist"


@interface ListManager : NSObject
{
    NSMutableArray  *list_;
}

@property (nonatomic, retain) NSMutableArray *list_;


/* 객체를 초기화 한다. */
- (id)init;

/* 리스트를 추가한다. */
- (void)addList:(NSDictionary *)dictionary;

/* 기본 즐겨찾기 리스트로 다시 세팅한다. */
- (void)resetDefaultArray;

/* 리스트를 수정한다. */
- (void)updateList:(NSDictionary *)dictionary atIndex:(NSInteger)index;

/* 프로퍼티 리스트를 저장한다. */
- (void)savePropertyListFile;

/* Array를 파라미터로 프로퍼티 리스트를 저장한다. */
- (void)savePropertyListFileWithArray:(NSArray *)array;

/* 기본 리스트를 생성한다. */
- (NSMutableArray *)makeDefaultList;

@end
