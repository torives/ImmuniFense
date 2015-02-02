//
//  ViewController.m
//  ImmuniFence
//
//  Created by Victor Yves Crispim on 01/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
//    // Create and configure the scene.
//    SKScene * scene = [TitleScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeResizeFill;
//    
//    // Present the scene.
//    [SKView presentScene:scene];
}

- (BOOL)shouldAutorotate{
    
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
