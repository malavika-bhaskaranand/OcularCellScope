//
//  ExamInfoTableViewController.m
//  OcularCellscope
//
//  Created by PJ Loury on 4/28/14.
//  Copyright (c) 2014 NAYA LOUMOU. All rights reserved.
//

#import "ExamInfoTableViewController.h"
#import <Parse/Parse.h>

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ExamInfoTableViewController ()

@property Exam* e;

@end

@implementation ExamInfoTableViewController

@synthesize firstnameField, lastnameField, profilePicButton, patientIDLabel,  phoneNumberField, patientIDTextField;
@synthesize birthDayTextField,birthMonthTextField,birthYearTextField;

@synthesize nameCell,dobCell,phoneCell,idCell;

@synthesize e;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

# pragma mark - View Lifecycle
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.firstnameField.delegate=self;
    self.lastnameField.delegate=self;
    
    self.birthDayTextField.delegate=self;
    self.birthMonthTextField.delegate=self;
    self.birthYearTextField.delegate=self;
    
    self.phoneNumberField.delegate=self;
    self.patientIDTextField.delegate=self;
    
    firstnameField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    lastnameField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    //physicianField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    if(indexPath) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    self.e = [[CellScopeContext sharedContext]currentExam];
    

    self.firstnameField.text = self.e.firstName;
    self.lastnameField.text = self.e.lastName;
    self.patientIDTextField.text = self.e.patientID;
    self.phoneNumberField.text = self.e.phoneNumber;
    
    self.uploadStatusIcon.layer.cornerRadius = self.uploadStatusIcon.frame.size.width / 2;
    self.uploadStatusIcon.clipsToBounds = YES;
    
    if (self.e.uploaded.intValue==1)
        self.uploadStatusIcon.backgroundColor = [UIColor yellowColor];
    else if (self.e.uploaded.intValue==2)
        self.uploadStatusIcon.backgroundColor = [UIColor greenColor];
    else
        self.uploadStatusIcon.backgroundColor = [UIColor clearColor];

    if(self.e.birthDate != nil){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.e.birthDate];
        NSLog(@"Day: %d", (int)[components day]);
        self.birthDayTextField.text = [NSString stringWithFormat: @"%d", (int)[components day]];
        self.birthMonthTextField.text = [NSString stringWithFormat: @"%d", (int)[components month]];
        self.birthYearTextField.text = [NSString stringWithFormat: @"%d", (int)[components year]];
    }
       
    if(self.e.profilePicData){
        [self.profilePicButton setImage:[UIImage imageWithData:self.e.profilePicData] forState:UIControlStateNormal];
    }
    
    if( self.e.patientIndex == 0){ // indicates a new exam
        self.e.patientIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"patientNumberIndex"];
        int value = [self.e.patientIndex intValue];
        value=value+1;
        
        [[NSUserDefaults standardUserDefaults] setValue: [NSNumber numberWithInt:value] forKey:@"patientNumberIndex" ];
        NSLog(@"%d",value);
        
        self.e.patientIndex = [NSNumber numberWithInt: value];
        //self.patientIDField.text = [self.e.patientID stringValue];
        self.patientIDLabel.text = [self.e.patientIndex stringValue];
    }
    else{
        //self.patientIDField.text = [self.e.patientID stringValue];
        self.patientIDLabel.text = [self.e.patientIndex stringValue];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Saving Exam Data");


/*
    if([firstnameField.text isEqualToString: @""]){
        self.e.firstName = @"N/A";
    }
    else
        self.e.firstName = firstnameField.text;
    
    if([lastnameField.text isEqualToString: @""]){
        self.e.lastName = @"N/A";
    }
    else
        self.e.lastName = lastnameField.text;
    
    if([patientIDTextField.text isEqualToString: @""]){
        self.e.patientID = @"N/A";
    }
    else
        self.e.patientID = patientIDTextField.text;
*/
    
    
    self.e.firstName = firstnameField.text;
    self.e.lastName = lastnameField.text;
    self.e.patientID = patientIDTextField.text;
    self.e.phoneNumber = phoneNumberField.text;
    
    
    NSString * birthDateString = [NSString stringWithFormat:@"%@-%@-%@",self.birthDayTextField.text,self.birthMonthTextField.text,self.birthYearTextField.text];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];

    NSLog(@"BD String %@",birthDateString);
    
    NSDate *bd = [[NSDate alloc] init];
    bd = [dateFormatter dateFromString:birthDateString];
    
    NSLog(@"BD NSDate %@",bd);
    self.e.birthDate = bd;
    

    // Commit to core data
    NSError *error;
    if (![[[CellScopeContext sharedContext] managedObjectContext] save:&error])
        NSLog(@"Failed to commit to core data: %@", [error domain]);
}

# pragma mark - UITableViewDelegate
//This method dismisses the keyboard when the background is tapped
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCellClicked = [self.tableView cellForRowAtIndexPath:indexPath];
    if (theCellClicked == nameCell || theCellClicked == idCell ||
        theCellClicked == phoneCell || theCellClicked == dobCell ) {
        [[self tableView] endEditing:YES];

    }
}

//This method allows the user to add a profile picture of the patient by
//clicking on the OCS icon
- (IBAction)didPressProfilePicture:(id)sender {
    
    [profilePicButton setHighlighted: YES];
    
    if([profilePicturePopover isPopoverVisible]){
        [profilePicturePopover dismissPopoverAnimated:YES];
        profilePicturePopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        [imagePicker setMediaTypes: availableTypes];
        [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera]; //4
    }
    
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion: nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    /* Do what you need to do then */
    [picker  dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[profilePicturePopover dismissPopoverAnimated:YES];
    //profilePicturePopover = nil;
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [profilePicButton setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    /*
    
    NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    //Temporary is not safe, it needs to be moved
    
    if(mediaURL){
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path]))
        {
            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
            [[NSFileManager defaultManager] removeItemAtPath:[mediaURL path] error:nil];
        }
    }
    
    //self.e.profilePicPath= mediaURL;
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    //Crop the image to a square
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    self.e.profilePicData = imageData;
    
    [profilePicButton setImage:image forState:UIControlStateNormal];
    
    //[self uploadPhoto:image];
    //NSString *bucketName = [[[Constants pictureBucket] stringByAppendingString:[e fullName]]lowercaseString];
    //[s3manager processGrandCentralDispatchUpload:imageData forExamBucket:bucketName andImageName:PICTURE_NAME];
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // If on the phone, image picker is presented modally, so Dismiss it
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        //We dismiss popovers differently
        [profilePicturePopover dismissPopoverAnimated:YES];
        profilePicturePopover =nil;
    }
    [profilePicButton setHighlighted: NO];
    */
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Text Field Should Return!");
    if (textField == firstnameField) {
        [lastnameField becomeFirstResponder];
        return YES;
    } else if (textField == lastnameField) {
        [patientIDTextField becomeFirstResponder];
        return YES;
    } else if (textField == phoneNumberField) {
        [birthDayTextField becomeFirstResponder];
        return YES;
    } else if (textField == birthDayTextField) {
        [birthMonthTextField becomeFirstResponder];
        return YES;
    } else if (textField == birthMonthTextField) {
        [birthYearTextField becomeFirstResponder];
        return YES;
    }
    else{
        [textField resignFirstResponder];
        return NO;
    }
}

#pragma mark -
#pragma mark Text Field Delegate

/*
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.keyboardControls setActiveField:textField];

    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
*/


// Restrict phone textField to format 123-456-7890
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    if(textField == birthDayTextField){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > 2)
            [birthMonthTextField becomeFirstResponder];
    }
    if (textField == birthMonthTextField){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > 2)
            [birthYearTextField becomeFirstResponder];
    }
    
    if (textField==phoneNumberField){
        // All digits entered
        if (range.location == 15) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen and parentheses
        if (range.length == 0 && range.location == 3 &&![[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"(%@)-%@", textField.text,string];
            return NO;
        }
        if (range.length == 0 && range.location == 4 &&[[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"%@)-%@", textField.text,string];
            return NO;
        }
        
        // Auto-add 2nd hyphen
        if (range.length == 0 && range.location == 9) {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen and parentheses when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 10 || range.location == 1)){
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        if (range.length == 1 && range.location == 6){
            range.location=range.location-2;
            range.length = 3;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Table view data source

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
