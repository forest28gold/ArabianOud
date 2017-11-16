//
//  AOForgotPasswordViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOForgotPasswordViewController.h"

@interface AOForgotPasswordViewController () <UIAlertViewDelegate>

@end

@implementation AOForgotPasswordViewController

@synthesize m_txtEmail;

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
    
    [self dismissKeyboard];
    [self onSend:textField];
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onSend:(id)sender {
    
    NSString* strEmail = m_txtEmail.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email", "")];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email_correct", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] forgotPassword:TAG_FORGET_PASSWORD email:strEmail success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        SVPROGRESSHUD_DISMISS;
        
//        if (responseObject) {
//            
//            int success = [responseObject[KEY_SUCCESS] intValue];
//            
//            if (success == 1) {
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
//                                                                message:NSLocalizedString(@"alert_email_sent_password", "")
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"ok", "")
//                                                      otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
//                
//                [alert show];
//                
//            } else {
//                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_reset_password_failed", "")];
//            }
//            
//        } else {
//            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_reset_password_failed", "")];
//        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                        message:NSLocalizedString(@"alert_email_sent_password", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
//        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_reset_password_failed", "")];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                        message:NSLocalizedString(@"alert_email_sent_password", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
        
        [alert show];
        
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        // do something here...
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (buttonIndex == 1) { // Cancel
        //Code for cancel button
        
    }
}

@end
