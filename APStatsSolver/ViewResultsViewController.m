//
//  ViewSimulationResultsViewController.m
//  
//
//  Created by Sky Arnold on 8/29/15.
//
//

#import "ViewResultsViewController.h"
#import "StatisticsCalc.h"

@interface ViewResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;
@property (strong, nonatomic) StatisticsCalc *calc;
@end

const int numOfInfoCells = 9;

@implementation ViewResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableArray *fullArray = [NSMutableArray new];

    for (NSMutableArray *array in self.dataArray1) {
        if (array.count != 0) {
            [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if (((NSNumber *) obj1).floatValue < ((NSNumber *) obj2).floatValue) {
                    return NSOrderedAscending;
                } else if (((NSNumber *) obj1).floatValue > ((NSNumber *) obj2).floatValue) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            [fullArray addObject:array];
        }
    }
    
    self.calc = [[StatisticsCalc alloc] init];
    
//    self.dataArray1 = @[@26, @49, @68, @3, @59, @89, @63, @64, @57, @50, @9, @80, @17, @5, @86, @27, @8, @6, @99, @94, @25].mutableCopy;
//    self.dataArray2 = @[@26, @49, @68, @3, @59, @89, @63, @64, @57, @50, @9, @80, @17, @5, @86, @27, @8, @6, @99, @94, @25].mutableCopy;
//
//    float testCorrelation = [self.calc correlation:testXArray array2:testYArray];
//    
    self.dataArray1 = fullArray;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tvc = [tableView dequeueReusableCellWithIdentifier:@"StatsViewerTableViewCell"];
    if (!tvc) tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsViewerTableViewCell"];
    
    if (self.dataIsDatasource) {
        NSArray *trialDataArray = [self.dataArray1 objectAtIndex:indexPath.section];
        NSArray *trialResultsArray = nil;
        if (self.resultsArray.count != 0) {
            trialResultsArray = [self.resultsArray objectAtIndex:indexPath.section];
        }
        
        float dataForCell = ((NSNumber *)[trialDataArray objectAtIndex: indexPath.row]).floatValue;
        NSString *resultForCell = [trialResultsArray objectAtIndex:indexPath.row];
        
        NSString *cellString;

        if (trialResultsArray != nil) {
            cellString = [NSString stringWithFormat:@"%@ - %@", [NSNumber numberWithFloat: dataForCell].stringValue, resultForCell];
        } else {
            cellString  = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat: dataForCell].stringValue];
        }
        tvc.textLabel.text = cellString;
    } else {
        NSString *cellText;
        
        switch (indexPath.row) {
            case 0: { // avg
                cellText = [NSString stringWithFormat:@"Average: %@", [NSNumber numberWithFloat:[self.calc average:self.dataArray1[indexPath.row]]].stringValue];
                break;
            } case 1: { // st. dev
                float standardDeviation = [self.calc standardDeviation:self.dataArray1[indexPath.section]];
                cellText = [NSString stringWithFormat:@"Standard deviation: %@", [NSNumber numberWithFloat:standardDeviation].stringValue];
                break;
            } case 2: { // q1
                NSMutableArray *trialArray = [self.dataArray1[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)+1) : (int)((trialArray.count + 1) / 2);
                
                NSRange firstHalfRange = NSMakeRange(0, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q1 = [self.calc median:firstHalfArray];
                cellText = [NSString stringWithFormat:@"q1: %@", [NSNumber numberWithFloat:q1].stringValue];
                break;
            } case 3: { // median
                NSMutableArray *trialArray = [self.dataArray1[indexPath.section] mutableCopy];
                
                float resultNum = [self.calc median:trialArray];
                
                cellText = [NSString stringWithFormat:@"Median: %@", [NSNumber numberWithFloat:resultNum].stringValue];
                break;
            } case 4: { // q3
                NSMutableArray *trialArray = [self.dataArray1[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                NSUInteger startPosition = ((trialArray.count % 2) == 0) ? (int)((trialArray.count) / 2) : ((trialArray.count - 1) /2);
                
                NSRange secondHalfRange = NSMakeRange(startPosition, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:secondHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q3 = [self.calc median:firstHalfArray];
                cellText = [NSString stringWithFormat:@"q3: %@", [NSNumber numberWithFloat:q3].stringValue];
                break;
            } case 5: { // IQR
                NSMutableArray *trialArray = [self.dataArray1[indexPath.section] mutableCopy];
                NSUInteger length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                
                
                NSRange firstHalfRange = NSMakeRange(0, length);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                NSArray *firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q1 = [self.calc median:firstHalfArray];
                
                length = ((trialArray.count % 2) == 0) ? ((int)(trialArray.count/2)) : (int)((trialArray.count + 1) / 2);
                NSUInteger startPosition = ((trialArray.count % 2) == 0) ? (int)((trialArray.count - 1) / 2) : (trialArray.count/2);
                
                firstHalfRange = NSMakeRange(startPosition, length);
                indexSet = [NSIndexSet indexSetWithIndexesInRange:firstHalfRange];
                firstHalfArray = [trialArray objectsAtIndexes:indexSet];
                
                float q3 = [self.calc median:firstHalfArray];
                
                float IQR = q3-q1;
                cellText = [NSString stringWithFormat:@"IQR: %@", [NSNumber numberWithFloat: IQR].stringValue];
                
                break;
                
            } case 6: { // mode
                float mostCommonNumber = [self.calc mode:self.dataArray1[indexPath.section]];
                
                cellText = [NSString stringWithFormat:@"Mode: %f", mostCommonNumber];
                break;
            } case 7: { // correlation
                float correlation = [self.calc correlation:self.dataArray1[indexPath.section] array2:self.dataArray2[indexPath.section]];
                cellText = [NSString stringWithFormat:@"r = %@", [NSNumber numberWithFloat: correlation].stringValue];
                break;
            } case 8: {
                float correlation = [self.calc correlation:self.dataArray1[indexPath.section] array2:self.dataArray2[indexPath.section]];
                float rSquared = powf(correlation, 2);
                cellText = [NSString stringWithFormat:@"R^2 = %@", [NSNumber numberWithFloat:rSquared]];
                break;
            } default: {
                break;
            }
        }
        
        tvc.textLabel.text = cellText;
    }
    
    tvc.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tvc;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.dataArray1 objectAtIndex:section];
    int numberOfRowsInSection = (int)sectionArray.count;
    if (self.dataIsDatasource) {
        return numberOfRowsInSection;
    } else {
        if (self.calcMode) {
            return numOfInfoCells;
        } else {
            return numOfInfoCells - 1;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray1.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Trial: %i", (int)section + 1];
}

@end
