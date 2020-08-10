#import "PhotopickerPlugin.h"
#import "SJPhotoPicker.h"

@implementation PhotopickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"shenjian/photo_picker"
                                           binaryMessenger:[registrar messenger]];
    PhotopickerPlugin *instance = [[PhotopickerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"pickPhoto" isEqualToString:call.method]) {
        [SJPhotoPicker selectPhotoWithParentVC:[self viewControllerWithWindow:nil] complete:^(NSString *_Nonnull path) {
            NSLog(@"Path 111: %@", path);
            result(path);
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIViewController *)viewControllerWithWindow:(UIWindow *)window {
    UIWindow *windowToUse = window;
    if (windowToUse == nil) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                windowToUse = window;
                break;
            }
        }
    }

    UIViewController *topController = windowToUse.rootViewController;
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    return topController;
}

@end
