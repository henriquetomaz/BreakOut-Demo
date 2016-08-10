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

static const uint32_t category_fence    = 0x1 << 3; // 0x00000000000000000000000000001000
static const uint32_t category_paddle   = 0x1 << 2; // 0x00000000000000000000000000000100
static const uint32_t category_block    = 0x1 << 1; // 0x00000000000000000000000000000010
static const uint32_t category_ball     = 0x1 << 0; // 0x00000000000000000000000000000001

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTuoch;
@property (strong, nonatomic) NSMutableArray *blockBreakFrames;

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
    background.lightingBitMask = 0x1;
    
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
    ball1.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle;
    // callbacks when in contact with
    ball1.physicsBody.contactTestBitMask = category_fence | category_block;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:ball1];
    
    // Add a light (why not?) to the ball
    SKLightNode *light = [SKLightNode new];
    light.categoryBitMask = 0x1;
    light.falloff = 1;
    light.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    light.ambientColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light.zPosition = 1;
    
    [ball1 addChild:light];
    
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
    ball2.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle;
    // callbacks when in contact with
    ball2.physicsBody.contactTestBitMask = category_fence | category_block;
    ball2.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:ball2];
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle.png"];
    paddle.name = @"Paddle";
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
    paddle.lightingBitMask = 0x1;
    
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
    paddle.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
    
    self.blockBreakFrames = [NSMutableArray array];
    
    SKTextureAtlas *blockBreakAnimation = [SKTextureAtlas atlasNamed:@"block-break.atlas"];
    unsigned long numImages = blockBreakAnimation.textureNames.count;
    
    for (int i = 0; i < numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Block-Break%02d", i];
        SKTexture *tempTexture = [blockBreakAnimation textureNamed:textureName];
        [self.blockBreakFrames addObject:tempTexture];
    }
    
    // Add blocks
    SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:self.blockBreakFrames[0]];
    block.scale = 0.2; // scale to 20%
    
    CGFloat kBlockWidth = block.size.width;
    CGFloat kBlockHeight = block.size.height;
    CGFloat kBlockHorizontalSpace = 20.0f;
    int kBlocksPerRow = self.size.width / (kBlockWidth + kBlockHorizontalSpace);
    
    for (int i = 0; i < kBlocksPerRow; i++) {
        block = [SKSpriteNode spriteNodeWithTexture:self.blockBreakFrames[0]];
        block.scale = 0.2; // scale to 20%
        
        block.name = @"Block";
        block.position = CGPointMake(kBlockHorizontalSpace/2 + kBlockWidth/2 + i*kBlockWidth + i*kBlockHorizontalSpace, self.size.height - 100);
        block.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
        block.lightingBitMask = 0x1;
        
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO; // doesn't move by itself
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
        block.physicsBody.categoryBitMask = category_block;
        // affected by collisions with
        block.physicsBody.collisionBitMask = 0x0;
        // callbacks when in contact with
        block.physicsBody.contactTestBitMask = category_ball;
        block.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:block];
    }
    
    kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizontalSpace)) - 2;
    
    for (int i = 0; i < kBlocksPerRow; i++) {
        block = [SKSpriteNode spriteNodeWithTexture:self.blockBreakFrames[0]];
        block.scale = 0.2; // scale to 20%
        
        block.name = @"Block";
        block.position = CGPointMake(kBlockHorizontalSpace + kBlockWidth + i*kBlockWidth + i*kBlockHorizontalSpace, self.size.height - 100 - (1.5 * kBlockHeight));
        block.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
        block.lightingBitMask = 0x1;
        
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO; // doesn't move by itself
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
        block.physicsBody.categoryBitMask = category_block;
        // affected by collisions with
        block.physicsBody.collisionBitMask = 0x0;
        // callbacks when in contact with
        block.physicsBody.contactTestBitMask = category_ball;
        block.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:block];
    }
    
    kBlocksPerRow = self.size.width / (kBlockWidth + kBlockHorizontalSpace);
    
    for (int i = 0; i < kBlocksPerRow; i++) {
        block = [SKSpriteNode spriteNodeWithTexture:self.blockBreakFrames[0]];
        block.scale = 0.2; // scale to 20%
        
        block.name = @"Block";
        block.position = CGPointMake(kBlockHorizontalSpace + kBlockWidth + i*kBlockWidth + i*kBlockHorizontalSpace, self.size.height - 100 - (3 * kBlockHeight));
        block.zPosition = 1; // Which 2D layer ? Layer 1; base layer is 0
        block.lightingBitMask = 0x1;
        
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO; // doesn't move by itself
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
        block.physicsBody.categoryBitMask = category_block;
        // affected by collisions with
        block.physicsBody.collisionBitMask = 0x0;
        // callbacks when in contact with
        block.physicsBody.contactTestBitMask = category_ball;
        block.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:block];
    }
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
    
    static const int kMaxSpeed = 1500;
    static const int kMinSpeed = 400;
    
    // Adjust the linear damping if the ball starts moving a little too fast or slow
    SKNode *ball1 = [self childNodeWithName:@"Ball1"];
    SKNode *ball2 = [self childNodeWithName:@"Ball2"];
    
    float speedBall1 = sqrt(ball1.physicsBody.velocity.dx * ball1.physicsBody.velocity.dx + ball1.physicsBody.velocity.dy * ball1.physicsBody.velocity.dy);
    
    float dx = (ball1.physicsBody.velocity.dx + ball2.physicsBody.velocity.dx) / 2;
    float dy = (ball1.physicsBody.velocity.dy + ball2.physicsBody.velocity.dy) / 2;
    float speed = sqrt(dx * dx + dy * dy);
    
    if (kMaxSpeed < speed || kMaxSpeed < speedBall1) {
        ball1.physicsBody.linearDamping += 0.1f;
        ball2.physicsBody.linearDamping += 0.1f;
//        ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * 0.9, ball2.physicsBody.velocity.dy * 0.9);
    } else if (kMinSpeed > speed || kMinSpeed > speedBall1) {
        ball1.physicsBody.linearDamping -= 0.1f;
        ball2.physicsBody.linearDamping -= 0.1f;
        //        ball2.physicsBody.velocity = CGVectorMake(ball2.physicsBody.velocity.dx * 1.1, ball2.physicsBody.velocity.dy * 1.1);
    } else {
        ball1.physicsBody.linearDamping = 0.0f;
        ball2.physicsBody.linearDamping = 0.0f;
    }
    
//    NSLog(@"ball1 %f %f", ball1.position.x, ball1.position.y);
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    if (([nameA containsString:@"Block"] && [nameB containsString:@"Ball"]) || ([nameA containsString:@"Ball"] && [nameB containsString:@"Block"]) ) {
    
        // Figure out which body is exploding
        SKNode *block;
        if ([nameA containsString:@"Block"]) {
            block = contact.bodyA.node;
        } else {
            block = contact.bodyB.node;
        }
        
        // Do the build up
        SKAction *actionAudioRampUp = [SKAction playSoundFileNamed:@"firework-single-rocket.wav" waitForCompletion:NO];
        SKAction *actionVisualRampUp = [SKAction animateWithTextures:self.blockBreakFrames timePerFrame:0.04f resize:NO restore:NO];
        
        NSString *particleRampUpPath = [[NSBundle mainBundle] pathForResource:@"PreBrickExplosion" ofType:@"sks"];
        SKEmitterNode *particleRampUp = [NSKeyedUnarchiver unarchiveObjectWithFile:particleRampUpPath];
        
        particleRampUp.position = CGPointMake(0, 0);
        particleRampUp.zPosition = 0;
        
        SKAction *actionParticleRampUp = [SKAction runBlock:^{
            [block addChild:particleRampUp];
        }];
        
        // Group actions
        SKAction *actionRampUpGroup = [SKAction group:@[actionAudioRampUp, actionParticleRampUp, actionVisualRampUp]];
    } else if (([nameA containsString:@"Fence"] && [nameB containsString:@"Ball"]) || ([nameA containsString:@"Ball"] && [nameB containsString:@"Fence"]) ) {
        
        SKAction *fenceAudio = [SKAction playSoundFileNamed:@"body-wall-impact.wav" waitForCompletion:NO];
        [self runAction:fenceAudio];
        
        // You missed the ball - Game Over
        if (10 > contact.contactPoint.y) {
            
            SKView *skView = (SKView *)self.view;
            [self removeFromParent];
            
            // Create and configure the scene
            GameOver *gameOverScene = [GameOver nodeWithFileNamed:@"GameOver"];
            gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene
            [skView presentScene:gameOverScene];
        }
    } else if (([nameA containsString:@"Ball"] && [nameB containsString:@"Paddle"]) || ([nameA containsString:@"Paddle"] && [nameB containsString:@"Ball"]) ) {
        
        SKAction *paddleAudio = [SKAction playSoundFileNamed:@"ping-pong-ball-hit.wav" waitForCompletion:NO];
        [self runAction:paddleAudio];
    }
    
    NSLog(@"What collided ? %@ %@", nameA, nameB);
}

@end
