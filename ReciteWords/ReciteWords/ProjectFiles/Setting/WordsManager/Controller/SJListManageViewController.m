//
//  SJListManageViewController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJListManageViewController.h"

#import "SJBaseTableView.h"

#import "SJWordList.h"

#import "SJWordInfo.h"

#import "SJWordsListViewController.h"

#import "UIViewController+Extension.h"

static CellID const SJListManageTableCellID = @"SJListManageTableCell";


@interface SJListManageViewController (UITableViewDelegateMethods)<UITableViewDelegate> @end
@interface SJListManageViewController (UITableViewDataSourceMethods)<UITableViewDataSource> @end



@interface SJListManageViewController ()

@property (nonatomic, strong, readonly) SJBaseTableView *tableView;
@property (nonatomic, strong, readwrite) NSMutableArray<SJWordList *> *listsM;
@property (nonatomic, strong, readonly) UIButton *createListBtn;

@end

@implementation SJListManageViewController

@synthesize tableView = _tableView;
@synthesize createListBtn = _createListBtn;
@synthesize listsM = _listsM;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self _SJListManageViewControllerSetupUI];
    [self _SJListManageViewControllerGetLocalAllList];
}

- (void)_SJListManageViewControllerGetLocalAllList {
    __weak typeof(self) _self = self;
    [LocalManager queryLocalLists:^(NSArray<SJWordList *> * _Nullable lists) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.listsM = lists.mutableCopy;
        [self.tableView reloadData];
    }];
}

// MARK: Actions

- (void)clickedBtn:(UIButton *)btn {
    NSLog(@"clicked Btn");
    __weak typeof(self) _self = self;
    [LocalManager createListAtController:self callBlock:^(SJWordList * _Nullable list, NSString * _Nonnull errorStr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( nil == list ) { [SVProgressHUD showErrorWithStatus:errorStr]; return; }
        [SVProgressHUD showSuccessWithStatus:@"创建成功.."];
        [self.listsM addObject:list];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.listsM.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

// MARK: UI

- (void)_SJListManageViewControllerSetupUI {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createListBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
 
    [_createListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(20);
        make.bottom.offset(-20);
    }];
}

- (SJBaseTableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [SJBaseTableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = ceil(64 * SJ_Rate);
    [_tableView registerClass:NSClassFromString(SJListManageTableCellID) forCellReuseIdentifier:SJListManageTableCellID];
    return _tableView;
}

- (UIButton *)createListBtn {
    if ( _createListBtn ) return _createListBtn;
    _createListBtn = [UIButton buttonWithImageName:@"sj_create_list" tag:0 target:self sel:@selector(clickedBtn:)];
    return _createListBtn;
}

@end


#import "SJWordList.h"

@implementation SJListManageViewController (UITableViewDelegateMethods)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SJWordsListViewController *vc = [[SJWordsListViewController alloc] initWithList:[cell valueForKey:@"list"]];
    vc.title = [(SJWordList *)[cell valueForKey:@"list"] title];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation SJListManageViewController (UITableViewDataSourceMethods)

// MARK: Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listsM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJListManageTableCellID];
    [cell setValue:self.listsM[indexPath.row] forKey:@"list"];
    return cell;
}


// MARK: Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<UITableViewRowAction *> *actionsM = [NSMutableArray new];
    UITableViewRowAction *editA = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"edit");
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        SJWordList *list = [cell valueForKey:@"list"];
        [self alertWithTitle:@"更名" textFieldText:list.title textFieldPlaceholder:@"请输入新的词单名" action:^(NSString * _Nonnull inputText) {
            if ( [list.title isEqualToString:inputText] ) return;
            NSString *oldTitle = list.title;
            list.title = inputText;
            [LocalManager updatedList:list property:@[@"title"] callBlock:^(BOOL result) {
                if ( !result ) {
                    [SVProgressHUD showErrorWithStatus:@"更改失败"];
                    list.title = oldTitle;
                    return;
                }
                [SVProgressHUD showSuccessWithStatus:@"更改成功"];
                [self.tableView setEditing:NO animated:YES];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        } cancelAction:^{
            [self.tableView setEditing:NO animated:YES];
        }];
    }];
    editA.backgroundColor = SJ_Font_C;
    
    UITableViewRowAction *deleteA = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        SJWordList *list = [cell valueForKey:@"list"];
        [self alertWithType:AlertType_DeleteAndCancel title:@"删除" msg:@"确定删除?" action:^{
            [LocalManager removeList:list callBlock:^(BOOL result) {
                if ( !result )
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                else {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self.listsM removeObject:list];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }];
    }];
    if ( deleteA )  [actionsM addObject:deleteA];
    if ( editA )    [actionsM addObject:editA];
    
    return actionsM;
}

@end
