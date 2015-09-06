//
//  ViewController.m
//  TessTest
//
//  Created by Sky Arnold on 8/22/15.
//  Copyright (c) 2015 Skyler Arnold. All rights reserved.
//

#import "OCRViewController.h"
#import "CropImageViewController.h"

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
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CropViewController" bundle:[NSBundle mainBundle]];
//    CropImageViewController *cropViewController = [storyboard instantiateInitialViewController];
//    [self.navigationController pushViewController:cropViewController animated:true];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CropViewController" bundle:[NSBundle mainBundle]];
    CropImageViewController *cropVC = [storyboard instantiateInitialViewController];
    cropVC.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self.navigationController presentViewController:cropVC animated:true completion:^{}];
    
    //    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng" engineMode:G8OCREngineModeTesseractCubeCombined];
//    tesseract.delegate = self;
//    
//    tesseract.image = [info objectForKey:UIImagePickerControllerEditedImage];
//    [tesseract recognize];
//    
//    [self.outputTextView setText: [tesseract recognizedText]];
//    
//    [self.imagePicker dismissViewControllerAnimated:true completion:^{}];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker removeFromParentViewController];
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
