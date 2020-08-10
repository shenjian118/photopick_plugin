//
//  SJConfig.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SJPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJConfig : NSObject

+ (SJConfig *)sharedSJConfig;

- (NSArray<SJPhotoModel *> *) selectedPhotoModels;

- (BOOL)canAddPhotoModel;

- (void)addPhotoModel:(SJPhotoModel *)photo;

- (void)removePhotoModel:(SJPhotoModel *)photo;

- (void)clearSelectedPhotoModels;
@end

NS_ASSUME_NONNULL_END
