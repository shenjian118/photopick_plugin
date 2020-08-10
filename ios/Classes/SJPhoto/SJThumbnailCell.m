//
//  SJThumbnailCell.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJThumbnailCell.h"
#import "SJPhotoManager.h"
#import "SJPhotoModel.h"
#import "SJConstants.h"

@interface SJThumbnailCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation SJThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = self.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];

    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(self.bounds.size.width - 26, 5, kThumbnailCellBtnHeight, kThumbnailCellBtnHeight);
    [self.selectBtn addTarget:self action:@selector(btnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectBtn];

    self.markLabel = [[UILabel alloc]init];
    self.markLabel.frame = CGRectMake(self.bounds.size.width - 26, 5, kThumbnailCellBtnHeight, kThumbnailCellBtnHeight);
    [self.contentView addSubview:self.markLabel];
}

- (void)btnSelectClick:(UIButton *)sender {
    if (self.selectedBlock) {
        self.selectedBlock(self.selectBtn.selected);
    }
}

- (void)setModel:(SJPhotoModel *)model {
    _model = model;

    self.selectBtn.selected = model.isSelected;

    self.markLabel.backgroundColor = model.isSelected ? RGBCOLOR(80, 169, 52) : [UIColor lightGrayColor];

    CGSize size = CGSizeMake(self.frame.size.width * 1.5, self.frame.size.height * 1.7);
    if (model.asset && self.imageRequestID > PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }

    self.imageView.image = nil;
    __weak typeof(self) weakSelf = self;
    self.imageRequestID = [SJPhotoManager requestImageWithAsset:model.asset
                                                           size:size
                                                     resizeMode:PHImageRequestOptionsResizeModeFast
                                                       complete:^(UIImage *_Nonnull image, NSDictionary *_Nonnull info) {
                                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                                           strongSelf.imageView.image = image;
                                                           if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                                                               strongSelf.imageRequestID = -1;
                                                           }
                                                       }];
}

@end
