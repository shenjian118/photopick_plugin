//
//  SJPhotoPicker.h
//  photodemo
//
//  Created by 健沈 on 2020/8/9.
//  Copyright © 2020 健沈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJPhotoPicker : NSObject

+(void)selectPhotoWithParentVC:(UIViewController *)parentVC
                      complete:(void(^)(NSString *path))complete;

@end

NS_ASSUME_NONNULL_END
