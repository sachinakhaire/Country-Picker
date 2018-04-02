//
//  ViewController.h
//  CountryPicker
//
//  Created by MacMini3 on 02/04/18.
//  Copyright © 2018 MacMini3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTxtField;

@property (strong, nonatomic) IBOutlet UIView *pickerViewInstance;
- (IBAction)doneBtnAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPickerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelDialCodeWidthConstraint;
@end

