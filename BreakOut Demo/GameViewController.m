//
//  GameViewController.m
//  BreakOut Demo
//
//  Created by Sebastián Badea on 1/7/16.
//  Copyright (c) 2016 Sebastian Badea. All rights reserved.
//

#import "GameViewController.h"
#import "GameStart.h"
@import GameKit;

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerLocalPlayerWithGameCenter];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [skView presentScene:scene];
    
//    [self registerLocalPlayerWithGameCenter];
}

- (void) registerLocalPlayerWithGameCenter {
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        // Don't need to pause the view as we do have a game start scene
//        SKView *skView = (SKView *)self.view;
//        [skView setPaused:YES];
        
        if (error) {
            NSLog(@"Error authenticating the local player:%@", error);
        }
        
        if (viewController) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
