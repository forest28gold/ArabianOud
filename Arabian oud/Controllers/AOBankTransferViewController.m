//
//  AOBankTransferViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOBankTransferViewController.h"
#import "AOPaymentConfirmViewController.h"

@interface AOBankTransferViewController () <UIAlertViewDelegate>
{
    NSArray *arrayBankName;
    NSArray *arrayIBAN;

    float totalCost;
    float shippingCost;
    NSString *strIds;
    NSString *strQtys;
    NSString *strTotal;
}

@end

@implementation AOBankTransferViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        arrayBankName = [NSArray arrayWithObjects:@"بنك ساب ( السعودي البريطاني )", @"مصرف الراجحي", nil];
        arrayIBAN = [NSArray arrayWithObjects:@"إذا كنت أحد عملاء بنك ساب : 001292721001 \nإذا كنت عميلاً لأحد المصارف الآخرى استخدم رق \n الآيبان : SA3245000000001292721001", @"إذا كنت أحد عملاء بنك الراجحي : 126608010073020 \nإذا كنت عميلاً لأحد المصارف الآخرى استخدم رق \n الآيبان : SA2680000126608010073020", nil];
        
    } else {
        
        arrayBankName = [NSArray arrayWithObjects:@"SABB Bank", @"Al-Rajhi Bank", nil];
        arrayIBAN = [NSArray arrayWithObjects:@"If you are a current SABB Client : 001292721001 \nIf you are a Client for any other Bank, Kindly use this \nIBAN : SA3245000000001292721001", @"If you are a current Al-Rajhi Client : 126608010073020 \nIf you are a Client for any other Bank, Kindly use this \nIBAN : SA2680000126608010073020", nil];
    }
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    [self onCalculateGrandTotal];
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

- (void)onCalculateGrandTotal {
    
    totalCost = 0.0f;
    shippingCost = 0.0f;
    strIds = @"";
    strQtys = @"";
    
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
    }
    
    if (totalCost < 200) {
        shippingCost = 20.0f;
    }
    
    strTotal = [NSString stringWithFormat:@"%f", totalCost];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBankName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BankCell" forIndexPath:indexPath];
    
    UILabel *m_lblBankName = (UILabel*)[_cell viewWithTag:1];
    UILabel *m_lblIBAN = (UILabel*)[_cell viewWithTag:2];
    
    m_lblBankName.text = arrayBankName[indexPath.row];
    m_lblIBAN.text = arrayIBAN[indexPath.row];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMakePayment:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] checkoutBankTransfer:TAG_BANK_TRANSFER email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                record.type = PAYMENT_BANK;
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
                            
                            [[APIManager sharedManager] checkoutBankTransfer:TAG_BANK_TRANSFER email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
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
                                        record.type = PAYMENT_BANK;
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
    
    [self performSegueWithIdentifier:UNWIND_BANK_TRANSFER_CART sender:nil];
}

@end
