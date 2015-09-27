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
    
    [self.navigationController setNavigationBarHidden:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tvc = [tableView dequeueReusableCellWithIdentifier:@"StatsViewerTableViewCell"];
    if (!tvc) tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsViewerTableViewCell"];
    
    if (self.dataIsDatasource) {
        NSArray *trialDataArray = [self.dataArray objectAtIndex:indexPath.section];
        NSArray *trialResultsArray = nil;
        if (self.resultsArray.count != 0) {
            trialResultsArray = [self.resultsArray objectAtIndex:indexPath.section];
        } // else trialResultsArray is nil
        
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
        // median. q1, q3, stdev.
        switch (indexPath.row) {
            case 0: { // avg
                cellText = [NSString stringWithFormat:@"Average: %@", [NSNumber numberWithFloat:[self average:self.dataArray[indexPath.row]]].stringValue];
                break;
            } case 1: { // st. dev
                float standardDeviation;
                NSMutableArray *devsFromAvg = [NSMutableArray new];
                int test = indexPath.row;
                float average = [self average:self.dataArray[indexPath.section]];
    
                for (NSNumber *number in self.dataArray[indexPath.section]) {
                    [devsFromAvg addObject:[NSNumber numberWithFloat:powf((number.floatValue - average), 2)]];
                }
                standardDeviation = powf([self average:devsFromAvg], .5);
                cellText = [NSString stringWithFormat:@"Standard deviation: %@", [NSNumber numberWithFloat:standardDeviation].stringValue];
                break;
            } case 2: { // median
                NSMutableArray *trialArray = [self.dataArray[indexPath.section] mutableCopy];
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
                    float num1 = ((NSNumber *)trialArray[trialArray.count/2]).floatValue;
                    float num2 = ((NSNumber *)trialArray[(trialArray.count/2) + 1]).floatValue;
                    
                    resultNum = (num1 + num2)/2.0;
                } else { // if count is odd
                    resultNum = ((NSNumber *)trialArray[(trialArray.count-1)/2]).intValue;
                }
                
                cellText = [NSString stringWithFormat:@"Median: %@", [NSNumber numberWithFloat:resultNum].stringValue];
                break;
            } case 3:{ // mode
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
/*
 
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.dataArray objectAtIndex:section];
    int numberOfRowsInSection = (int)sectionArray.count;
    
    
    if (self.dataIsDatasource) {
        return numberOfRowsInSection;
    } else {
        if (self.calcMode) {
            return 4;
        } else {
            return 3;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
