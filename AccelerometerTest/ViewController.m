//
//  ViewController.m
//  AccelerometerTest
//
//  Created by Mason Silber on 5/31/14.
//  Copyright (c) 2014 MasonSilber. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) UIView *containerView, *fluidView, *iceCube1, *iceCube2;
@property (nonatomic) UIGravityBehavior *fluidGravityBehavior, *iceCubeGravityBehavior;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIDynamicItemBehavior *fluidItemBehavior;
@property (nonatomic) UICollisionBehavior *iceCubeCollisionBehavior;
@property (nonatomic) UIDynamicAnimator *animator;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.containerView.center = self.view.center;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 2.0f;
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];

    self.fluidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)];
    self.fluidView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:151.0f/255.0f blue:76.0f/255.0f alpha:1.0f];
    self.fluidView.center = CGPointMake(50.0f, 200.0f);
    [self.containerView addSubview:self.fluidView];


    self.iceCube1 = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 74.0f, 25.0f, 25.0f)];
    self.iceCube1.backgroundColor = [UIColor clearColor];
    self.iceCube1.layer.cornerRadius = 6.0f;
    self.iceCube1.layer.borderColor = [UIColor blackColor].CGColor;
    self.iceCube1.layer.borderWidth = 2.0f;
    [self.containerView addSubview:self.iceCube1];

    CGRect iceCubeFrame = self.iceCube1.frame;
    iceCubeFrame.origin.y -= CGRectGetHeight(self.iceCube1.bounds);
    iceCubeFrame.origin.x += 12.0f;
    self.iceCube2 =  [[UIView alloc] initWithFrame:iceCubeFrame];
    self.iceCube2.backgroundColor = [UIColor clearColor];
    self.iceCube2.layer.cornerRadius = 6.0f;
    self.iceCube2.layer.borderColor = [UIColor blackColor].CGColor;
    self.iceCube2.layer.borderWidth = 2.0f;
    [self.containerView addSubview:self.iceCube2];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.containerView];

    self.fluidGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.fluidView]];

    self.iceCubeGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.iceCube1, self.iceCube2]];

    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.fluidView offsetFromCenter:UIOffsetMake(0.0f, -1.0f * CGRectGetHeight(self.fluidView.frame) / 2.0f) attachedToAnchor:CGPointMake(CGRectGetWidth(self.containerView.frame) / 2.0f, (CGRectGetHeight(self.containerView.frame) / 2.0f) - 10.0f)];
    self.attachmentBehavior.length = 10.0f;
    self.attachmentBehavior.damping = 0.0f;

    self.fluidItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.fluidView]];
    self.fluidItemBehavior.angularResistance = 10.0f;

    self.iceCubeCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.iceCube1, self.iceCube2]];
    [self.iceCubeCollisionBehavior addBoundaryWithIdentifier:@"container" forPath:[UIBezierPath bezierPathWithRect:self.containerView.bounds]];
    [self.animator addBehavior:self.iceCubeCollisionBehavior];

    [self.animator addBehavior:self.attachmentBehavior];

    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        __weak typeof(self) weakSelf = self;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            typeof(self) strongSelf = weakSelf;
//            NSLog(@"%f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y);

            //                        x: 0.0f, y: -1.0f
            //     x: -1.0f, y: 0.0f                     x: 1.0f, y: 0.0f
            //                        x: 0.0f, y: 1.0f

            // Factor of 10 is to pull down on liquid much more strongly than horizontal forces
            strongSelf.fluidGravityBehavior.gravityDirection = CGVectorMake(accelerometerData.acceleration.x, 10 * fabsf(accelerometerData.acceleration.y));
            strongSelf.iceCubeGravityBehavior.gravityDirection = CGVectorMake(accelerometerData.acceleration.x, fabsf(accelerometerData.acceleration.y));
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.fluidGravityBehavior.gravityDirection = CGVectorMake(0.0f, 1.0f);
    self.iceCubeGravityBehavior.gravityDirection = CGVectorMake(0.0f, 1.0f);
    [self.animator addBehavior:self.fluidGravityBehavior];
    [self.animator addBehavior:self.iceCubeGravityBehavior];
}

@end
