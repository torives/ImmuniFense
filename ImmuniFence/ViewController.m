//
//  ViewController.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 01/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "ViewController.h"
#import "MainMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView * view = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * mainMenu = [MainMenu sceneWithSize:view.frame.size];
    mainMenu.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [view presentScene:mainMenu];
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
