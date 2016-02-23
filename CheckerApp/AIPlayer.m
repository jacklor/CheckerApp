//
//  AIPlayer.m
//  CheckerApp
//
//  Created by Jack Lor on 2/23/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#include <stdlib.h>

#import "AIPlayer.h"
#import "GameManager.h"
#import "Pion.h"

@implementation AIPlayer

- (void)playTurn
{
    if (self.gameManager.jumpOption.count == 0)
    {
        for (int y = 0; y < CHECKER_SIZE; y++)
        {
            for (int x = 0; x < CHECKER_SIZE; x++)
            {
                id content = self.gameManager.checkerContent[y][x];
                if (content != [NSNull null])
                {
                    Pion *pion = content;
                    if (pion.pionColor == self.playerNumber)
                    {
                        NSIndexPath *currentPath = [NSIndexPath indexPathForRow:x inSection:y];
                        [self.gameManager createAvailablePlay:currentPath jumped:NO];
                        if (self.gameManager.availablePlay.count > 0)
                        {
                            self.gameManager.selectedPion = currentPath;
                            NSUInteger r = arc4random_uniform((int32_t)self.gameManager.availablePlay.count);
                            NSIndexPath *indexPath = self.gameManager.availablePlay[r];
                            [self.gameManager movePion:indexPath];
                            return;
                        }
                    }
                }
            }
        }
    }
    else
    {
        NSUInteger r = arc4random_uniform((int32_t)self.gameManager.availablePlay.count);
        NSIndexPath *indexPath = self.gameManager.availablePlay[r];
        [self.gameManager movePion:indexPath];
    }
}

@end
