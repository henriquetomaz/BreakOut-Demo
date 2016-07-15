//
//  GameStart.m
//  BreakOut Demo
//
//  Created by Sebastián Badea on 11/7/16.
//  Copyright © 2016 Sebastian Badea. All rights reserved.
//

#import "GameStart.h"
#import "GameScene.h"

@implementation GameStart

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches) {
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        
        // Create and configure the scene.
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

@end
