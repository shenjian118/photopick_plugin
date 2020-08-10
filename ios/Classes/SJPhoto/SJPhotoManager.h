//
//  SJPhotoManager.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class SJPhotoModel;
@class SJAlbumListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJPhotoManager : NSObject
+ (BOOL)havePhotoLibraryAuthority;

+ (void)getPhotoAblumListWithComlete:(void (^)(NSArray<SJAlbumListModel *> *))complete;

+ (void)convertPathWithAsset:(PHAsset *)asset
                    complete:(void (^)(NSString *path))complete;

+ (NSArray<SJPhotoModel *> *)getAllAsset;

+ (NSArray<SJPhotoModel *> *)getAssetWithFetchResult:(PHFetchResult *)result;

+ (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                                     size:(CGSize)size
                               resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                 complete:(void (^)(UIImage *image, NSDictionary *info))complete;
@end

NS_ASSUME_NONNULL_END
