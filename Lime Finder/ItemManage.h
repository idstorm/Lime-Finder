//
//  ItemManage.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 29..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#ifndef Lime_Finder_ItemManage_h
#define Lime_Finder_ItemManage_h


#endif


/* 즐겨찾기 적용단계 */
typedef enum
{
    ITEM_MANAGE_SEQUENCE_STEP_01_01,
    ITEM_MANAGE_SEQUENCE_STEP_01_02,
    ITEM_MANAGE_SEQUENCE_STEP_02_01,
    ITEM_MANAGE_SEQUENCE_STEP_02_02,
    ITEM_MANAGE_SEQUENCE_STEP_03_01,
    ITEM_MANAGE_SEQUENCE_STEP_03_02,
    ITEM_MANAGE_SEQUENCE_STEP_03_03,
    ITEM_MANAGE_SEQUENCE_STEP_04_01,
    ITEM_MANAGE_SEQUENCE_STEP_05_01,
    ITEM_MANAGE_SEQUENCE_END
} ItemManageSequence;

/* 즐겨찾기 등록상태 */
typedef enum
{
    ITEM_MANAGE_STATE_ADD,
    ITEM_MANAGE_STATE_EDIT
} ItemManageState;

/* 검색어 인코딩 타입 */
typedef enum
{
    ITEM_MANAGE_STRING_ENCODING_TYPE_UTF8,
    ITEM_MANAGE_STRING_ENCODING_TYPE_LOCALE
} ItemManageStringEncodingType;