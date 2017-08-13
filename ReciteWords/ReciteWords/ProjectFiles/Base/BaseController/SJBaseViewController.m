//
//  SJBaseViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJBaseViewController.h"
#import "SJSearchWordsViewController.h"

@interface SJBaseViewController ()

@end

@implementation SJBaseViewController

// MARK: 生命周期

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)dealloc {
    [SVProgressHUD dismiss];
}

// MARK: Actions

- (void)clickedRightSearchItem:(UIBarButtonItem *)item {
    NSLog(@" Clicked search btn item. ");
    SJSearchWordsViewController *vc = [SJSearchWordsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: UI

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // rigth nav btn item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sj_search"] style:UIBarButtonItemStyleDone target:self action:@selector(clickedRightSearchItem:)];
}

@end
