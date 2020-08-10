//
//  SJPhotoModel.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJPhotoModel : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (instancetype)modelWithAsset:(PHAsset *)asset ;
@end

@interface SJAlbumListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) PHAsset *headImageAsset;

+ (instancetype)modelWithTitle:(NSString *)title
                        result:(PHFetchResult *)result;
@end

NS_ASSUME_NONNULL_END
