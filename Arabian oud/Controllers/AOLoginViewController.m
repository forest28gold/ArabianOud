//
//  AOLoginViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOLoginViewController.h"
#import "AOSignupViewController.h"
#import "AOForgotPasswordViewController.h"

@interface AOLoginViewController ()

@end

@implementation AOLoginViewController

@synthesize m_txtEmail, m_txtPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    if (textField == m_txtEmail) {
        
        [textField resignFirstResponder];
        [m_txtPassword becomeFirstResponder];
        
    } else if (textField == m_txtPassword) {
        
        [self dismissKeyboard];
        [self onLogin:textField];
    }
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onLogin:(id)sender {
    
    NSString* strEmail = m_txtEmail.text;
    NSString* strPassword = m_txtPassword.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email", "")];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email_correct", "")];
        return;
    } else if ([strPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_password", "")];
        return;
    } else if (strPassword.length < 6) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_password_correct", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] loginArabian:TAG_LOGIN email:strEmail password:strPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 1) {
                
                NSArray* arrayUserData = responseObject[KEY_CUSTOMER_DATA];
                
                [GlobalData sharedGlobalData].g_userInfo.signup = USER_LOGIN;
                [GlobalData sharedGlobalData].g_userInfo.firstName = [self getFormattedString:arrayUserData[1]];
                [GlobalData sharedGlobalData].g_userInfo.lastName = [self getFormattedString:arrayUserData[2]];
                [GlobalData sharedGlobalData].g_userInfo.email = [self getFormattedString:arrayUserData[0]];
                [GlobalData sharedGlobalData].g_userInfo.userID = [self getFormattedString:arrayUserData[3]];
                [GlobalData sharedGlobalData].g_userInfo.telephone = [self getFormattedString:arrayUserData[6]];
                [GlobalData sharedGlobalData].g_userInfo.password = strPassword;
                
                NSString *strAddress1 = [self getFormattedString:arrayUserData[4]];
                NSString *strAddress2 = [self getFormattedString:arrayUserData[5]];
                
                if ([strAddress1 isEqualToString:@""] && [strAddress2 isEqualToString:@""]) {
                    [GlobalData sharedGlobalData].g_userInfo.address = @"";
                } else if (![strAddress1 isEqualToString:@""] && [strAddress2 isEqualToString:@""]) {
                    [GlobalData sharedGlobalData].g_userInfo.address = strAddress1;
                } else if ([strAddress1 isEqualToString:@""] && ![strAddress2 isEqualToString:@""]) {
                    [GlobalData sharedGlobalData].g_userInfo.address = strAddress2;
                } else {
                    [GlobalData sharedGlobalData].g_userInfo.address = [NSString stringWithFormat:@"%@ / %@", strAddress1, strAddress2];
                }
                
                [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                
                [[GlobalData sharedGlobalData].g_dataModel updateNoneCartDataDB];
                [[GlobalData sharedGlobalData].g_dataModel updateNoneWishlistDataDB];
                
                [[GlobalData sharedGlobalData].g_dataModel onLoadCartDataDB];
                [[GlobalData sharedGlobalData].g_dataModel onLoadWishlistDataDB];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_email_password", "")];
            }
            
        } else {
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_email_password", "")];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_login_failed", "")];
    }];
    
}

- (NSString*)getFormattedString:(id)strData {
    
    if ([strData isKindOfClass:[NSNull class]]) {
        strData = @"";
    }
    
    return strData;
}

- (IBAction)onSignup:(id)sender {
    
    AOSignupViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onForgotPassword:(id)sender {
    
    AOForgotPasswordViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_FORGOT_PASSWORD];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)unwindSignup:(UIStoryboardSegue *)unwindSegue {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
