//
//  ViewController.m
//  TessTest
//
//  Created by Sky Arnold on 8/22/15.
//  Copyright (c) 2015 Skyler Arnold. All rights reserved.
//

#import "OCRViewController.h"
#import "CropImageViewController.h"
#import "ViewResultsViewController.h"

@import MobileCoreServices;

@interface OCRViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation OCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)presentImagePickerView:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
        self.imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }
}

- (NSArray *)parseStringToArray:(NSString *)string {
    return @[];
}

- (void)imageCroppingFinishedWithImage:(UIImage *)image {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewResultsViewController *resultsVC = [storyboard instantiateViewControllerWithIdentifier:@"ResultsTableView"];
    resultsVC.dataArray1 = [NSMutableArray arrayWithArray: @[@[@2, @3, @4, @5]]];
    resultsVC.calcMode = false;
    [self.navigationController pushViewController:resultsVC animated:true];

    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng" engineMode:G8OCREngineModeTesseractCubeCombined];
    tesseract.delegate = self;
    
    tesseract.image = image;
    [tesseract recognize];

    [self.outputTextView setText: [tesseract recognizedText]];

    [self.imagePicker dismissViewControllerAnimated:true completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CropImageViewController *cropVC = [storyboard instantiateViewControllerWithIdentifier:@"CropVC"];
    cropVC.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    cropVC.delegate = self;
    [picker pushViewController:cropVC animated:true];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:self.imagePicker completion:^{}];
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass: [CropImageViewController class]]) {
        CropImageViewController *destinationVC = segue.destinationViewController;
    }
}

@end
