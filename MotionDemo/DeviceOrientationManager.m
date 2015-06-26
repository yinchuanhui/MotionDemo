//
//  DeviceOrientationManager.m
//  MotionDemo
//
//  Created by ych on 15/6/25.
//  Copyright (c) 2015年 ych. All rights reserved.
//

#import "DeviceOrientationManager.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface DeviceOrientationManager ()

@property (nonatomic, weak)id<DeviceOrientationManagerDelegate>delegate;
@property (nonatomic, assign)DeviceOrientationStatus orientation;
@property (nonatomic, strong)CMMotionManager *motionManager;

@end

@implementation DeviceOrientationManager

- (instancetype)initWithDelegate:(id<DeviceOrientationManagerDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        self.orientation = DeviceOrientationStatus_Unknown;
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.5;
        [self.motionManager startDeviceMotionUpdates];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown:
            self.orientation = DeviceOrientationStatus_Unknown;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self confirmOrientationWithDeviceOrientation:deviceOrientation];
            break;
            
        case UIDeviceOrientationFaceUp:
            self.orientation = DeviceOrientationStatus_FaceUp;
            break;
            
        default:
            self.orientation = DeviceOrientationStatus_Unknown;
            break;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceOrientationDidChanged:)]) {
        [self.delegate deviceOrientationDidChanged:self.orientation];
    }
}

- (void)confirmOrientationWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation{
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        NSLog(@"三轴: x: %f y: %f z: %f", motion.gravity.x, motion.gravity.y, motion.gravity.z);
    }];

}

- (void)dealloc{
    [self.motionManager stopMagnetometerUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
