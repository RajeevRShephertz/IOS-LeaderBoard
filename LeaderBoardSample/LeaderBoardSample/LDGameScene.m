//
//  LDGameScene.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDGameScene.h"
#import "LDGameOverScene.h"

@implementation LDGameScene {
    
    SKSpriteNode *ship;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    SKAction *blinkAction;
    SKLabelNode *lifeLabel;

    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lastMissileAdded;
    __block int _blinkCount;
    
    int _shipTextureCounter;

    
}


static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;

static const float BG_Velocity = 5.0;
static const float Obj_velocity = 160.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiply(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        lifes = 3;
        passedObstacleCount = 0;
        _shipTextureCounter = 1;
        _blinkCount = 0;
        [self initalizingScrollingBackground];
        [self addShip];
        [self addLifeLabel];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
    }
    
    return self;
}

- (void) addLifeLabel {
    lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lifeLabel.fontSize = 20;
    lifeLabel.fontColor = [SKColor whiteColor];
    lifeLabel.position = CGPointMake(self.size.width/2, self.size.height - 25);
    [self addChild:lifeLabel];
    
    [self updateLifeLable];
}

-(void)addShip
{
    //initalizing spaceship node
    ship = [SKSpriteNode spriteNodeWithImageNamed:@"f1"];
    
    //Adding SpriteKit physicsBody for collision detection
    ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ship.size];
    ship.physicsBody.categoryBitMask = shipCategory;
    ship.physicsBody.dynamic = YES;
    ship.physicsBody.contactTestBitMask = obstacleCategory;
    ship.physicsBody.collisionBitMask = 0;
    ship.physicsBody.usesPreciseCollisionDetection = YES;
    ship.name = @"ship";
    ship.position = CGPointMake(120,160);
    actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    blinkAction  = [SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeOutWithDuration:0.2],[SKAction fadeInWithDuration:0.2], nil]];

    [self addChild:ship];
}

-(void)addMissile
{
    //initalizing spaceship node
    SKSpriteNode *obstacle;
    int ran = arc4random() % 4 + 1; //1-4 range;
    NSString *name = [NSString stringWithFormat:@"e_f%d",ran];
    obstacle = [SKSpriteNode spriteNodeWithImageNamed:name];
    
    //Adding SpriteKit physicsBody for collision detection
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    obstacle.physicsBody.dynamic = YES;
    obstacle.physicsBody.contactTestBitMask = shipCategory;
    obstacle.physicsBody.collisionBitMask = 0;
    obstacle.physicsBody.usesPreciseCollisionDetection = YES;
    obstacle.name = @"obstacle";
    
    //selecting random y position for missile
    int r = arc4random() % (int)self.frame.size.height;
    obstacle.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:obstacle];
}


- (void) blinkShip {
    [ship runAction:blinkAction completion:^{
        if (_blinkCount > 0) {
            _blinkCount --;
            [self blinkShip];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    if(touchLocation.y >ship.position.y){
        [ship runAction:actionMoveUp];
    }else{
        [ship runAction:actionMoveDown];
    }
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        [bg setSize:CGSizeMake(bg.size.width, self.frame.size.height)];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         if (![node isEqual:lifeLabel]) {
             SKSpriteNode * bg = (SKSpriteNode *) node;
             CGPoint bgVelocity = CGPointMake(-BG_Velocity*bg.size.width/100, 0);
             CGPoint amtToMove = CGPointMultiply(bgVelocity,_dt);
             bg.position = CGPointAdd(bg.position, amtToMove);
             
             //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
             if (bg.position.x <= -bg.size.width)
             {
                 bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                           bg.position.y);
             }
         }
     }];
}

- (void)moveObstacle
{
    NSArray *nodes = self.children;//1
    
    for(SKNode * node in nodes){
        if (![node.name  isEqual: @"bg"] && ![node.name  isEqual: @"ship"] && ![node isEqual:lifeLabel]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            CGPoint obVelocity = CGPointMake(-Obj_velocity, 0);
            CGPoint amtToMove = CGPointMultiply(obVelocity,_dt);
            
            ob.position = CGPointAdd(ob.position, amtToMove);
            if(ob.position.x < -100)
            {
                [ob removeFromParent];
                passedObstacleCount++;
            }
        }
    }
}

- (void) updateLifeLable {
    if (lifes <= 1) {
        [lifeLabel setText:[NSString stringWithFormat:@"Life Left:%d",lifes]];
    } else {
        [lifeLabel setText:[NSString stringWithFormat:@"Lives Left:%d",lifes]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if( currentTime - _lastMissileAdded > 0.1)
    {
        _lastMissileAdded = currentTime + 1;
        [self addMissile];
    }
    
    _shipTextureCounter ++;
    if (_shipTextureCounter > 4) {
        _shipTextureCounter = 1;
    }
    
    [ship setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"f%d",_shipTextureCounter]]];
    
    [self moveBg];
    [self moveObstacle];
    
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & shipCategory) != 0 &&
        (secondBody.categoryBitMask & obstacleCategory) != 0)
    {
        lifes --;
        
        if (lifes > 0) {
            _blinkCount  =3;
            [self updateLifeLable];
            [self blinkShip];
        } else {
            [ship removeFromParent];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            LDGameOverScene * gameOverScene = [[LDGameOverScene alloc] initWithSize:self.size];
            gameOverScene.obstacleCount = passedObstacleCount;
            [gameOverScene initializeGameOverView];
            [self.view presentScene:gameOverScene transition: reveal];
        }
        
    }
}

@end
