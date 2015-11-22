//
//  LinRegresFromStatsViewController.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 11/10/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "LinRegresFromStatsViewController.h"

@interface LinRegresFromStatsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *correlationField;
@property (weak, nonatomic) IBOutlet UITextField *avgXField;
@property (weak, nonatomic) IBOutlet UITextField *stdXField;
@property (weak, nonatomic) IBOutlet UITextField *avgYField;
@property (weak, nonatomic) IBOutlet UITextField *stdYField;
@property (weak, nonatomic) IBOutlet UILabel *linRegresEquationLabel;
@property (weak, nonatomic) IBOutlet UITextField *predictionXField;
@property (weak, nonatomic) IBOutlet UILabel *predictionYLabel;
@property (weak, nonatomic) IBOutlet UIButton *predictionCalcButton;

@property (nonatomic) float slope;
@property (nonatomic) float yIntercept;
@property (nonatomic) BOOL slopeAndYInterceptHaveBeenCalculated;
@end

@implementation LinRegresFromStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.correlationField.delegate = self;
    self.avgXField.delegate = self;
    self.stdXField.delegate = self;
    self.avgYField.delegate = self;
    self.stdYField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateLinRegres {
    float avgX = self.avgXField.text.floatValue;
    float stdX = self.stdXField.text.floatValue;
    float avgY = self.avgYField.text.floatValue;
    float stdY = self.stdYField.text.floatValue;
    float correlation = self.correlationField.text.floatValue;
    
    self.slope = (correlation*stdY)/stdX;
    self.yIntercept = avgY - self.slope * avgX;
    
    NSString *equation = [NSString stringWithFormat:@"ŷ = %@ %@ %@x",
                          [NSNumber numberWithFloat:self.yIntercept].stringValue,
                          self.slope < 0 ? @"-" : @"+",
                          [NSNumber numberWithFloat:self.slope].stringValue];
    
    self.slopeAndYInterceptHaveBeenCalculated = true;
    self.linRegresEquationLabel.text = equation;
    self.predictionXField.hidden = false;
    self.predictionYLabel.hidden = false;
    self.predictionCalcButton.hidden = false;
}

- (IBAction)predictFromNumber:(id)sender {
    if (self.slopeAndYInterceptHaveBeenCalculated) {
        float inputX = self.predictionXField.text.floatValue;
        float predictedY = (inputX * self.slope) + self.yIntercept;
        NSString *predictedYString = [NSString stringWithFormat:@"ŷ = %@",
                                      [NSNumber numberWithFloat:predictedY].stringValue];
        self.predictionYLabel.text = predictedYString;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.slopeAndYInterceptHaveBeenCalculated = false;
    self.predictionXField.hidden = true;
    self.predictionYLabel.hidden = true;
    self.predictionCalcButton.hidden = true;
    self.linRegresEquationLabel.text = @"";
    self.predictionYLabel.text = @"";
    
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIToolbar *numberToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    numberToolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStyleDone target: textField action: @selector(resignFirstResponder)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                          target: nil
                                                                          action: nil]];

    [numberToolbar sizeToFit];
    textField.inputAccessoryView = numberToolbar;
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
