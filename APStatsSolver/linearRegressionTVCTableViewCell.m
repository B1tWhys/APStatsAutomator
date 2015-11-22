//
//  linearRegressionTVCTableViewCell.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 11/6/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "linearRegressionTVCTableViewCell.h"

@implementation linearRegressionTVCTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)xValFieldChanged:(UITextField *)sender {
    NSString *fieldString = sender.text;
    float xValFloat = [fieldString floatValue];
    self.xVal = xValFloat;
}

- (IBAction)yValFieldChanged:(UITextField *)sender {
    NSString *fieldString = sender.text;
    float yValFloat = [fieldString floatValue];
    self.yVal = yValFloat;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
