//
//  PatientTableViewCell.h
//  OcularCellscope
//
//  Created by PJ Loury on 4/7/14.
//  Copyright (c) 2014 UC Berkeley Ocular CellScope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UIImageView *eyeThumbnail;

@end
