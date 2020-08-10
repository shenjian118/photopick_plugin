//
//  SJAlbumListCell.h
//  photodemo
//
//  Created by 健沈 on 2020/8/8.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJAlbumListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJAlbumListCell : UITableViewCell

@property (nonatomic, strong) SJAlbumListModel *model;

@end

NS_ASSUME_NONNULL_END
