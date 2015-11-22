//
//  StatisticsCalc.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 10/15/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "StatisticsCalc.h"

@implementation StatisticsCalc

- (float) average:(NSArray *)numbers {
    int sum = 0;
    NSUInteger count = 0;
    float average;
    count = (int) numbers.count;
    for (NSNumber *sample in numbers) {
        sum += sample.floatValue;
    }

    average = ((float)sum)/(float)count;
    return average;
}

- (float) sum: (NSArray *)array1 {
    float sum = 0;
    
    for (NSNumber *number in array1) {
        sum += number.floatValue;
    }
    
    return sum;
}

- (float) square: (float)num {return powf(num, 2.0);}

- (NSArray *)squareArray: (NSArray *)array {
    NSMutableArray *resultArray = [array mutableCopy];
    
    for (int i = 0; i < resultArray.count; i++) { // square array
        NSNumber *number = resultArray[i];
        float numSquared = [self square:number.floatValue];
        resultArray[i] = [NSNumber numberWithFloat:numSquared];
    }

    return resultArray;
}

- (float) correlation: (NSArray *)array1 array2:(NSArray *)array2 {
    NSArray *squareArray1 = [self squareArray: array1.copy];
    NSArray *squareArray2 = [self squareArray: array2.copy];
    
    float count1 = squareArray1.count;
    float count2 = squareArray2.count;
    
    
    
    NSMutableArray *array = [NSMutableArray new];
    
    return 2.0;
}

- (float) median:(NSArray *)array {
    NSMutableArray *trialArray = [array mutableCopy];
    [trialArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (((NSNumber *) obj1).floatValue < ((NSNumber *) obj2).floatValue) {
            return NSOrderedAscending;
        } else if (((NSNumber *) obj1).floatValue > ((NSNumber *) obj2).floatValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    float resultNum;
    
    if (!(trialArray.count % 2)) { // if count is even
        float num1 = ((NSNumber *)trialArray[trialArray.count/2 -1]).floatValue;
        float num2 = ((NSNumber *)trialArray[(trialArray.count/2)]).floatValue;
        
        resultNum = (num1 + num2)/2.0;
    } else { // if count is odd
        resultNum = ((NSNumber *)trialArray[(trialArray.count-1)/2]).intValue;
    }
    return resultNum;
}

- (float) standardDeviation:(NSArray *)array {
    float standardDeviation;
    NSMutableArray *devsFromAvg = [NSMutableArray new];
    float average = [self average:array];
    
    for (NSNumber *number in array) {
        [devsFromAvg addObject:[NSNumber numberWithFloat:powf((number.floatValue - average), 2)]];
    }
    
    float sum = 0;
    for (NSNumber *num in devsFromAvg) {
        float floatNum = num.floatValue;
        sum += floatNum;
    }
    
    standardDeviation = powf((sum/(devsFromAvg.count - 1)), .5);
    return standardDeviation;
}

- (float) mode:(NSArray *)array {
    NSMutableDictionary *modeCalcDict = [NSMutableDictionary new];
    for (NSNumber *num in array) {
        if (![modeCalcDict objectForKey:num]) {
            modeCalcDict[num] = @1;
        } else {
            modeCalcDict[num] = [NSNumber numberWithInt: ((NSNumber *)modeCalcDict[num]).intValue + 1];
        }
    }
    
    NSNumber *mode = [NSNumber numberWithInt:0];
    
    for (NSNumber *key in modeCalcDict) {
        if (((NSNumber *) modeCalcDict[key]).intValue > mode.intValue) {
            mode = key;
        }
    }
    
    int mostOccurences = 0;
    int mostCommonNumber = 0;
    
    for (NSNumber *num in modeCalcDict) {
        if (mostOccurences < ((NSNumber *)[modeCalcDict objectForKey:num]).intValue) {
            mostCommonNumber = ((NSNumber *)[modeCalcDict objectForKey:num]).intValue;
            mostOccurences = num.intValue;
        }
    }
    
    return mostCommonNumber;
}

@end
