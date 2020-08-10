//
//  SJThumbnailController.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class SJAlbumListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJThumbnailController : UIViewController

@property (nonatomic, strong) SJAlbumListModel *albumListModel;
@property (nonatomic, copy) void (^completeBlock)(NSString *path);

@end

NS_ASSUME_NONNULL_END
