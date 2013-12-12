//
//  ListManager.m
//  XSearch
//
//  Created by idstorm on 13. 4. 18..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ListManager.h"

@implementation ListManager
@synthesize list_;

/* 객체를 초기화 한다. */
- (id)init
{
    self = [super init];
    if (self)
    {
        // 검색리스트 프로퍼티리스트 파일이 없을 경우, 프로퍼티 리스트를 생성한다. 
        NSString *filePath = [self dataFilePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            list_ = [self makeDefaultList];
        }
        else
        {
            list_ = [NSMutableArray arrayWithContentsOfFile:filePath];
        }
    }
    return self;
}

/* 저장할 파일 패스를 생성한다. */
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:LIST_FILE_NAME];
}


/* 기본 리스트를 생성한다. */
- (NSMutableArray *)makeDefaultList
{
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultItemList" ofType:@"plist"]];
    [self savePropertyListFileWithArray:array];
    return array;
}


/* 기본 즐겨찾기 리스트로 다시 세팅한다. */
- (void)resetDefaultArray
{
    NSError* theError = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"favicon"];
    
    if ([[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&theError])
    {
        [list_ removeAllObjects];
        list_ = [self makeDefaultList];
    }
    else
    {
        // NSLog(@"파비콘 삭제 실패 !");
    }
}


/* 리스트를 추가한다. */
- (void)addList:(NSDictionary *)dictionary
{
    NSDictionary *dictionaryNew = [[NSDictionary alloc] initWithDictionary:dictionary];
    [list_ addObject:dictionaryNew];
    [self savePropertyListFile];
}


/* 리스트를 수정한다. */
- (void)updateList:(NSDictionary *)dictionary atIndex:(NSInteger)index
{
    NSDictionary *dictionaryNew = [[NSDictionary alloc] initWithDictionary:dictionary];
    [list_ replaceObjectAtIndex:index withObject:dictionaryNew];
    [self savePropertyListFile];
}


/* 프로퍼티 리스트를 저장한다. */
- (void)savePropertyListFile
{
    [self savePropertyListFileWithArray:list_];
}


/* Array를 파라미터로 프로퍼티 리스트를 저장한다. */
- (void)savePropertyListFileWithArray:(NSArray *)array
{
    [array writeToFile:[self dataFilePath] atomically:YES];
}




@end
