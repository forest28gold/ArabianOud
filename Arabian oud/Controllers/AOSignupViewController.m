//
//  AOSignupViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOSignupViewController.h"

@interface AOSignupViewController ()
{
    BOOL toggleKeyboardIsOn;
}

@end

@implementation AOSignupViewController

@synthesize m_txtEmail, m_txtPassword, m_txtFirstName, m_txtSecondName, m_viewSignup;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    toggleKeyboardIsOn = false;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == m_txtFirstName) {
        
        [textField resignFirstResponder];
        [m_txtSecondName becomeFirstResponder];
        
    } else if (textField == m_txtSecondName) {
        
        [textField resignFirstResponder];
        [m_txtEmail becomeFirstResponder];
        
    } else if (textField == m_txtEmail) {
        
        [textField resignFirstResponder];
        [m_txtPassword becomeFirstResponder];
        
    } else if (textField == m_txtPassword) {
        
        [self dismissKeyboard];
        [self onSignup:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self toggleKeyboard];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self toggleKeyboard];
    
    return YES;
    
}

- (void)toggleKeyboard {
    
    if (!toggleKeyboardIsOn) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        m_viewSignup.frame = CGRectMake(m_viewSignup.frame.origin.x, (m_viewSignup.frame.origin.y - 100.0), m_viewSignup.frame.size.width, m_viewSignup.frame.size.height);
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
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        m_viewSignup.frame = CGRectMake(m_viewSignup.frame.origin.x, (m_viewSignup.frame.origin.y + 100.0), m_viewSignup.frame.size.width, m_viewSignup.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = false;
    }
}

- (IBAction)onSignup:(id)sender {
    
    NSString* strFirstName = m_txtFirstName.text;
    NSString* strSecondName = m_txtSecondName.text;
    NSString* strEmail = m_txtEmail.text;
    NSString* strPassword = m_txtPassword.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strFirstName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_first_name", "")];
        return;
    } else if ([strSecondName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_second_name", "")];
        return;
    } else if ([strEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email", "")];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email_correct", "")];
        return;
    } else if ([strPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_password", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] signupArabian:TAG_REGISTER firstName:strFirstName lastName:strSecondName email:strEmail password:strPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 0) {
            
                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_user_registered", "")];
                
            } else if (success == 1) {
                
                [GlobalData sharedGlobalData].g_userInfo.firstName = strFirstName;
                [GlobalData sharedGlobalData].g_userInfo.lastName = strSecondName;
                [GlobalData sharedGlobalData].g_userInfo.email = strEmail;
                [GlobalData sharedGlobalData].g_userInfo.password = strPassword;
                [GlobalData sharedGlobalData].g_userInfo.address = @"";
                [GlobalData sharedGlobalData].g_userInfo.telephone = @"";
                [GlobalData sharedGlobalData].g_userInfo.signup = USER_LOGIN;
                
                [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                
                [[GlobalData sharedGlobalData].g_dataModel updateNoneCartDataDB];
                [[GlobalData sharedGlobalData].g_dataModel updateNoneWishlistDataDB];
                
                [[GlobalData sharedGlobalData].g_dataModel onLoadCartDataDB];
                [[GlobalData sharedGlobalData].g_dataModel onLoadWishlistDataDB];
                
                [self.view makeToast:NSLocalizedString(@"alert_register_success", "") duration:1.0 position:CSToastPositionBottom];
                
                [self performSegueWithIdentifier:UNWIND_SIGNUP sender:nil];
                
            } else {
                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_register_failed", "")];
            }
            
        } else {
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_register_failed", "")];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_register_failed", "")];
    }];
}

@end
