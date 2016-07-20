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
    
    // set scene (aka root SKNode) physics body borders as the scene edges
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"Blue Ball.png"];
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.position = CGPointMake(100, self.size.height/2);
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.0;
    ball1.physicsBody.angularDamping = 0.0;
    ball1.physicsBody.allowsRotation = NO;
    ball1.physicsBody.mass = 1.0;
    ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0); // initial velocity
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"Green Ball.png"];
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.position = CGPointMake(300, self.size.height/2);
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = NO;
    ball2.physicsBody.mass = 1.0;
    ball2.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle.png"];
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
    paddle.physicsBody.dynamic = NO; // doesn't move by itself
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 1.0;
    paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
    
    [self addChild:ball1];
    [self addChild:ball2];
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
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
