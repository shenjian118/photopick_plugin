//
//  SJAlbumListControllerViewController.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJAlbumListController.h"
#import "SJPhotoModel.h"
#import "SJAlbumListCell.h"
#import "SJConstants.h"
#import "SJPhotoManager.h"
#import "SJThumbnailController.h"

@interface SJAlbumListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SJAlbumListModel *> *albumList;
@end

@implementation SJAlbumListController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = kAlbumCellHeight;
    }
    return _tableView;
}

- (NSMutableArray<SJAlbumListModel *> *)albumList {
    if (!_albumList) {
        _albumList = [NSMutableArray arrayWithCapacity:0];
    }
    return _albumList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(cancelBtnClick)];
    self.navigationItem.rightBarButtonItem = cancelItem;

    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        [SJPhotoManager getPhotoAblumListWithComlete:^(NSArray<SJAlbumListModel *> * album) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.albumList removeAllObjects];
            strongSelf.albumList = [NSMutableArray arrayWithArray:album];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }];
    });
}

- (void)cancelBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumlistcell"];
    if (!cell) {
        cell = [[SJAlbumListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumlistcell"];
    }
    cell.model = self.albumList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[SJThumbnailController alloc]init] animated:YES];
}

@end
