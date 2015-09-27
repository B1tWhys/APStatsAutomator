//
//  ManualDataEntryViewController.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 9/26/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "ManualDataEntryViewController.h"
#import "DataEntryTableViewCell.h"

@interface ManualDataEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberOfTrialsTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ManualDataEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSArray new];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.numberOfTrialsTextView.text isEqualToString:@""]) { // number of trials textField is empty
        self.dataArray = @[];
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
            int len = sender.text.doubleValue;
//            NSRange range = NSMakeRange(sender.text.intValue, len);
            NSRange range = NSMakeRange(0, sender.text.intValue);
            newDataArray = [NSMutableArray arrayWithArray:[newDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
        }
        
        self.dataArray = (NSArray *)newDataArray;
        
        [self.tableView reloadData];
    } else if (sender.tag == 1) { // is in a TVCe
        DataEntryTableViewCell *cell = ((DataEntryTableViewCell *) sender.superview.superview); // the TVCe
        NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
        NSMutableArray *trial = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
        trial[indexPath.row] = [NSNumber numberWithInt: sender.text.intValue];
        if ([sender.text isEqualToString:@""]) {
            [trial removeLastObject];
        }
        if (trial != self.dataArray[indexPath.section]) {
            [self.tableView reloadData];
            self.dataArray[indexPath.section] = trial;
        }
    }
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

@end
