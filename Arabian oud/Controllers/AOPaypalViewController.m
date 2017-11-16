//
//  AOPaypalViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/10/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOPaypalViewController.h"
#import "AOPaymentConfirmViewController.h"

#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"

#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface AOPaypalViewController () <UIAlertViewDelegate, PayPalPaymentDelegate>
{
    float totalCost;
    float shippingCost;
    NSString *strIds;
    NSString *strQtys;
    NSString *strTotal;
    
    NSMutableArray *arrayPaypalItems;
    BOOL togglePaymentIsOn;
}

@property (strong,nonatomic) PayPalConfiguration *payPalConfig;

@end

@implementation AOPaypalViewController

@synthesize m_btnPurchase;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_btnPurchase.hidden = YES;
    togglePaymentIsOn = false;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    [self setPaypalConfiguration];
    [self onPaymentWithPaypal];
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

- (IBAction)onConfirmPayment:(id)sender {
    
    if (!togglePaymentIsOn) {
        [self onPaymentWithPaypal];
    } else {
        SVPROGRESSHUD_SHOW;
        [self onCheckout];
    }
}

- (void)setPaypalConfiguration {
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = PAYPAL_MERCHANT_NAME;
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:PAYPAL_MERCHANT_PRIVACY_POLICY_URL];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:PAYPAL_MERCHANT_USER_AGREEMENT_URL];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
//    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

- (void)onPaymentWithPaypal {
    
    totalCost = 0.0f;
    shippingCost = 0.0f;
    strIds = @"";
    strQtys = @"";
    
    arrayPaypalItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayCart.count; i++) {
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[i];
        totalCost += [record.discount floatValue] * record.productCount;
        
        if (i == 0) {
            strIds = record.productId;
            strQtys = [NSString stringWithFormat:@"%i", record.productCount];
        } else {
            strIds = [NSString stringWithFormat:@"%@,%@", strIds, record.productId];
            strQtys = [NSString stringWithFormat:@"%@,%i", strQtys, record.productCount];
        }
        
        float price = [record.discount floatValue];
        
        if ([[GlobalData sharedGlobalData].g_strCouponCode isEqualToString:@""]) {
            price = price / CURRENCY_RATE;
        } else {
            float discountCost = price * [GlobalData sharedGlobalData].g_discountPercent / 100;
            price = (price - discountCost) / CURRENCY_RATE;
        }
        
        NSString *strPrice = [NSString stringWithFormat:@"%.2f", price];
        
        PayPalItem *item = [PayPalItem itemWithName:record.name
                                        withQuantity:record.productCount
                                           withPrice:[NSDecimalNumber decimalNumberWithString:strPrice]
                                        withCurrency:CURRENCY_CODE_PAYPAL
                                             withSku:record.sku];
        
        [arrayPaypalItems addObject:item];
    }
    
    if (totalCost < 200) {
        shippingCost = 20.0f;
    }

    strTotal = [NSString stringWithFormat:@"%f", totalCost];
    
    NSString *strShipping = [NSString stringWithFormat:@"%.2f", shippingCost/CURRENCY_RATE];

    NSArray *items = [NSArray arrayWithArray:arrayPaypalItems];
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:strShipping];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:PAYPAL_TAX];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = CURRENCY_CODE_PAYPAL;
    payment.shortDescription = NSLocalizedString(@"alert_arabianoud_payment", "");
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    if (payment.processable) {
        
        PayPalPaymentViewController *paymentviewcontroller = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.payPalConfig delegate:self];
        [self presentViewController:paymentviewcontroller animated:YES completion:nil];
        
    } else {
        
        [self.view makeToast:NSLocalizedString(@"alert_paypal_cancel", "") duration:1.0 position:CSToastPositionBottom];
        togglePaymentIsOn = false;
        m_btnPurchase.hidden = NO;
    }
}

#pragma mark PayPalPaymentDelegate methods

-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Cancle...");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view makeToast:NSLocalizedString(@"alert_paypal_cancel", "") duration:1.0 position:CSToastPositionBottom];
    
    togglePaymentIsOn = false;
    m_btnPurchase.hidden = NO;
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success...");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view makeToast:NSLocalizedString(@"alert_paypal_success", "") duration:1.0 position:CSToastPositionBottom];
    
    togglePaymentIsOn = true;
    m_btnPurchase.hidden = YES;
    
    SVPROGRESSHUD_SHOW;
    
    [self onCheckoutPaypal];
}

- (void)onCheckoutPaypal {
    
    [[APIManager sharedManager] checkoutPaypal:TAG_PAYPAL email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 1) {
                
                SVPROGRESSHUD_DISMISS;
                
                NSString *strOrderId = responseObject[KEY_ORDER_ID];
                
                float discountCost = totalCost * ([GlobalData sharedGlobalData].g_discountPercent / 100);
                
                OrderData *record = [[OrderData alloc] init];
                record.orderID = strOrderId;
                record.date = [[GlobalData sharedGlobalData] getCurrentDate];
                record.ship = [NSString stringWithFormat:@"%f", shippingCost];
                record.total = [NSString stringWithFormat:@"%f", totalCost + shippingCost - discountCost];
                record.type = PAYMENT_PAYPAL;
                record.username = [NSString stringWithFormat:@"%@ %@", [GlobalData sharedGlobalData].g_userInfo.firstName, [GlobalData sharedGlobalData].g_userInfo.lastName];
                record.address = [GlobalData sharedGlobalData].g_addressData.street;
                record.telephone = [GlobalData sharedGlobalData].g_addressData.telephone;
                record.couponCode = [GlobalData sharedGlobalData].g_strCouponCode;
                record.discountPercent = [NSString stringWithFormat:@"%f", [GlobalData sharedGlobalData].g_discountPercent];
                
                [[GlobalData sharedGlobalData].g_dataModel insertOrderDataDB:record];
                [[GlobalData sharedGlobalData].g_dataModel insertProductDataDB:[GlobalData sharedGlobalData].g_arrayCart orderId:strOrderId];
                
                [[GlobalData sharedGlobalData].g_dataModel deleteAllCartDataDB];
                [[GlobalData sharedGlobalData].g_arrayCart removeAllObjects];
                
                [[GlobalData sharedGlobalData].g_arrayOrder addObject:record];
                
                [GlobalData sharedGlobalData].g_orderData = [[OrderData alloc] init];
                [GlobalData sharedGlobalData].g_orderData = record;
                
                AOPaymentConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_PAYMENT_CONFIRM];
                [self.navigationController pushViewController:nextCtrl animated:true];
                
            } else {
                [self onCheckout];
            }
            
        } else {
            [self onShowCheckoutErrorAlert];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onShowCheckoutErrorAlert];
    }];
}

- (void)onCheckout {
    
    [[APIManager sharedManager] deleteCart:TAG_DELETE_CART email:[GlobalData sharedGlobalData].g_userInfo.email success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 1) {
                
                [[APIManager sharedManager] addToCart:TAG_ADD_TO_CART ids:strIds qtys:strQtys email:[GlobalData sharedGlobalData].g_userInfo.email success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject) {
                        
                        int success = [responseObject[KEY_SUCCESS] intValue];
                        
                        if (success == 1) {
                            
//                            int intTotal = [responseObject[KEY_TOTAL] intValue];
//                            NSString* strTotal = [NSString stringWithFormat:@"%i", intTotal];
//                            
//                            NSLog(@"=========  Total ===========  %@", strTotal);
                            
                            [[APIManager sharedManager] checkoutPaypal:TAG_PAYPAL email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                if (responseObject) {
                                    
                                    int success = [responseObject[KEY_SUCCESS] intValue];
                                    
                                    if (success == 1) {
                                        
                                        SVPROGRESSHUD_DISMISS;
                                        
                                        NSString *strOrderId = responseObject[KEY_ORDER_ID];
                                        
                                        float discountCost = totalCost * ([GlobalData sharedGlobalData].g_discountPercent / 100);
                                        
                                        OrderData *record = [[OrderData alloc] init];
                                        record.orderID = strOrderId;
                                        record.date = [[GlobalData sharedGlobalData] getCurrentDate];
                                        record.ship = [NSString stringWithFormat:@"%f", shippingCost];
                                        record.total = [NSString stringWithFormat:@"%f", totalCost + shippingCost - discountCost];
                                        record.type = PAYMENT_PAYPAL;
                                        record.username = [NSString stringWithFormat:@"%@ %@", [GlobalData sharedGlobalData].g_userInfo.firstName, [GlobalData sharedGlobalData].g_userInfo.lastName];
                                        record.address = [GlobalData sharedGlobalData].g_addressData.street;
                                        record.telephone = [GlobalData sharedGlobalData].g_addressData.telephone;
                                        record.couponCode = [GlobalData sharedGlobalData].g_strCouponCode;
                                        record.discountPercent = [NSString stringWithFormat:@"%f", [GlobalData sharedGlobalData].g_discountPercent];
                                        
                                        [[GlobalData sharedGlobalData].g_dataModel insertOrderDataDB:record];
                                        [[GlobalData sharedGlobalData].g_dataModel insertProductDataDB:[GlobalData sharedGlobalData].g_arrayCart orderId:strOrderId];
                                        
                                        [[GlobalData sharedGlobalData].g_dataModel deleteAllCartDataDB];
                                        [[GlobalData sharedGlobalData].g_arrayCart removeAllObjects];
                                        
                                        [[GlobalData sharedGlobalData].g_arrayOrder addObject:record];
                                        
                                        [GlobalData sharedGlobalData].g_orderData = [[OrderData alloc] init];
                                        [GlobalData sharedGlobalData].g_orderData = record;
                                        
                                        AOPaymentConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_PAYMENT_CONFIRM];
                                        [self.navigationController pushViewController:nextCtrl animated:true];
                                        
                                    } else {
                                        [self onShowCheckoutErrorAlert];
                                    }
                                    
                                } else {
                                    [self onShowCheckoutErrorAlert];
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [self onShowCheckoutErrorAlert];
                            }];
                            
                        } else {
                            [self onShowCheckoutStockErrorAlert];
                        }
                        
                    } else {
                        [self onShowCheckoutStockErrorAlert];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self onShowCheckoutStockErrorAlert];
                }];
                
            } else {
                [self onShowCheckoutErrorAlert];
            }
            
        } else {
            [self onShowCheckoutErrorAlert];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onShowCheckoutErrorAlert];
    }];
}

- (void)onShowCheckoutStockErrorAlert {
    
    SVPROGRESSHUD_DISMISS;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_product_out", "")
                                                    message:NSLocalizedString(@"alert_some_product_out_stock", "")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)onShowCheckoutErrorAlert {
    
    SVPROGRESSHUD_DISMISS;
    [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_order_failed", "")];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self performSegueWithIdentifier:UNWIND_PAYPAL_CART sender:nil];
}

@end
