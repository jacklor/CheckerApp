//
//  GameManager.h
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AIPlayer.h"

#define CHECKER_SIZE 8

@interface GameManager : NSObject

@property NSInteger playerTurn;
@property (nonatomic, strong) NSMutableArray *checkerContent;
@property (nonatomic, strong) NSMutableArray *availablePlay;
@property (nonatomic, strong) NSMutableArray *jumpOption;

@property (nonatomic, strong) UICollectionView *gameView;

@property (nonatomic, strong) NSIndexPath *selectedPion;
@property (nonatomic, strong) AIPlayer *AIPlayer;

+ (GameManager *)sharedInstance;

- (void)createAvailablePlay:(NSIndexPath *)indexPath jumped:(BOOL)jumped;
- (void)movePion:(NSIndexPath *)indexPath;

@end
