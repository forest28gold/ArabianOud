//
//  AOContactUsViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/27/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOContactUsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AOContactUsViewController () <MFMailComposeViewControllerDelegate>
{
    BOOL toggleEmptyIsOn;
}

@end

@implementation AOContactUsViewController

@synthesize m_txtName, m_txtPhone, m_txtComment, m_txtSubject;
@synthesize m_viewName, m_viewPhone, m_viewComment, m_viewSubject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [m_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtSubject addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    toggleEmptyIsOn = true;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewName.layer.borderWidth = 1.0f;
    m_viewName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    m_viewPhone.layer.borderWidth = 1.0f;
    m_viewPhone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    m_viewSubject.layer.borderWidth = 1.0f;
    m_viewSubject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    m_viewComment.layer.borderWidth = 1.0f;
    m_viewComment.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:textField.text
                                                        options:0
                                                          range:NSMakeRange(0, [textField.text length])];
        if (match || textField.text.length == 0) {
            textField.textAlignment = NSTextAlignmentRight;
        } else {
            textField.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == m_txtName) {
        [textField resignFirstResponder];
        [m_txtPhone becomeFirstResponder];
    } else if (textField == m_txtPhone) {
        [textField resignFirstResponder];
        [m_txtSubject becomeFirstResponder];
    } else if (textField == m_txtSubject) {
        [textField resignFirstResponder];
        [m_txtComment becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([m_txtComment.text isEqualToString:NSLocalizedString(@"comment", "")]) {
        m_txtComment.text = @"";
        [m_txtComment setTextColor:[UIColor blackColor]];
        toggleEmptyIsOn = false;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([m_txtComment.text isEqualToString:@""]) {
        m_txtComment.text = NSLocalizedString(@"comment", "");
        [m_txtComment setTextColor:[UIColor lightGrayColor]];
        toggleEmptyIsOn = true;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:textView.text
                                                    options:0
                                                      range:NSMakeRange(0, [textView.text length])];
    if (match) {
        textView.textAlignment = NSTextAlignmentRight;
    } else {
        textView.textAlignment = NSTextAlignmentLeft;
    }
    
    return true;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    
    NSString* strName = m_txtName.text;
    NSString* strPhone = m_txtPhone.text;
    NSString* strSubject = m_txtSubject.text;
    
    if ([strName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_email", "")];
        return;
    } else if ([strPhone isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_phone_number", "")];
        return;
    } else if ([strSubject isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_subject", "")];
        return;
    } else if (toggleEmptyIsOn) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_comment", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    NSData *data = [m_txtComment.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *strComment = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[CONTACT_MAIL]];
        [mailController setSubject:strSubject];
        [mailController setMessageBody:[NSString stringWithFormat:@"%@ \n%@ \n%@", strComment, strName, strPhone] isHTML:NO];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
        
        m_txtName.text = @"";
        m_txtPhone.text = @"";
        m_txtSubject.text = @"";
        m_txtComment.text = NSLocalizedString(@"comment", "");
        [m_txtComment setTextColor:[UIColor lightGrayColor]];
        toggleEmptyIsOn = true;
        
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_cant_send_message", "")];
        return;
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_cancelled", "")];
            break;
        case MFMailComposeResultSaved:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_saved", "")];
            break;
        case MFMailComposeResultSent:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_sent", "")];
            break;
        case MFMailComposeResultFailed:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_failed", "")];
            break;
        default:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_not_sent", "")];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onContactWhatsapp:(id)sender {
    
//    NSURL *whatsappUrl = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://smsto?abid=%@", CONTACT_WHATSAPP]];   //@"skype://%@?call"
    NSURL *whatsappUrl = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://%@?smsto", CONTACT_WHATSAPP]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]]) {
        [[UIApplication sharedApplication] openURL:whatsappUrl];
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_device_not_install_whatsapp", "")];
    }
}

- (IBAction)onContactPhone:(id)sender {
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", CONTACT_PHONE]];  //@"telprompt:%@"
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_call_not_available", "")];
        return;
    }
}

@end
