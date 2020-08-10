//
//  SJThumbnailCell.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJThumbnailCell : UICollectionViewCell

@property (nonatomic, strong) SJPhotoModel *model;

@property (nonatomic, copy) void (^selectedBlock)(BOOL);
@end

NS_ASSUME_NONNULL_END
