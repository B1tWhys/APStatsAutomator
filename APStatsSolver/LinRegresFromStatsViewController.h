//
//  LinRegresFromStatsViewController.h
//  APStatsSolver
//
//  Created by Skyler Arnold on 11/10/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinRegresFromStatsViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic) BOOL usePassedInValuesForAvgCorrelationAndStandardDeviation;
@property (nonatomic) float correlation;
@property (nonatomic) float avgX;
@property (nonatomic) float avgY;
@property (nonatomic) float stdX;
@property (nonatomic) float stdY;
@end
