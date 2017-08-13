//
//  SJTabBarController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJTabBarController.h"
#import "SJReciteWordsViewController.h"
#import "SJBaseNavigationController.h"
#import "SJAllWordViewController.h"
#import "SJMineViewController.h"
#import "SJSearchWordsViewController.h"

@interface SJTabBarController ()

@end

@implementation SJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<UIViewController *> *viewControllersM = [NSMutableArray new];
    viewControllersM[0] = [self controllerWithTitle:nil
                                       imageNameStr:@"page-bar-item1"
                                          className:NSStringFromClass([SJReciteWordsViewController class])];
    viewControllersM[1] = [self controllerWithTitle:nil imageNameStr:@"page-bar-item2" className:NSStringFromClass([SJAllWordViewController class])];
     viewControllersM[2] = [self controllerWithTitle:nil imageNameStr:@"page-bar-item3" className:NSStringFromClass([SJSearchWordsViewController class])];
     viewControllersM[3] = [self controllerWithTitle:nil imageNameStr:@"page-bar-item4" className:NSStringFromClass([SJMineViewController class])];
    

    self.viewControllers = viewControllersM.copy;
    // Do any additional setup after loading the view.
}

- (UIViewController *)controllerWithTitle:(NSString *)title imageNameStr:(NSString *)imageNameStr className:(NSString *)name {
    Class cls = NSClassFromString(name);
    if ( nil == cls ) { NSLog(@"%s-%s-%@: 类名写错!", __FILE__, __func__, name); return nil; }
    UIViewController *vc = [cls new];
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageNameStr];
    SJBaseNavigationController *nav = [[SJBaseNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

@end
