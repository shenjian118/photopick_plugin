//
//  SJThumbnailController.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJThumbnailController.h"
#import "SJPhotoManager.h"
#import "SJPhotoModel.h"
#import "SJThumbnailCell.h"
#import "SJConfig.h"
#import "SJConstants.h"
#import "SJPhotoViewController.h"

@interface SJThumbnailController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<SJPhotoModel *> *arrDataSources;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *comfirmBtn;
@end

@implementation SJThumbnailController

- (NSMutableArray<SJPhotoModel *> *)arrDataSources {
    if (!_arrDataSources) {
        _arrDataSources = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrDataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相片";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(cancelBtnClick)];
    self.navigationItem.rightBarButtonItem = cancelItem;

    [self setupCollectionView];
    [self setupBottomView];
    [self requestPhotos];
}

- (void)dealloc {
    [[SJConfig sharedSJConfig]clearSelectedPhotoModels];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets inset = self.view.safeAreaInsets;
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - inset.bottom - kThumbnailVCBottomViewHeight);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.frame.size.width, kThumbnailVCBottomViewHeight + inset.bottom);
    self.comfirmBtn.frame = CGRectMake(self.view.frame.size.width - 100, 8, kThumbnailVCConfirmBtnWidth, kThumbnailVCConfirmBtnHeight);
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSInteger columnCount = 4;
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 1.5 * columnCount) / columnCount, (self.view.frame.size.width - 1.5 * columnCount) / columnCount);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[SJThumbnailCell class] forCellWithReuseIdentifier:@"SJCollectionCell"];
}

- (void)setupBottomView {
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = RGBCOLOR(45, 45, 45);
    self.comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.comfirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.comfirmBtn setBackgroundColor:RGBCOLOR(39, 80, 32)];
    self.comfirmBtn.layer.masksToBounds = YES;
    self.comfirmBtn.layer.cornerRadius = 3.0f;
    [self.comfirmBtn addTarget:self action:@selector(comfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.comfirmBtn];
    [self.view addSubview:self.bottomView];
}

- (void)requestPhotos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.arrDataSources removeAllObjects];
        if (self.albumListModel) {
            self.arrDataSources = [NSMutableArray arrayWithArray:[SJPhotoManager getAssetWithFetchResult:self.albumListModel.result]];
        } else {
            self.arrDataSources = [NSMutableArray arrayWithArray:[SJPhotoManager getAllAsset]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (void)cancelBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetConfirmBtn {
    BOOL hasSelectPhoto = [SJConfig sharedSJConfig].selectedPhotoModels.count > 0;
    self.comfirmBtn.enabled = hasSelectPhoto > 0;
    self.comfirmBtn.backgroundColor = hasSelectPhoto ? RGBCOLOR(80, 169, 52) : RGBCOLOR(39, 80, 32);
    [self.comfirmBtn setTitleColor:hasSelectPhoto? [UIColor whiteColor] : [UIColor grayColor] forState:UIControlStateNormal];
}

- (void)comfirmBtnClick {
    SJPhotoModel *model = [SJConfig sharedSJConfig].selectedPhotoModels.firstObject;
    [SJPhotoManager convertPathWithAsset:model.asset complete:^(NSString * _Nonnull path) {
        self.completeBlock(path);
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrDataSources.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJCollectionCell" forIndexPath:indexPath];
    SJPhotoModel *model = self.arrDataSources[indexPath.row];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    cell.selectedBlock = ^(BOOL selected) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!selected && [[SJConfig sharedSJConfig] canAddPhotoModel]) {
            [[SJConfig sharedSJConfig] addPhotoModel:model];
            model.selected = YES;
        } else {
            [[SJConfig sharedSJConfig] removePhotoModel:model];
            model.selected = NO;
        }
        [strongSelf.collectionView reloadData];
        [strongSelf resetConfirmBtn];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SJPhotoViewController *vc = [[SJPhotoViewController alloc]init];
    vc.photoModel = self.arrDataSources[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
