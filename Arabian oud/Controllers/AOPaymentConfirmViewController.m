//
//  AOPaymentConfirmViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOPaymentConfirmViewController.h"
#import "AOOrderDetailsViewController.h"

@interface AOPaymentConfirmViewController ()

@end

@implementation AOPaymentConfirmViewController

@synthesize m_lblOrderNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_lblOrderNumber.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"order_number", ""), [GlobalData sharedGlobalData].g_orderData.orderID];
    
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self performSegueWithIdentifier:UNWIND_PAYMENT_CONFIRM sender:nil];
}

- (IBAction)onOrderDetails:(id)sender {

    AOOrderDetailsViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_ORDER_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onContinueShopping:(id)sender {
    
    [self performSegueWithIdentifier:UNWIND_PAYMENT_CONFIRM sender:nil];
}

@end
