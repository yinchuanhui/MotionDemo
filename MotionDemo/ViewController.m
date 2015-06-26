//
//  ViewController.m
//  MotionDemo
//
//  Created by ych on 15/6/25.
//  Copyright (c) 2015年 ych. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)DeviceOrientationManager *deviceOrientationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceOrientationManager = [[DeviceOrientationManager alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DeviceOrientationManagerDelegate

- (void)deviceOrientationDidChanged:(DeviceOrientationStatus)status{
    switch (status) {
        case DeviceOrientationStatus_Unknown:
            [self orientationUnknow];
            break;
            
        case DeviceOrientationStatus_Landscape:
            [self orientationLandscape];
            break;
            
        case DeviceOrientationStatus_LandscapeLeft:
            [self orientationLandscapeLeft];
            break;
            
        case DeviceOrientationStatus_LandscapeRight:
            [self orientationLandscapeRight];
            break;
            
        case DeviceOrientationStatus_FaceUp:
            [self orientationFaceUp];
            break;
            
        case DeviceOrientationStatus_Shake:
            [self orientationShake];
            break;
            
        default:
            break;
    }
}

#pragma mark - Handle Orientation Event

- (void)orientationUnknow{
    self.infoLabel.text = @"unknow";
    NSLog(@"===============unknow");
}

- (void)orientationLandscape{
    self.infoLabel.text = @"landscape";
    NSLog(@"===============landscape");
}

- (void)orientationLandscapeLeft{
    self.infoLabel.text = @"landscape left";
    NSLog(@"===============landscape left");
}

- (void)orientationLandscapeRight{
    self.infoLabel.text = @"landscape right";
    NSLog(@"===============landscape right");
}

- (void)orientationFaceUp{
    self.infoLabel.text = @"face up";
    NSLog(@"===============face up");
}

- (void)orientationShake{
    self.infoLabel.text = @"shake";
    NSLog(@"===============shake");
}

@end
