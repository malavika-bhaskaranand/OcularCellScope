//
//  PatientsTableViewController.h
//  AV Camera App
//
//  Created by NAYA LOUMOU on 12/1/13.
//  Copyright (c) 2013 NAYA LOUMOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellScopeContext.h"

@interface PatientsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *patientsArray;

@property (nonatomic, strong) Exam *currentExam;
@property UIColorManager *colorManager;

- (IBAction)didPressAddExam:(id)sender;

@end
