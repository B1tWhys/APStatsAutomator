//
//  CropImageViewController.h
//  APStatsSolver
//
//  Created by Skyler Arnold on 9/4/15.
//  Copyright (c) 2015 Skyler Arnold. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropImageViewControllerDelegate <NSObject>

- (void) imageCroppingFinishedWithImage:(UIImage *)image;

@end

@interface CropImageViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) id <CropImageViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@end
