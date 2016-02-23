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
    self.piece.layer.borderColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5].CGColor;
}

@end
