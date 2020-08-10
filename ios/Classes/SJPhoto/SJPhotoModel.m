//
//  SJPhotoModel.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJPhotoModel.h"

@implementation SJPhotoModel

+ (instancetype)modelWithAsset:(PHAsset *)asset{
    SJPhotoModel *model = [[SJPhotoModel alloc] init];
    model.asset = asset;
    model.selected = NO;
    return model;
}

@end

@implementation SJAlbumListModel

+ (instancetype)modelWithTitle:(NSString *)title result:(PHFetchResult *)result {
    SJAlbumListModel *model = [[SJAlbumListModel alloc]init];
    model.title = title;
    model.count = result.count;
    model.result = result;
    model.headImageAsset = result.firstObject;
    return model;
}

@end


