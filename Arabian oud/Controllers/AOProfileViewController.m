//
//  AOProfileViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOProfileViewController.h"
#import "AOShippingAddressViewController.h"
#import "AOOrdersViewController.h"

@interface AOProfileViewController () <UIAlertViewDelegate>

@end

@implementation AOProfileViewController

@synthesize m_lblUserName, m_lblEmail, m_lblPhone, m_lblAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_lblUserName.text = [NSString stringWithFormat:@"%@ %@", [GlobalData sharedGlobalData].g_userInfo.firstName, [GlobalData sharedGlobalData].g_userInfo.lastName];
    m_lblEmail.text = [GlobalData sharedGlobalData].g_userInfo.email;
    m_lblPhone.text = [GlobalData sharedGlobalData].g_userInfo.telephone;
    m_lblAddress.text = [GlobalData sharedGlobalData].g_userInfo.address;
    
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

- (IBAction)onTrackOrders:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_arrayOrder.count > 0) {
        
        AOOrdersViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_ORDERS];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else {
        
        [self.view makeToast:NSLocalizedString(@"no_order_found", "") duration:1.0 position:CSToastPositionBottom];
    }
}

- (IBAction)onStoredAddresses:(id)sender {
    
    [GlobalData sharedGlobalData].g_toggleProfileIsOn = true;
    
    AOShippingAddressViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SHIPPING_ADDRESS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onLogout:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                    message:NSLocalizedString(@"alert_log_out", "")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                          otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        // do something here...
        
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_LOGOUT;
        [GlobalData sharedGlobalData].g_userInfo.email = USER_NONE;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        [GlobalData sharedGlobalData].g_arrayCart = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_arrayWishlist = [[NSMutableArray alloc] init];
        
        [self performSegueWithIdentifier:UNWIND_LOGOUT sender:nil];
        
    } else if (buttonIndex == 1) { // Cancel
        //Code for cancel button
        
    }
}

@end
