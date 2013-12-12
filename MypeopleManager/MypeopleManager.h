//
//  MypeopleManager.h
//  Air21
//
//  Created by Seong-jin kim on 11 5 24.
//  Copyright 2011 Daum Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MypeopleManager : NSObject {
    NSString* appID;
    NSString* appName;
}

@property (nonatomic, retain) NSString* appID;
@property (nonatomic, retain) NSString* appName;

+ (id)sharedInstance;

- (BOOL)canOpenMypeopleURL;

- (BOOL) openMypeopleDownloadURL;

- (BOOL) openMypeopleIntroduceURL;

- (BOOL) setMypeopleProfilePhotoByUrl:(NSString*)imageUrl;

- (BOOL) setMypeopleProfilePhoto:(NSData*)imageData;

- (BOOL) sendTextMessage:(NSString*)textMessage;

- (BOOL) sendTextMessageWithUrl:(NSString *)linkUrl message:(NSString *)message;

- (BOOL) sendMediaByUrl:(NSString*)url;

- (BOOL) sendMediaData:(NSData *)mediaData fileName:(NSString*)fileName;

- (BOOL) sendMapMessage:(NSString*)mapTitle latitude:(double)latitude longitude:(double)longitude;
@end