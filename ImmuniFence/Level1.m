//
//  Level1.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Level1.h"
#import "BitMasks.h"

//CLASSES AINDA NÃO IMPLEMENTADAS
//#import "Wave.h"
//#import "Terrain.h"
//#import "Creep.h"
//#import "Tower.h"


//TODO  implementar o ingame menu
//TODO  implementar a pausa do jogo.
//TODO  refazer o caminho lógico do jogo, a maioria dos métodos está incompleta.
//TODO  ainda não está se adicionando as waves subsequentes, tem que acertar a questão do tempo


@implementation Level1{
    
    int coins;
    int health;
    int killCount;      //Acho que será desnecessário. O jogo acaba qnd n tem mais creeps ativos e nao tem mais waves, ou quando acaba a vida
    int actualWave;
    LevelWaves *levelOneWaves;
    NSMutableArray *towerSpots;
    NSMutableArray *activeCreeps;
    SKAction *followLine;
    NSTimeInterval *timeOfLastMove;
}


/*****************************
 *
 *  Métodos de SKScene
 *
 ***/

-(void) didMoveToView:(SKView *)view{
      
        //inicializa as variáveis da fase
        coins = 90;
        health = 20;
        killCount = 0;
        actualWave = 0;
        
        //se registra como delegate de contato para tratar das colisões
        self.physicsWorld.contactDelegate = self;
        
        //define o mapa da fase
        Terrain* levelOneTerrain = [Terrain terrainForLevel: LevelOne];
        SKSpriteNode* map = [SKSpriteNode spriteNodeWithImageNamed: levelOneTerrain.map];
        map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild: map];
        
        
        //cria o HUD do jogo
        [self createHUD];
        
        //cria os placeholders para criar as torres
        towerSpots = levelOneTerrain.towerSpots;
        for (NSInteger i = towerSpots.count; i>=0; i--) {
            
            NSValue *getPoint = [towerSpots objectAtIndex:i];
            CGPoint towerSpot = [getPoint CGPointValue];
            
            SKSpriteNode *towerSpawnPoint = [SKSpriteNode spriteNodeWithColor: [SKColor blackColor] size: CGSizeMake(125, 125)];
            towerSpawnPoint.hidden = YES;
            towerSpawnPoint.name = @"towerSpawnPoint";
            
            //TODO Pode dar merda pq a posição tem que ser de acordo com o sistema de coordenadas do pai. Conferir isso.
            towerSpawnPoint.position = towerSpot;
        }
        
        //cria a ação para percorrer o caminho
        followLine = [SKAction followPath: levelOneTerrain.path asOffset:NO orientToPath:YES duration:50];//TODO no futuro, usar a chamada do método com velocity ou invés de duration
        
        
        //cria a primeira wave do level
        levelOneWaves = [LevelWaves waveForLevel: LevelOne];
        
        //instancia os creeps da primeira wave e os guarda no vetor de creeps
        activeCreeps = [[NSMutableArray alloc] init];
        [activeCreeps addObjectsFromArray:[levelOneWaves createCreepsForWave: actualWave]]; //TODO quando vc manda as creeps seguirem um path, elas não precisam de uma position. Começam na inicial do path
        
        for (NSInteger i = activeCreeps.count; i>=0; i--) {
            
            SKSpriteNode *creep = (SKSpriteNode*) [activeCreeps objectAtIndex:i];
            [self addChild: creep];
            
            [creep runAction: followLine completion: ^{
                [self discountHealth: creep]; //se eu entendi Blocks direito, ele vai manter a referencia para o creep.
                NSLog(@"Creep has trespassed the line");
            }];
        }
        
        //incrementa o contador de waves
        actualWave++;
}


//IMPLEMENTAÇÃO INCOMPLETA
//A cada novo frame, confere se as torres possuem um alvo. Se sim, atira.
//TODO esse método tem que contar o tempo necessário para adicionar a próxima wave de creeps
-(void) update:(NSTimeInterval)currentTime{

    //TODO 0.5 é o tempo de tiro da torre. Tem que mudar isso, cada torre com uma velocidade.
    //Se estiver com problema, pode ser a sintaxe dessa merda. Aí é só copiar do DEMO.
    if (currentTime - timeOfLastMove >= 0.5){
    
        [self enumerateChildNodesWithName:@"tower" usingBlock:^(SKNode *node, BOOL *stop) {
          
            Tower *tower = (Tower *) node;

            CreepNode *target = [tower.targets objectAtIndex:0];
            
            if (target.health <= 0) {
            
                [tower.targets removeObjectAtIndex:0];
            }
            else {
                [tower shootAtTarget:target];
            }
        }];
        
        timeOfLastMove = currentTime;
    }
}


/*****************************************************
 *
 *  Métodos de SKPhysicsContactDelegate
 *
 *  Utilizados para tratar as colisões entre os nós.
 *  No caso, um creep entrando no alcance de uma torre
 *  ou um projétil de torre acertando um creep
 *
 ***/

-(void) didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    
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
    if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == TowerMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node;
        [tower.targets addObject:creep];
        
    }else if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == BulletMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node.parent;
        
        if (creep.health > 0) {
            
            [tower damageEnemy:creep onKill:^{
                [self didKillEnemy: creep.reward];
            }];
        }

}

-(void) didEndContact:(SKPhysicsContact *) contact{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){

        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == TowerMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node;
        [tower.targets removeObject:creep];
    }
}


/**************************************************
 *
 *  Métodos de UIResponder
 *  
 *  Utilizados para tratar da interação do usuário
 *  com a interface do jogo
 *
 ***/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];

}

//IMPLEMENTAÇÃO INCOMPLETA
-(void)selectNodeForTouch:(CGPoint)touchLocation{
    
//    SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
//    
//    if ([touchedNode.name isEqualToString: @"towerSpawnPoint"]) {
//        
//        Tower *newTower = [Tower createTowerOfType TowerOne];
//        newTower.position = touchedNode.position;
//        
//        [towerSpots removeObject:touchedNode];
//        
//    }
//    else if (touchedNode.name isEqualToString: @"tower"){
//        
//    }
}


/***************************************
 *
 *  Métodos Auxiliares
 *
 ***/

//cria os indicadores de vida e moedas
//TODO o HUD deve ser uma classe (ou várias) específicas, para encapsular a arte
//TODO posicioná-los usando proporções, não hardcoded
-(void) createHUD{
    
    //cria o indicador de vida
    SKSpriteNode *healthIndicator = [SKSpriteNode spriteNodeWithImageNamed:@"health_hud"];
    healthIndicator.position = CGPointMake(10,CGRectGetMaxY(self.frame)-50);
    healthIndicator.anchorPoint = CGPointMake(0, 0);
    healthIndicator.name = @"health_hud";

    //Cria label de vida
    SKLabelNode *healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    healthLabel.fontSize = 14;
    healthLabel.fontColor = [SKColor blackColor];
    healthLabel.position = CGPointMake(10+healthIndicator.frame.size.width/2, healthIndicator.frame.size.height/2);
    healthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    healthLabel.name = @"healthLabel";
    
    [healthIndicator addChild:healthLabel];
    [self addChild: healthIndicator];
    
    //Cria o indicador de moedas
    SKSpriteNode *coinIndicator = [SKSpriteNode spriteNodeWithImageNamed:@"coin_hud"];
    coinIndicator.position = CGPointMake(130,CGRectGetMaxY(self.frame)-50);
    coinIndicator.anchorPoint = CGPointMake(0, 0);
    coinIndicator.name = @"coin_hud";
    
    //Cria label de coins
    SKLabelNode *coinLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    coinLabel.text = [NSString stringWithFormat:@"%d", coins];
    coinLabel.fontSize = 14;
    coinLabel.fontColor = [SKColor blackColor];
    coinLabel.position = CGPointMake(10+coinIndicator.frame.size.width/2, coinIndicator.frame.size.height/2);
    coinLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    coinLabel.name = @"coinLabel";
    
    [coinIndicator addChild:coinLabel];
    [self addChild: healthIndicator];

}

//chamado quando um creep atravessa a linha de defesa.
//TODO no futuro, esse método deve penalizar o jogador caso muitos creeps ultrapassem.
//TODO conferir se é aqui mesmo que tem que liberar o CGMutablePath da memória
-(void)discountHealth: (SKSpriteNode *) creep{
    
    //TODO tem que conferir se esse typecast aqui não vai dar merda
    health -= (Creep *)creep.damage;
    
    //Se a vida zerar, é Game Over
    if (health <= 0){
        
        NSLog(@"Game Over");
        GameOver *gameOver = [GameOver sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
        [self.view presentScene:gameOver transition:transition];
    }
    
    //Atualiza o HUD
    [self updateHealthIndicator];
    //retira o creep da cena
    [creep removeFromParent];
    //retira o creep da relação de creeps vivos
    [activeCreeps removeObject: creep];
    
    //Se não há creeps ativos e acabaram as waves
    if (activeCreeps.count == 0 && actualWave == [levelOneWaves numberOfWaves]){
        
        //TODO game win
    }

}

-(void) updateHealthIndicator{
    
    SKLabelNode *healthLabel = (SKLabelNode*)[self childNodeWithName:@"healthLabel"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    NSLog(@"Health Updated");
}

-(void) updateCoinsIndicator{
    
    SKLabelNode *coinsLabel = (SKLabelNode*)[self childNodeWithName:@"coinLabel"];
    coinsLabel.text = [NSString stringWithFormat:@"%d", coins];
    NSLog(@"Coins Updated");
}

//AQUI TEM QUE CONFERIR SE TODOS OS CREEPS DA WAVE ANTERIOR MORRERAM
-(void) didKillEnemy: (int) reward {

    //incrementa as coins
    coins += reward;
    [self updateCoinsIndicator];
    
    //contabiliza o número de inimigos mortos
    killCount++;

}
    
//    
//    [self enumerateChildNodesWithName:@"movable" usingBlock:^(SKNode *node, BOOL *stop) { //acha tds os nodes chamados movable (torres da barra inferior direta) e executa o bloco para cada uma delas
//        NSInteger cost = [[node.userData objectForKey:@"cost"] intValue]; //descobre o custo da torre
//        SKSpriteNode *towerIcon = (SKSpriteNode*) node;
//        if (cost <= self.coins) {                           //se torre custar menos do que o placar, clareia o ícone dela
//            [towerIcon setColorBlendFactor:0];
//        }else {                                         //do contrário, escurece
//            [towerIcon setColorBlendFactor:0.8];
//        }
//    }];
//    
//    //TODO ADD IMAGEM DE GAME WIN
//    if (++self.killCount >= 20) {
//        
//        NSLog(@"You Win");
//        GameWin *gameWin = [GameWin sceneWithSize:self.frame.size];
//        SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
//        [self.view presentScene:gameWin transition:transition];
//        
//    }
//}
@end
