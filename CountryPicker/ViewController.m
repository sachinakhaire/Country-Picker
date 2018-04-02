//
//  ViewController.m
//  CountryPicker
//
//  Created by MacMini3 on 02/04/18.
//  Copyright © 2018 MacMini3. All rights reserved.
//

#import "ViewController.h"
#define REGEX_PHONE_DEFAULT @"[0-9]{1,20}"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_MARGIN 5.0f

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    NSArray *countryCodeArray;
    NSArray *countryNameCodeArray;
    NSUInteger globalCurrentRow;
    NSString *detectSelectCountryFlag;
    NSString *selectedCountry;
}

@end

@implementation ViewController
@synthesize countryCodeLabel;
@synthesize phoneNumberTxtField;
@synthesize pickerViewInstance;
@synthesize countryPickerView;
@synthesize labelDialCodeWidthConstraint;

- (void)viewDidLoad
{
    [super viewDidLoad];
     globalCurrentRow = 0;
    detectSelectCountryFlag = [[NSString alloc] init];
    detectSelectCountryFlag = @"United States";
    
    pickerViewInstance.hidden =NO;
    countryPickerView.delegate = self;
    countryPickerView.dataSource= self;
    countryCodeArray = [self JSONFromFile];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code"  ascending:YES];
    NSArray *sortDescriptors = @[nameDescriptor];
    NSArray *ordered = [countryCodeArray sortedArrayUsingDescriptors:sortDescriptors];
    countryCodeArray = [NSArray new];
    countryCodeArray = [ordered copy];
    selectedCountry = [[NSString alloc]init];
    countryNameCodeArray = [countryCodeArray valueForKey:@"code"];
   countryCodeLabel.text = @"+1";
    
    phoneNumberTxtField.delegate = self;
}
- (NSArray *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryCodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - UIPicker View Delegate
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return countryNameCodeArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    NSString *deviceNameWithPersonName = [NSString stringWithFormat:@"%@", [[countryCodeArray objectAtIndex:component] valueForKey:@"name"]];
    CGSize sizes = [deviceNameWithPersonName sizeWithAttributes:
                    @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(sizes.width), ceilf(sizes.height));
    CGFloat height = MAX(adjustedSize.height, 30.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
    
    //return 40;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(pickerViewInstance.frame.origin.x, 0, pickerViewInstance.frame.size.width, 40)];
    
    UIImage *countryImgFlag = [UIImage imageNamed:[countryNameCodeArray objectAtIndex:row]];
    UIImageView *countryImageView = [[UIImageView alloc] initWithImage:countryImgFlag];
    //countryImageView.frame = CGRectMake(-70, 5, 30, 30);
    countryImageView.frame = CGRectMake(10, 5, 30, 30);
    
    //    UILabel *countryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 50, 40)];
    UILabel *countryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(pickerViewInstance.frame.size.width-60, 0, 50, 40)];
    countryCodeLabel.text = [NSString stringWithFormat:@"%@", [[countryCodeArray objectAtIndex:row] valueForKey:@"dial_code"]];
    countryCodeLabel.textAlignment = NSTextAlignmentCenter;
    countryCodeLabel.backgroundColor = [UIColor clearColor];
    
    CGFloat tmpwidth = tmpView.frame.size.width;
    CGFloat imgwidth = countryImageView.frame.size.width+10;
    CGFloat codewidth = countryCodeLabel.frame.size.width+10;
    
    CGFloat total = imgwidth + codewidth;
    
    CGFloat grandtotal = tmpwidth - total;
    
    //UILabel *countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UILabel *countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgwidth, 0, grandtotal, 40)];
    //countryNameLabel.text = [NSString stringWithFormat:@"%@", [countryNameCodeArray objectAtIndex:row]];
    countryNameLabel.text = [NSString stringWithFormat:@"%@", [[countryCodeArray objectAtIndex:row] valueForKey:@"name"]];
    countryNameLabel.textAlignment = NSTextAlignmentCenter;
    countryNameLabel.backgroundColor = [UIColor clearColor];
    countryNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    countryNameLabel.numberOfLines = 0;
    //[countryNameLabel sizeToFit];
    [countryNameLabel setMinimumFontSize:FONT_SIZE];
    [countryNameLabel setNumberOfLines:0];
    [countryNameLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    //UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    tmpView.backgroundColor = [UIColor clearColor];
    [tmpView insertSubview:countryImageView atIndex:0];
    [tmpView insertSubview:countryNameLabel atIndex:1];
    [tmpView insertSubview:countryCodeLabel atIndex:2];
    globalCurrentRow = row;
    return tmpView;
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    NSString *code =  [[countryCodeArray objectAtIndex:row] valueForKey:@"dial_code"];
    detectSelectCountryFlag = [[countryCodeArray objectAtIndex:row] valueForKey:@"name"];
    NSLog(@"country code = %@ , %lu", code, (unsigned long)code.length);
    if (code.length == 2)
    {
        countryCodeLabel.text = code;
        labelDialCodeWidthConstraint.constant = 25;
        [self.view layoutIfNeeded];
    }
    else if (code.length == 3)
    {
        countryCodeLabel.text = code;
        labelDialCodeWidthConstraint.constant = 30;
        [self.view layoutIfNeeded];
    }
    else if (code.length == 4)
    {
        countryCodeLabel.text = code;
        labelDialCodeWidthConstraint.constant = 40;
        [self.view layoutIfNeeded];
    }
    else if (code.length == 5)
    {
        countryCodeLabel.text = code;
        labelDialCodeWidthConstraint.constant = 45;
        [self.view layoutIfNeeded];
    }
    else
    {
        countryCodeLabel.text = code;
        labelDialCodeWidthConstraint.constant = 50;
        [self.view layoutIfNeeded];
    }
    
    selectedCountry = [NSString stringWithFormat:@"%@",code];
    globalCurrentRow = row;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (pickerViewInstance.hidden == NO)
    {
        pickerViewInstance.hidden = YES;
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneBtnAction:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    pickerViewInstance.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([resultString isEqualToString:selectedCountry])
    {
        return NO;
    }
    return YES;
}
@end
