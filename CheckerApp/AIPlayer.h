//
//  AIPlayer.h
//  CheckerApp
//
//  Created by Jack Lor on 2/23/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameManager;

@interface AIPlayer : NSObject

@property NSInteger playerNumber;
@property (nonatomic, weak) GameManager *gameManager;

- (void)playTurn;

@end
