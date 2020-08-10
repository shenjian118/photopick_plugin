//
//  SJPhotoViewController.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJPhotoViewController.h"
#import "SJPhotoManager.h"
#import "SJPhotoModel.h"

@interface SJPhotoViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SJPhotoViewController

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.frame = self.view.bounds;
    [self.view addSubview:self.imageView];

    [SJPhotoManager requestImageWithAsset:self.photoModel.asset
                                     size:self.imageView.frame.size
                               resizeMode:PHImageRequestOptionsResizeModeFast
                                 complete:^(UIImage *_Nonnull image, NSDictionary *_Nonnull info) {
                                     self.imageView.image = image;
                                 }];
}

@end
