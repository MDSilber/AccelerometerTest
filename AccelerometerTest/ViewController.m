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

@property (nonatomic) UIGravityBehavior *gravityBehavior;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic) UIDynamicAnimator *animator;
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
    self.block.clipsToBounds = YES;
    [self.view addSubview:self.block];

    self.fluidView = [[FluidView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)];
    self.fluidView.center = CGPointMake(50.0f, 200.0f);
    [self.block addSubview:self.fluidView];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.block];

    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.fluidView]];

    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.fluidView offsetFromCenter:UIOffsetMake(0.0f, -1.0f * CGRectGetHeight(self.fluidView.frame) / 2.0f) attachedToAnchor:CGPointMake(CGRectGetWidth(self.block.frame) / 2.0f, (CGRectGetHeight(self.block.frame) / 2.0f) - 10.0f)];
    self.attachmentBehavior.length = 10.0f;
    self.attachmentBehavior.damping = 0.5f;

    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.fluidView]];
    self.itemBehavior.angularResistance = 10.0f;

    [self.animator addBehavior:self.attachmentBehavior];

    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        __weak typeof(self) weakSelf = self;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            typeof(self) strongSelf = weakSelf;
            NSLog(@"%f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y);



            //                        x: 0.0f, y: -1.0f
            //     x: -1.0f, y: 0.0f                     x: 1.0f, y: 0.0f
            //                        x: 0.0f, y: 1.0f

//            strongSelf.gravityBehavior.gravityDirection = CGVectorMake(10.0f * accelerometerData.acceleration.x, -10.0f * accelerometerData.acceleration.y);

            // Moves the center block
            //CGPoint center = strongSelf.block.center;
            //center.x = MIN(MAX(center.x + accelerometerData.acceleration.x * 10.0f, 50.0f), CGRectGetWidth(self.view.bounds) - 50.0f);
            //center.y = MIN(MAX(center.y - accelerometerData.acceleration.y * 10.0f, 50.0f), CGRectGetHeight(self.view.bounds) - 50.0f);
            //strongSelf.block.center = center;
            
//            strongSelf.fluidView.xAcceleration = accelerometerData.acceleration.x;
//            strongSelf.fluidView.yAcceleration = accelerometerData.acceleration.y;
//            [strongSelf.fluidView setNeedsDisplay];

            strongSelf.gravityBehavior.gravityDirection = CGVectorMake(accelerometerData.acceleration.x, 10 * fabsf(accelerometerData.acceleration.y));
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.gravityBehavior.gravityDirection = CGVectorMake(0.0f, -1.0f);
    [self.animator addBehavior:self.gravityBehavior];
}

@end
