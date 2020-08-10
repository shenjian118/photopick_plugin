//
//  SJConfig.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJConfig.h"
#import "SJPhotoModel.h"

@interface SJConfig ()
@property (nonatomic, strong) NSMutableArray<SJPhotoModel *> *photos;
@end

@implementation SJConfig

static const int kSelectedPhotoNum = 1;
static SJConfig *instance;

+ (SJConfig *)sharedSJConfig {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _photos = [NSMutableArray arrayWithCapacity:kSelectedPhotoNum];
    }
    return self;
}

- (NSArray<SJPhotoModel *> *)selectedPhotoModels {
    return self.photos;
}

- (BOOL)canAddPhotoModel {
    return self.photos.count < kSelectedPhotoNum;
}

- (void)addPhotoModel:(SJPhotoModel *)photo {
    [self.photos addObject:photo];
}

- (void)removePhotoModel:(SJPhotoModel *)photo {
    [self.photos removeObject:photo];
}

- (void)clearSelectedPhotoModels {
    [self.photos removeAllObjects];
}

@end
