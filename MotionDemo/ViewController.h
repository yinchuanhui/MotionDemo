//
//  ViewController.h
//  MotionDemo
//
//  Created by ych on 15/6/25.
//  Copyright (c) 2015年 ych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceOrientationManager.h"

@interface ViewController : UIViewController <DeviceOrientationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

