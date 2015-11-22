//
//  SimAutomatorViewController.m
//  TessTest
//
//  Created by Sky Arnold on 8/26/15.
//  Copyright (c) 2015 Skyler Arnold. All rights reserved.
//

#import "SimAutomatorViewController.h"
#import "ViewResultsViewController.h"

@interface SimAutomatorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *maxNumInputField;
@property (weak, nonatomic) IBOutlet UITextField *minNumInputField;
@property (weak, nonatomic) IBOutlet UITextField *sampleSizePerTrialInputField;
@property (weak, nonatomic) IBOutlet UITextField *numOfTrialsInputField;
@property (weak, nonatomic) IBOutlet UITextField *successListInputField;
@property (weak, nonatomic) IBOutlet UISwitch *replaceAfterDraw;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *resultsArray;
@end

@implementation SimAutomatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:true];
    
    self.maxNumInputField.delegate = self;
    self.minNumInputField.delegate = self;
    self.sampleSizePerTrialInputField.delegate = self;
    self.numOfTrialsInputField.delegate = self;
    self.successListInputField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.dataArray = [NSMutableArray new];
    self.resultsArray = [NSMutableArray new];
}

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

- (IBAction)simulate:(id)sender {
    int upperBound;
    int lowerBound;
    int numberOfTrials;
    int sampleSizePerTrial;
    NSArray *successArray;
    
    if ([self.maxNumInputField.text isEqualToString:@"123"]) {
        upperBound = 9;
        lowerBound = 0;
        numberOfTrials = 5;
        sampleSizePerTrial = 10;
        successArray = @[@1];
        [self.replaceAfterDraw setOn:true animated:false];
    } else {
        upperBound = [self.maxNumInputField.text intValue];
        lowerBound = [self.minNumInputField.text intValue];
        numberOfTrials = [self.numOfTrialsInputField.text intValue];
        sampleSizePerTrial = [self.sampleSizePerTrialInputField.text intValue];
        successArray = [self parseStringIntoResultsArray:self.successListInputField.text];
    }
    
    if (((self.replaceAfterDraw.on) || ((sampleSizePerTrial - 1) < (upperBound - lowerBound)))
        && (lowerBound < upperBound)) {
        // 1, 2, 3, 4 ,5, 6, 7
        NSMutableArray *completePool = [NSMutableArray new];
        for (int num = lowerBound; num <= upperBound; num ++) {
            [completePool addObject:[NSNumber numberWithInt:num]];
        }
        
        for (int trial = 1; trial <= numberOfTrials; trial++) {
            NSMutableArray *pool = [completePool mutableCopy];
            
            NSMutableArray *trialDataArray = [NSMutableArray new];
            [self.dataArray addObject:trialDataArray];
            
            NSMutableArray *trialResultsArray = [NSMutableArray new];
            [self.resultsArray addObject:trialResultsArray];
            
            for (int sampleCount = 1; sampleCount <= sampleSizePerTrial; sampleCount++) {
                NSNumber *rndValue = [pool objectAtIndex:(arc4random() % pool.count)];
                if (!self.replaceAfterDraw.on) [pool removeObject:rndValue];
                
                [trialDataArray addObject: rndValue];
                
                if ([successArray containsObject:rndValue]) {
                    [trialResultsArray addObject: @"T"];
                } else {
                    [trialResultsArray addObject: @"F"];
                }
            }
        }
        
        [self viewResults];
    } else {
        NSString *alertText;
        if (!((sampleSizePerTrial - 1) < (upperBound - lowerBound))) {
            alertText = @"You don't have replacement, so you can't take more samples than there are in the bounds you entered.";
        } else if (upperBound < lowerBound) {
            alertText = @"Your minimum bound cannot be larger than your upper bound";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid entry"
                                                                       message:alertText
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [alert dismissViewControllerAnimated:true completion:^{}];
                                                             }];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert
                           animated:true
                         completion:^{}];
    }
}

- (void) viewResults {
    [self performSegueWithIdentifier:@"segueToResultsVC" sender:self];
}

- (void) backPressed {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIToolbar *numberToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:textField action:@selector(resignFirstResponder)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [numberToolbar sizeToFit];
    textField.inputAccessoryView = numberToolbar;
}

#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[ViewResultsViewController class]]) {
        ViewResultsViewController *destinationVC = segue.destinationViewController;
        destinationVC.dataArray1 = self.dataArray;
        destinationVC.resultsArray = self.resultsArray;
    }
}
@end
