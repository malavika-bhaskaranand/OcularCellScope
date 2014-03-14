//
//  ImageSelectionViewController.h
//  OcularCellscope
//
//  Created by Chris Echanique on 2/19/14.
//  Copyright (c) 2014 NAYA LOUMOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property(strong, nonatomic) NSMutableArray *images;
@property(strong, nonatomic) NSMutableArray *thumbnails;

- (IBAction)didMoveSlider:(id)sender;

@property (nonatomic) NSInteger const selectedLight;
@property (copy, nonatomic) NSString *selectedEye;

@end
