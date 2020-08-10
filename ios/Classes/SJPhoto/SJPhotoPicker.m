//
//  SJPhotoPicker.m
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import "SJPhotoPicker.h"
#import <Photos/Photos.h>
#import "SJAlbumListController.h"
#import "SJThumbnailController.h"
#import "SJPhotoManager.h"

@implementation SJPhotoPicker

+ (void)openFromparentVC:(UIViewController *_Nonnull)parentVC
                complete:(void (^_Nonnull)(NSString *_Nonnull))complete {
    SJAlbumListController *albumListVC = [[SJAlbumListController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:albumListVC];
    SJThumbnailController *thumbnailVC = [[SJThumbnailController alloc]init];
    thumbnailVC.completeBlock = complete;
    [nav pushViewController:thumbnailVC animated:YES];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [parentVC showDetailViewController:nav sender:nil];
}

+ (void)selectPhotoWithParentVC:(UIViewController *)parentVC
                       complete:(nonnull void (^)(NSString *_Nonnull))complete {
    if ([SJPhotoManager havePhotoLibraryAuthority]) {
        [self openFromparentVC:parentVC complete:complete];
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                                       [self openFromparentVC:parentVC complete:complete];
                                   });
                }
            }];
        } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请授权使用相册" message:@"请在设置-隐私-照片中授权" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            }];
            [alertController addAction:action];
            [parentVC presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
