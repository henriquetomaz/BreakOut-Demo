//
//  GameScene.m
//  BreakOut Demo
//
//  Created by Sebastián Badea on 1/7/16.
//  Copyright (c) 2016 Sebastian Badea. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches) {
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        
        // Create and configure the scene.
        GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
