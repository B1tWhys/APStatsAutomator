//
//  ManualDataEntryViewController.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 9/26/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "ManualDataEntryViewController.h"
#import "DataEntryTableViewCell.h"
#import "ViewSimulationResultsViewController.h"

@interface ManualDataEntryViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *calculateModeSlider;
@property (weak, nonatomic) IBOutlet UITextField *numberOfTrialsTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) UITextField *currentlySelectedField;
@property (weak, nonatomic) IBOutlet UITextField *spaceDelimtedData;
@end

@implementation ManualDataEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.spaceDelimtedData.delegate = self;
    
    self.dataArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.numberOfTrialsTextView.text isEqualToString:@""]) { // number of trials textField is empty
        self.dataArray = [NSMutableArray new];
        return 0;
    } else {
        return self.numberOfTrialsTextView.text.intValue;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int returnVal = (((NSArray *)self.dataArray[section]).count + 1.0);
    return returnVal;
}

- (IBAction)step:(UIStepper *)sender {
    double stepVal = sender.value;
//    self.numberOfTrialsTextView.text = [NSNumber numberWithDouble:stepVal].stringValue;
    if (sender.value == 0) {
        self.numberOfTrialsTextView.text = @"";
    } else {
        [self.numberOfTrialsTextView setText:[NSNumber numberWithDouble:stepVal].stringValue];
    }
    [self textFieldTextDidChange:self.numberOfTrialsTextView];
}

- (IBAction)textFieldTextDidChange:(UITextField *)sender {
    if (sender.tag == 0) { // is number of trials textField
        self.stepper.value = sender.text.doubleValue;
        NSMutableArray *newDataArray = [NSMutableArray arrayWithArray:self.dataArray];
        if (newDataArray.count < sender.text.doubleValue) {
            for (int lenOfArray = (int)newDataArray.count; newDataArray.count < sender.text.intValue; lenOfArray = (int)newDataArray.count) {
                [newDataArray addObject:[NSMutableArray new]];
            }
        } else {
            NSRange range = NSMakeRange(0, sender.text.intValue);
            newDataArray = [NSMutableArray arrayWithArray:[newDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
        }

        self.dataArray = newDataArray;
        
        [self.tableView reloadData];
    } else if (sender.tag == 1) { // is in a TVCe
        DataEntryTableViewCell *cell = ((DataEntryTableViewCell *) sender.superview.superview); // the TVCe
        NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
        NSMutableArray *trial = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
        trial[indexPath.row] = [NSNumber numberWithInt: sender.text.intValue];
        if ([sender.text isEqualToString:@""]) {
            [trial removeLastObject];
        }

        if (trial.count != ((NSArray *)self.dataArray[indexPath.section]).count) {
            self.dataArray[indexPath.section] = trial;
            [self.tableView reloadData];
            
            DataEntryTableViewCell *newCell = (DataEntryTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSArray *visibleCells = self.tableView.visibleCells;
            NSMutableString *testStr = [NSMutableString new];
            for (DataEntryTableViewCell *cell in visibleCells) {
                [testStr appendString:cell.entryField.text];
            }
            
            if (![self.tableView.visibleCells containsObject:newCell]) {
                [self.tableView scrollToRowAtIndexPath: [self.tableView indexPathForCell:newCell]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:true];
            }
            [newCell.entryField becomeFirstResponder];
        } else {
            self.dataArray[indexPath.section] = trial;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIToolbar *numberToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]]) {
        numberToolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStyleDone target: textField action: @selector(resignFirstResponder)],
                                [[UIBarButtonItem alloc] initWithTitle:@"Next" style: UIBarButtonItemStyleDone target: self action: @selector(advanceToNextTextField:)],
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil]];
    } else {
        numberToolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStyleDone target: textField action: @selector(resignFirstResponder)],
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil]];
    }
    [numberToolbar sizeToFit];
    self.currentlySelectedField = textField;
    textField.inputAccessoryView = numberToolbar;
}

- (void) dismissDataEntryKeyboardOnTextField:(UITextField *)textField {
    [textField resignFirstResponder];
    self.currentlySelectedField = nil;
}

- (void) advanceToNextTextField:(UITextField *)textField {
    DataEntryTableViewCell *cell = (DataEntryTableViewCell *)self.currentlySelectedField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    unsigned long row = indexPath.row;
    unsigned long section = indexPath.section;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    row = newIndexPath.row;
    section = indexPath.section;
    DataEntryTableViewCell *nextCell = (DataEntryTableViewCell *)[self.tableView cellForRowAtIndexPath:newIndexPath];
    [nextCell.entryField becomeFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataEntryCell"];
    NSArray *trialArray = self.dataArray[indexPath.section];
    if (trialArray.count == indexPath.row) { // we are 1 row past the end of the array
        cell.entryField.text = @"";
    } else {
        NSMutableArray *trialArray = self.dataArray[indexPath.section];
        
        cell.entryField.text = ((NSNumber *) trialArray[indexPath.row]).stringValue;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Trial: %i", (int)section + 1];
}

/*
 - (NSArray *)parseStringIntoResultsArray:(NSString *)inputStr {
 NSString *denseInput = [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 NSArray *commaSeperatedArray = [denseInput componentsSeparatedByString:@","];
 NSMutableArray *finalArray = [NSMutableArray new];
 for (NSString *segment in commaSeperatedArray) {
 if ([segment containsString:@"-"]) {
 NSMutableArray *rangeString = [[segment componentsSeparatedByString:@"-"] mutableCopy];
 int lowerBound = ((NSString *)rangeString[0]).intValue;
 int upperBound = ((NSString *)rangeString[1]).intValue;
 for (int i = lowerBound; i <= upperBound; i++){
 [rangeString addObject:[NSNumber numberWithInt:i]];
 }
 [finalArray addObjectsFromArray:rangeString];
 } else {
 [finalArray addObject:[NSNumber numberWithInt:segment.intValue]];
 }
 }
 return finalArray;
 }
 
 */

- (NSArray *) parseDataString {
    NSString *cleanInput = [self.spaceDelimtedData.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSArray *stringsArray = [cleanInput componentsSeparatedByString:@" "];
    NSMutableArray *numsArray = [NSMutableArray new];
    for (NSString *numStr in stringsArray) {[numsArray addObject:[NSNumber numberWithFloat:numStr.floatValue]];}
    
    return [NSArray arrayWithArray:numsArray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[ViewSimulationResultsViewController class]]) {
        if (self.dataArray.count != 0) {
            ViewSimulationResultsViewController *destinationVC = segue.destinationViewController;
            destinationVC.dataArray = self.dataArray;
            destinationVC.resultsArray = [NSMutableArray new];
            destinationVC.calcMode = self.calculateModeSlider.on;
        } else { // use text entry
            ViewSimulationResultsViewController *destinationVC = segue.destinationViewController;
            destinationVC.dataArray = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:[self parseDataString]]]];
            destinationVC.resultsArray = [NSMutableArray new];
            destinationVC.calcMode = self.calculateModeSlider.on;
        }
    }
}

@end
