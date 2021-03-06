//
//  SJSearchWordsBar.h
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJSearchWordsBarDelegate;

@interface SJSearchWordsBar : UIView

@property (nonatomic, weak) id <SJSearchWordsBarDelegate> delegate;

@end

@protocol SJSearchWordsBarDelegate <NSObject>

- (void)finishedInputWithSearchWordsBar:(SJSearchWordsBar *)bar content:(NSString *)content;

@end
