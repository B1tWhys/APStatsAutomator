//
//  ViewSimulationResultsViewController.m
//  
//
//  Created by Sky Arnold on 8/29/15.
//
//

#import "ViewSimulationResultsViewController.h"

@interface ViewSimulationResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;
@end

@implementation ViewSimulationResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableArray *fullArray = [NSMutableArray new];

    for (NSMutableArray *array in self.dataArray) {
        if (array.count != 0) {
            [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if (obj1 < obj2) {
                    return NSOrderedAscending;
                } else if (obj1 > obj2) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            [fullArray addObject:array];
        }
    }
    
    self.dataArray = fullArray;

    [self.navigationController setNavigationBarHidden:false];
}

- (BOOL)dataIsDatasource {
    return self.viewSelector.selectedSegmentIndex == 0 ? true : false;
}

- (IBAction)switchBetweenScreens:(id)sender {
    UIViewAnimationOptions transitionType = self.dataIsDatasource ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    [UIView transitionWithView:self.tableView
                      duration:.5
                       options:transitionType
                    animations:^{
                           [self.tableView reloadData];
                    } completion:^(BOOL finished) {}];
}

- (float) average:(NSArray *)numbers {
    int sum = 0;
    NSUInteger count = 0;
    float average;
    count = (int) numbers.count;
    for (NSNumber *sample in numbers) {
        sum += sample.intValue;
    }
    
    average = ((float)sum)/(float)count;
    return average;
}

- (float) median:(NSArray *)array {
    NSMutableArray *trialArray = [array mutableCopy];
    [trialArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (obj1 < obj2) {
            return NSOrderedAscending;
        } else if (obj1 > obj2) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tvc = [tableView dequeueReusableCellWithIdentifier:@"StatsViewerTableViewCell"];
    if (!tvc) tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsViewerTableViewCell"];
    
    if (self.dataIsDatasource) {
        NSArray *trialDataArray = [self.dataArray objectAtIndex:indexPath.section];
        NSArray *trialResultsArray = nil;
        if (self.resultsArray.count != 0) {
            trialResultsArray = [self.resultsArray objectAtIndex:indexPath.section];
        }
        
        int dataForCell = ((NSNumber *)[trialDataArray objectAtIndex: indexPath.row]).intValue;
        NSString *resultForCell = [trialResultsArray objectAtIndex:indexPath.row];
        
        NSString *cellString;

        if (trialResultsArray != nil) {
            cellString = [NSString stringWithFormat:@"%i - %@", dataForCell, resultForCell];
        } else {
            cellString  = [NSString stringWithFormat:@"%i", dataForCell];
        }
        tvc.textLabel.text = cellString;
    } else {
        NSString *cellText;
        
        switch (indexPath.row) {
            case 0: { // avg
                cellText = [NSString stringWithFormat:@"Average: %@", [NSNumber numberWithFloat:[self average:self.dataArray[indexPath.row]]].stringValue];
                break;
            } case 1: { // st. dev
                float standardDeviation;
                NSMutableArray *devsFromAvg = [NSMutableArray new];
                float average = [self average:self.dataArray[indexPath.section]];

                for (NSNumber *number in self.dataArray[indexPath.section]) {
                    [devsFromAvg addObject:[NSNumber numberWithFloat:powf((number.floatValue - average), 2)]];
                }
                
                float sum = 0;
                for (NSNumber *num in devsFromAvg) {
                    float floatNum = num.floatValue;
                    sum += floatNum;
                }
                
                standardDeviation = powf((sum/(devsFromAvg.count - 1)), .5); // TODO: change this to be accurate
                cellText = [NSString stringWithFormat:@"Standard deviation: %@", [NSNumber numberWithFloat:standardDeviation].stringValue];
                break;
            } case 2: { // q1
                NSMutableArray *trialArray = [self.dataArray[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                
                NSRange firstHalfRange = NSMakeRange(0, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q1 = [self median:firstHalfArray];
                cellText = [NSString stringWithFormat:@"q1: %@", [NSNumber numberWithFloat:q1].stringValue];
                break;
            } case 3: { // median
                NSMutableArray *trialArray = [self.dataArray[indexPath.section] mutableCopy];
                
                float resultNum;
                resultNum = [self median:trialArray];
                
                cellText = [NSString stringWithFormat:@"Median: %@", [NSNumber numberWithFloat:resultNum].stringValue];
                break;
            } case 4: { // q3
                NSMutableArray *trialArray = [self.dataArray[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                NSUInteger startPosition = ((trialArray.count % 2) == 0) ? (int)((trialArray.count) / 2) : ((trialArray.count - 1) /2);
                
                NSRange secondHalfRange = NSMakeRange(startPosition, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:secondHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q3 = [self median:firstHalfArray];
                cellText = [NSString stringWithFormat:@"q3: %@", [NSNumber numberWithFloat:q3].stringValue];
                break;
            } case 5: { // IQR
                NSMutableArray *trialArray = [self.dataArray[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                
                
                NSRange firstHalfRange = NSMakeRange(0, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q1 = [self median:firstHalfArray];
                
                length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                NSUInteger startPosition = ((trialArray.count % 2) == 0) ? (int)((trialArray.count - 1) / 2) : (trialArray.count/2);
                
                firstHalfRange = NSMakeRange(startPosition, length);
                indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q3 = [self median:firstHalfArray];
                
                float IQR = q3-q1;
                cellText = [NSString stringWithFormat:@"IQR: %@", [NSNumber numberWithFloat:IQR].stringValue];
                
                break;
                
            } case 6: { // mode
                NSMutableDictionary *modeCalcDict = [NSMutableDictionary new];
                for (NSNumber *num in self.dataArray[indexPath.section]) {
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
                
                cellText = [NSString stringWithFormat:@"Mode: %i", mostCommonNumber];
                break;
            }
            default:
                break;
        }
        
        tvc.textLabel.text = cellText;
    }
    
    tvc.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tvc;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.dataArray objectAtIndex:section];
    int numberOfRowsInSection = (int)sectionArray.count;
    
    if (self.dataIsDatasource) {
        return numberOfRowsInSection;
    } else {
        if (self.calcMode) {
            return 7;
        } else {
            return 6;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Trial: %i", (int)section + 1];
}

@end
