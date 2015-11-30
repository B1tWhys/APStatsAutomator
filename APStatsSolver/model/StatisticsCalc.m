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
- (float) sqrt: (float) num {return powf(num, .5);}

- (NSArray *)squareArray: (NSArray *)array {
    NSMutableArray *resultArray = [array mutableCopy];
    
    for (int i = 0; i < resultArray.count; i++) { // square array
        NSNumber *number = resultArray[i];
        float numSquared = [self square:number.floatValue];
        resultArray[i] = [NSNumber numberWithFloat:numSquared];
    }

    return resultArray;
}


// equation for correlation coefficient
// http://mathbits.com/MathBits/TISection/Statistics2/correlation.htm
- (float) correlation: (NSArray *)arrayX array2:(NSArray *)arrayY {
    NSArray *squareArrayX = [self squareArray: arrayX.copy];
    NSArray *squareArrayY = [self squareArray: arrayY.copy];
    
    float count = squareArrayX.count;
    float countY = squareArrayY.count;
    NSAssert(count == countY, @"The length of the X variables array was %f, but the length of the Y array was %f", count, countY);
    
    
    float sumX = [self sum:arrayX];
    float sumY = [self sum:arrayY];
    
    float sumXYProduct = 0;
    for (int i = 0; i < count; i++) {
        sumXYProduct += ((NSNumber *)arrayX[i]).floatValue * ((NSNumber *)arrayY[i]).floatValue;
    }
    
    float sumOfSquaresX = [self sum:squareArrayX];
    float sumOfSquaresY = [self sum:squareArrayY];
    
    float sumSquaredX = [self square:sumX];
    float sumSquaredY = [self square:sumY];
    
    float numerator = (count*sumXYProduct) - (sumX * sumY);
    float denominatorLeftTerm = [self sqrt:((count * sumOfSquaresX) - sumSquaredX)];
    float denominatorRightTerm = [self sqrt:((count * sumOfSquaresY) - sumSquaredY)];
    
    float denominator = denominatorLeftTerm * denominatorRightTerm;
    
    float correlation = numerator/denominator;
    
    return correlation;
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
