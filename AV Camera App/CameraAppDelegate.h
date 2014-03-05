//
//  CameraAppDelegate.h
//  AV Camera App
//
//  Created by NAYA LOUMOU on 11/11/13.
//  Copyright (c) 2013 NAYA LOUMOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "BLE.h"

@interface CameraAppDelegate : UIResponder <UIApplicationDelegate, BLEDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) Exam *currentExam;

//@property (strong, nonatomic) BLE *ble;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end



