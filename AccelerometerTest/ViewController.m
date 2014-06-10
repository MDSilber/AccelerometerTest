//
//  ViewController.m
//  AccelerometerTest
//
//  Created by Mason Silber on 5/31/14.
//  Copyright (c) 2014 MasonSilber. All rights reserved.
//

#import "FluidView.h"
#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) UIView *block;
@property (nonatomic) FluidView *fluidView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.block = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.block.center = self.view.center;
    self.block.backgroundColor = [UIColor clearColor];
    self.block.layer.borderColor = [UIColor blackColor].CGColor;
    self.block.layer.borderWidth = 2.0f;
    
    self.fluidView = [[FluidView alloc] initWithFrame:self.block.frame];
    [self.view addSubview:self.fluidView];
    [self.view addSubview:self.block];
    
    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        __weak typeof(self) weakSelf = self;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            typeof(self) strongSelf = weakSelf;
            NSLog(@"%f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y);
            
            // Moves the center block
            //CGPoint center = strongSelf.block.center;
            //center.x = MIN(MAX(center.x + accelerometerData.acceleration.x * 10.0f, 50.0f), CGRectGetWidth(self.view.bounds) - 50.0f);
            //center.y = MIN(MAX(center.y - accelerometerData.acceleration.y * 10.0f, 50.0f), CGRectGetHeight(self.view.bounds) - 50.0f);
            //strongSelf.block.center = center;
            
            strongSelf.fluidView.xAcceleration = accelerometerData.acceleration.x;
            strongSelf.fluidView.yAcceleration = accelerometerData.acceleration.y;
            [strongSelf.fluidView setNeedsDisplay];
        }];
    }
}

@end
