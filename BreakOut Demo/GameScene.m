//
//  GameScene.m
//  BreakOut Demo
//
//  Created by Sebastián Badea on 1/7/16.
//  Copyright (c) 2016 Sebastian Badea. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"

static const CGFloat kTrackPointsPerSecond = 1000;

static const uint32_t category_fence    = 0x1 < 3; // 0x00000000000000000000000000001000
static const uint32_t category_paddle   = 0x1 < 2; // 0x00000000000000000000000000000100
static const uint32_t category_block    = 0x1 < 1; // 0x00000000000000000000000000000010
static const uint32_t category_ball     = 0x1 < 0; // 0x00000000000000000000000000000001

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTuoch;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    // set scene (aka root SKNode) node name
    self.name = @"Fence";
    
    // set scene (aka root SKNode) physics body borders as the scene edges
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0; // nothing colligding with the fence should move the fence
    self.physicsBody.contactTestBitMask = 0x0; // no callback when something hits the fence
    
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *background = (SKSpriteNode * )[self childNodeWithName:@"Background"];
    background.zPosition = 0; // Which 2D layer ? Layer 0 
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"Blue Ball.png"];
    ball1.name = @"Ball1";
    ball1.position = CGPointMake(60, 30); // give the player a chance to play befor the ball hits the fence
    ball1.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
    
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
    ball1.physicsBody.affectedByGravity = NO;
    ball1.physicsBody.categoryBitMask = category_ball;
    // affected by collisions with
    ball1.physicsBody.collisionBitMask = category_fence || category_ball || category_block || category_paddle;
    // callbacks when in contact with
    ball1.physicsBody.contactTestBitMask = category_fence || category_block;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:ball1];
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"Green Ball.png"];
    ball2.name = @"Ball2";
    ball2.position = CGPointMake(60, 75); // give the player a chance to play befor the ball hits the fence
    ball2.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
    
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
    ball2.physicsBody.affectedByGravity = NO;
    ball2.physicsBody.categoryBitMask = category_ball;
    // affected by collisions with
    ball2.physicsBody.collisionBitMask = category_fence || category_ball || category_block || category_paddle;
    // callbacks when in contact with
    ball2.physicsBody.contactTestBitMask = category_fence || category_block;
    ball2.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:ball2];
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle.png"];
    paddle.name = @"Paddle";
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
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
    paddle.physicsBody.categoryBitMask = category_paddle;
    // affected by collisions with
    paddle.physicsBody.collisionBitMask = 0x0;
    // callbacks when in contact with
    paddle.physicsBody.contactTestBitMask = category_ball;
    
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    const CGRect touchRegion = CGRectMake(0, 0, self.size.width, self.size.height * 0.3);
    
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInNode:self];
        if (CGRectContainsPoint(touchRegion, point)) {
            self.motivatingTuoch = touch;
        }
    }
    
    [self trackPaddlesToMotivatingTouches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // the reference to the motivating touch is the same as when the touches began
    [self trackPaddlesToMotivatingTouches];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:self.motivatingTuoch]) {
        self.motivatingTuoch = nil;
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:self.motivatingTuoch]) {
        self.motivatingTuoch = nil;
    }
}

-(void)trackPaddlesToMotivatingTouches {
    
    SKNode *node = [self childNodeWithName:@"Paddle"];
    UITouch *touch = self.motivatingTuoch;
    
    if (!touch) {
        return;
    }
    
    CGFloat touchXPos = [touch locationInNode:self].x;
    
    NSTimeInterval duration = ABS(touchXPos - node.position.x) / kTrackPointsPerSecond;
    [node runAction:[SKAction moveToX:touchXPos duration:duration]];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
