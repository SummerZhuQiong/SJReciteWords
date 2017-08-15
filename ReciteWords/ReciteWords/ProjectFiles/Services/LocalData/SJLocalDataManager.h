//
//  SJLocalDataManager.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/1.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LocalManager    [SJLocalDataManager sharedManager]


NS_ASSUME_NONNULL_BEGIN


@class SJWordList, SJWordInfo;

@interface SJLocalDataManager : NSObject

+ (instancetype)sharedManager;

@end


@interface SJLocalDataManager (InsertOrUpdate)

/*!
 *  创建一个词单
 */
- (void)createListWithTitle:(NSString *)Title callBlock:(void(^)(SJWordList * __nullable list))block;

/*!
 *  添加单词到词单
 */
- (void)addedWordsToList:(SJWordList *)list words:(NSArray<SJWordInfo *> *)words callBlock:(void(^ __nullable)(BOOL result))block;

/*!
 *  更新单词
 */
- (void)updatedWord:(SJWordInfo *)word property:(NSArray<NSString *> *)property callBlock:(void(^ __nullable)(BOOL result))block;

/*!
 *  更新词单
 */
- (void)updateList:(SJWordList *)list property:(NSArray<NSString *> *)property callBlock:(void(^ __nullable)(BOOL result))block;

@end



@interface SJLocalDataManager (Delete)

/*!
 *  从词单删除单词
 */
- (void)removeWordsFromList:(SJWordList *)list words:(NSArray<SJWordInfo *> *)words callBlock:(void(^ __nullable)(BOOL result))block;

@end



@interface SJLocalDataManager (Query)

/*!
 *  获取所有词单
 */
- (void)queryLocalLists:(void(^)(NSArray<SJWordList *> * __nullable lists))block;

@end



@interface SJLocalDataManager (SearchList)

/*!
 *  if this value is Null, you should call getSearchList: method get it.
 *  warning: You can't create it.
 */
@property (nonatomic, strong, nullable) SJWordList *searchWordList;

- (void)getSearchHistory:(void(^)(SJWordList *searchList))block;

- (void)searchListAddWord:(SJWordInfo *)word callBlock:(void(^ __nullable)(BOOL result))block;

@end


NS_ASSUME_NONNULL_END
