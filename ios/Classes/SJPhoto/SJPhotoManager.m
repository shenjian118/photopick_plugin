//
//  SJPhotoManager.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJPhotoManager.h"
#import "SJPhotoModel.h"
#import <UIKit/UIKit.h>

@implementation SJPhotoManager

+ (BOOL)havePhotoLibraryAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (void)getPhotoAblumListWithComlete:(void (^)(NSArray<SJAlbumListModel *> *_Nonnull))complete {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    NSMutableArray<SJAlbumListModel *> *arrAlbum = [NSMutableArray array];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull collection, NSUInteger idx, BOOL *_Nonnull stop) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            SJAlbumListModel *model = [SJAlbumListModel modelWithTitle:collection.localizedTitle result:result];
            [arrAlbum addObject:model];
        }
    }];
    if (complete) {
        complete(arrAlbum);
    }
}

+ (void)convertPathWithAsset:(PHAsset *)asset
                    complete:(void (^)(NSString * _Nonnull))complete {
    [[PHImageManager defaultManager]requestImageDataAndOrientationForAsset:asset
                                                                   options:nil
                                                             resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary *_Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        NSURL *urlPath = [info objectForKey:@"PHImageFileURLKey"];
        NSString *lastImageStr = [urlPath.absoluteString lastPathComponent];
        if (!urlPath) lastImageStr = [NSString stringWithFormat:@"%ld.%@", imageData.length, [dataUTI pathExtension]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *name = [NSString stringWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], lastImageStr];
        NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:tmpPath atomically:YES];
        NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), name];
        if (complete) {
            complete(path);
        }
    }];
}

+ (NSArray<SJPhotoModel *> *)getAssetWithFetchResult:(PHFetchResult *)result {
    NSMutableArray<SJPhotoModel *> *arrModel = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL *_Nonnull stop) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [arrModel addObject:[SJPhotoModel modelWithAsset:asset]];
        }
    }];
    return arrModel;
}

+ (NSArray<SJPhotoModel *> *)getPhotoListWithAblumModel:(SJAlbumListModel *)albumListModel {
    return [self getAssetWithFetchResult:albumListModel.result];
}

+ (NSArray<SJPhotoModel *> *)getAllAsset {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    NSMutableArray<SJAlbumListModel *> *arrAlbum = [NSMutableArray array];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull collection, NSUInteger idx, BOOL *_Nonnull stop) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            SJAlbumListModel *model = [SJAlbumListModel modelWithTitle:collection.localizedTitle result:result];
            [arrAlbum addObject:model];
        }
    }];
    SJAlbumListModel *albumList = arrAlbum.firstObject;
    return [self getAssetWithFetchResult:albumList.result];
}

+ (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                                     size:(CGSize)size
                               resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                 complete:(nonnull void (^)(UIImage *_Nonnull, NSDictionary *_Nonnull))complete {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;
    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                             targetSize:size
                                                            contentMode:PHImageContentModeAspectFill
                                                                options:option
                                                          resultHandler:^(UIImage *_Nullable result, NSDictionary *_Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        if (downloadFinined && complete) {
            complete(result, info);
        }
    }];
}

@end
