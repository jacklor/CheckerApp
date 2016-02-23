//
//  CheckerCell.m
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CheckerCell.h"

@implementation CheckerCell

- (void)awakeFromNib
{
    self.piece.layer.cornerRadius = self.piece.frame.size.height * 0.5;
    self.piece.layer.masksToBounds = YES;
}

@end
