//
//  SJAlbumListCell.m
//  photodemo
//
//  Created by 健沈 on 2020/8/8.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJAlbumListCell.h"
#import "SJPhotoModel.h"
#import "SJConstants.h"
#import "SJPhotoManager.h"

@interface SJAlbumListCell ()
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SJAlbumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat imageViewHeight = kAlbumCellHeight - kAlbumCellVerticalMargin * 2;
        imageView.frame = CGRectMake(kAlbumCellHeaderMargin, kAlbumCellVerticalMargin, imageViewHeight, imageViewHeight);
        [self.contentView addSubview:imageView];
        self.thumbImageView = imageView;

        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMidY(imageView.frame) - kAlbumCellLabelHeight * 0.5, kAlbumCellLabelWeight, kAlbumCellLabelHeight);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setModel:(SJAlbumListModel *)model {
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%ld)", model.title, model.count];
    __weak typeof(self) weakSelf = self;
    [SJPhotoManager requestImageWithAsset:model.headImageAsset
                                     size:self.thumbImageView.frame.size
                               resizeMode:PHImageRequestOptionsResizeModeFast
                                 complete:^(UIImage *_Nonnull image, NSDictionary *_Nonnull info) {
                                     __strong typeof(weakSelf) strongSelf = weakSelf;
                                     strongSelf.thumbImageView.image = image;
                                 }];
}

@end
