//
//  AOSelectRegionViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOSelectRegionViewController.h"
#import "AOMainViewController.h"

@interface AOSelectRegionViewController () <UIAlertViewDelegate>
{
    NSString *strLanguage;
}


@end

@implementation AOSelectRegionViewController

@synthesize m_lblArabian, m_lblEnglish, m_viewRegion, m_viewLanguage, m_lblSelectRegion;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewRegion.hidden = YES;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language containsString:LANGUAGE_ARABIAN]) {
        
        m_lblEnglish.hidden = YES;
        m_lblArabian.hidden = NO;
        strLanguage = LANGUAGE_ARABIAN;
        
    } else if ([language containsString:LANGUAGE_ENGLISH]) {
        
        m_lblEnglish.hidden = NO;
        m_lblArabian.hidden = YES;
        strLanguage = LANGUAGE_ENGLISH;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseRegion)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapLanguage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectRegion)];
    tapLanguage.cancelsTouchesInView = NO;
    [m_viewLanguage addGestureRecognizer:tapLanguage];
    
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewLanguage.layer.cornerRadius = 2.0f;
    m_viewLanguage.layer.borderWidth = 1.0f;
    m_viewLanguage.layer.borderColor = [UIColor blackColor].CGColor;
    m_viewRegion.layer.cornerRadius = 4.0f;
    m_viewRegion.layer.borderColor = [UIColor colorWithHexString:@"aabfbfbf"].CGColor;
    m_viewRegion.layer.shadowOpacity = 0.6;
    m_viewRegion.layer.shadowRadius = 3.0f;
    m_viewRegion.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    
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

- (void)onCloseRegion {
    [self closeAnimationView:m_viewRegion];
}

- (void)onSelectRegion {
    
    if (m_viewRegion.isHidden) {
        [self showAnimationView:m_viewRegion];
    } else {
        [self closeAnimationView:m_viewRegion];
    }
}

- (IBAction)onSelectEnglish:(id)sender {
    
    [self closeAnimationView:m_viewRegion];
    m_lblEnglish.hidden = NO;
    m_lblArabian.hidden = YES;
    
    strLanguage = LANGUAGE_ENGLISH;
}

- (IBAction)onSelectArabian:(id)sender {

    [self closeAnimationView:m_viewRegion];
    m_lblEnglish.hidden = YES;
    m_lblArabian.hidden = NO;
    
    strLanguage = LANGUAGE_ARABIAN;
}

- (IBAction)onSave:(id)sender {
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language containsString:LANGUAGE_ARABIAN] && [strLanguage isEqualToString:LANGUAGE_ARABIAN]) {
        
        [GlobalData sharedGlobalData].g_userInfo.language = strLanguage;
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_SIGNUP;
        [GlobalData sharedGlobalData].g_userInfo.email = USER_NONE;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        AOMainViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MAIN];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else if ([language containsString:LANGUAGE_ENGLISH] && [strLanguage isEqualToString:LANGUAGE_ENGLISH]) {
        
        [GlobalData sharedGlobalData].g_userInfo.language = strLanguage;
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_SIGNUP;
        [GlobalData sharedGlobalData].g_userInfo.email = USER_NONE;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        AOMainViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MAIN];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                        message:NSLocalizedString(@"change_language", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        
        [GlobalData sharedGlobalData].g_userInfo.language = strLanguage;
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_SIGNUP;
        [GlobalData sharedGlobalData].g_userInfo.email = USER_NONE;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        exit(0);
        
    } else if (buttonIndex == 1) { // Cancel

    }
}

@end
