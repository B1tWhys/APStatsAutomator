//
//  StatisticsCalc.h
//  APStatsSolver
//
//  Created by Skyler Arnold on 10/15/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsCalc : NSObject
- (float) average:(NSArray *)numbers;
- (float) median:(NSArray *)array;
- (float) standardDeviation:(NSArray *)array;
- (float) mode:(NSArray *)array;
- (float) correlation: (NSArray *)array1 array2:(NSArray *)array2;
@end
