//
//  AOAddAddressViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOAddAddressViewController.h"

@interface AOAddAddressViewController ()
{
    BOOL toggleKeyboardIsOn;
    NSArray *arrayCity;
}

@end

@implementation AOAddAddressViewController

@synthesize m_viewMain;
@synthesize m_txtCity, m_txtCountry, m_txtFirstName, m_txtTelephone;
@synthesize m_txtSecondName, m_txtStreetName, m_txtAddressExtra, m_txtStreetNumber;
@synthesize m_tableView, m_viewCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewCity.hidden = YES;
    m_txtFirstName.text = [GlobalData sharedGlobalData].g_userInfo.firstName;
    m_txtSecondName.text = [GlobalData sharedGlobalData].g_userInfo.lastName;
    
    [self arabicFormat:m_txtFirstName];
    [self arabicFormat:m_txtSecondName];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        m_txtCountry.text = COUNTRY_AR;
        arrayCity = [NSArray arrayWithObjects:@"الرياض", @"تبوك", @"مكة", @"المدينة", @"جدة", @"الاحساء", @"الطائف", @"الدمام", @"خميس", @"خميس مشيط", @"بريدة", @"خبر", @"حائل", @"حفر الباطن", @"الجبيل", @"الخارج", @"قطيف", @"ابةا", @"نجران", @"ينبع", @"القريات", @"الرس", @"عنيزة", @"المجمعة", @"شرورة", @"جازان", @"صامطة", @"القصيم", @"الباحة", @"عرعر", @"القويعية", @"القنفدة", nil];
        
    } else {
        
        m_txtCountry.text = COUNTRY_EN;
        arrayCity = [NSArray arrayWithObjects:@"Riyadh", @"Tabuk", @"Mecca", @"Medina", @"Jeddah", @"Al-Ahsa", @"Taeif", @"Dammam", @"Khamis", @"Khamis Mushait", @"Buraidah", @"Khobar", @"Haeil", @"Hafar Al-Batin", @"Jubail", @"Al-Kharj", @"Qatif", @"Abha", @"Najran", @"Yanbu", @"Qurayyat", @"Ar Rass", @"Unaizah", @"Al Majmaah", @"Sharurah", @"Jizan Region", @"Samtah", @"Al-Qassim Region", @"Al Bahah", @"Arar", @"Al-Quwayiyah", @"Al Qunfudhah", nil];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [m_txtFirstName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtSecondName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtStreetName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtAddressExtra addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidChange:(UITextField *)textField {
    [self arabicFormat:textField];
}

- (void)arabicFormat:(UITextField *)textField {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:textField.text
                                                    options:0
                                                      range:NSMakeRange(0, [textField.text length])];
    if (match) {
        textField.textAlignment = NSTextAlignmentRight;
    } else {
        textField.textAlignment = NSTextAlignmentLeft;
    }
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN] && textField.text.length == 0) {
        textField.textAlignment = NSTextAlignmentRight;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == m_txtFirstName) {
        [textField resignFirstResponder];
        [m_txtSecondName becomeFirstResponder];
    } else if (textField == m_txtSecondName) {
        [textField resignFirstResponder];
        [m_txtTelephone becomeFirstResponder];
    } else if (textField == m_txtTelephone) {
        [textField resignFirstResponder];
        [m_txtStreetName becomeFirstResponder];
    } else if (textField == m_txtStreetName) {
        [textField resignFirstResponder];
        [m_txtStreetNumber becomeFirstResponder];
    } else if (textField == m_txtStreetNumber) {
        [textField resignFirstResponder];
        [m_txtAddressExtra becomeFirstResponder];
    } else if (textField == m_txtAddressExtra) {
        [self dismissKeyboard];
        [self showAnimationView:m_viewCity];
    } else if (textField == m_txtCity) {
        [self dismissKeyboard];
        [self onAddAddress:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == m_txtStreetName) {
        [self toggleKeyboard];
    } else if (textField == m_txtStreetNumber) {
        [self toggleKeyboard];
    } else if (textField == m_txtAddressExtra) {
        [self toggleKeyboard];
    } else if (textField == m_txtCity) {
        [self dismissKeyboard];
        [self showAnimationView:m_viewCity];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == m_txtStreetName) {
        [self toggleKeyboard];
    } else if (textField == m_txtStreetNumber) {
        [self toggleKeyboard];
    } else if (textField == m_txtAddressExtra) {
        [self toggleKeyboard];
    } else if (textField == m_txtCity) {
        [self dismissKeyboard];
        [self showAnimationView:m_viewCity];
    }
    
    return YES;
    
}

- (void)toggleKeyboard {
    
    if (toggleKeyboardIsOn) {
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        m_viewMain.frame = CGRectMake(m_viewMain.frame.origin.x, (m_viewMain.frame.origin.y - 200.0), m_viewMain.frame.size.width, m_viewMain.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = true;
    }
}


#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    if (toggleKeyboardIsOn) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        m_viewMain.frame = CGRectMake(m_viewMain.frame.origin.x, (m_viewMain.frame.origin.y + 200.0), m_viewMain.frame.size.width, m_viewMain.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = false;
    }
}

- (void)showAnimationView:(UIView *)mView {
    
    mView.hidden = NO;
    mView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationView:(UIView *)mView {
    
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 0;
        mView.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayCity.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    
    UILabel *_lblCity = (UILabel*)[_cell viewWithTag:1];
    
    _lblCity.text = arrayCity[indexPath.row];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    m_txtCity.text = arrayCity[indexPath.row];
    [self closeAnimationView:m_viewCity];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddAddress:(id)sender {
    
    NSString *strFirstName = m_txtFirstName.text;
    NSString *strSecondName = m_txtSecondName.text;
    NSString *strPhone = m_txtTelephone.text;
    
    NSString *strStreetName = m_txtStreetName.text;
    NSString *strStreetNumber = m_txtStreetNumber.text;
    NSString *strAddressExtra = m_txtAddressExtra.text;
    NSString *strCountry = m_txtCountry.text;
    NSString *strCity = m_txtCity.text;
    
    if ([strFirstName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_first_name", "")];
        return;
    } else if ([strSecondName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_second_name", "")];
        return;
    } else if ([strPhone isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_phone_number", "")];
        return;
    } else if ([strStreetName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_street_name", "")];
        return;
    } else if ([strStreetNumber isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_street_number", "")];
        return;
    } else if ([strAddressExtra isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_address_extra", "")];
        return;
    } else if ([strCountry isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_country", "")];
        return;
    } else if ([strCity isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_city", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] addShippingBillingAddress:TAG_SET_DEFAULT_SHIPPING_BILLING_ADDRESS email:[GlobalData sharedGlobalData].g_userInfo.email isDefault:@"" fname:strFirstName lname:strSecondName stname:strStreetName stnum:strStreetNumber addinfo:strAddressExtra city:strCity company:COMPANY_NAME zip:ZIP_CODE country:strCountry tel:strPhone fax:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            int success = [responseObject[KEY_SUCCESS] intValue];
            if (success == 1) {
                [self performSegueWithIdentifier:UNWIND_STORE_ADDRESS sender:nil];
            } else {
                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_add_address_failed", "")];
            }
        } else {
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_add_address_failed", "")];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_add_address_failed", "")];
    }];
    
}

@end
