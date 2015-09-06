//
//  CropImageViewController.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 9/4/15.
//  Copyright (c) 2015 Skyler Arnold. All rights reserved.
//

#import "CropImageViewController.h"
#import "CropRectDisplayView.h"

@interface CropImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *cropView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *resizingSquares;
@property (nonatomic) CGRect cropViewFrameAtStartOfPan;
@end

@implementation CropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:self.image];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.cropView.translatesAutoresizingMaskIntoConstraints = true;
    
    self.cropView.frame = CGRectMake(self.view.frame.size.width/4,
                                     (self.view.frame.size.height * 3)/8,
                                     self.view.frame.size.width/2,
                                     self.view.frame.size.height/4);
    
    for (UIView *square in self.resizingSquares) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleCropSelectorWithGestureRecognizer:)];
        [square addGestureRecognizer:recognizer];
    }
}

- (void) scaleCropSelectorWithGestureRecognizer: (UIPanGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:self.view];
    
    switch (recognizer.view.tag) {
        case 0: { //topleft
            self.cropView.frame = CGRectMake(touchLocation.x,
                                             touchLocation.y,
                                             CGRectGetMaxX(self.cropView.frame) - touchLocation.x,
                                             CGRectGetMaxY(self.cropView.frame) - touchLocation.y);
            break;
        } case 1: { // top middle
            self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                             touchLocation.y,
                                             self.cropView.frame.size.width,
                                             CGRectGetMaxY(self.cropView.frame) - touchLocation.y);
            
            break;
        } case 2: { // top right
            self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                             touchLocation.y,
                                             touchLocation.x - CGRectGetMinX(self.cropView.frame),
                                             CGRectGetMaxY(self.cropView.frame) - touchLocation.y);
//                                             CGRectGetMaxX(self.cropView.frame) - touchLocation.x,
//                                             CGRectGetMaxY(self.cropView.frame) - touchLocation.y);
            
            
            break;
        } case 3: { // middle right
            self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                             self.cropView.frame.origin.y,
                                             touchLocation.x - self.cropView.frame.origin.x,
                                             self.cropView.frame.size.height);
            
            break;
        } case 4: { // bottom right
            self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                             self.cropView.frame.origin.y,
                                             touchLocation.x - self.cropView.frame.origin.x,
                                             touchLocation.y - self.cropView.frame.origin.y);
            
            break;
        } case 5: { // bottom center
            self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                             self.cropView.frame.origin.y,
                                             self.cropView.frame.size.width,
                                             touchLocation.y - self.cropView.frame.origin.y);
            break;
        } case 6: { // bottom left
            self.cropView.frame = CGRectMake(touchLocation.x,
                                             self.cropView.frame.origin.y,
                                             CGRectGetMaxX(self.cropView.frame) - touchLocation.x,
                                             touchLocation.y - self.cropView.frame.origin.y);
            break;
        } case 7 : {
            self.cropView.frame = CGRectMake(touchLocation.x,
                                             self.cropView.frame.origin.y,
                                             CGRectGetMaxX(self.cropView.frame) - touchLocation.x,
                                             self.cropView.frame.size.height);
            break;
        } default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end