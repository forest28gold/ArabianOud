//
//  AOCheckOutViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOCheckOutViewController.h"
#import "AOPaymentConfirmViewController.h"
#import "AOBankTransferViewController.h"
#import "AOCreditCardViewController.h"
#import "AOPaypalViewController.h"

@interface AOCheckOutViewController () <UIScrollViewDelegate, UIAlertViewDelegate>
{
    NSString *strPaymentMethod;
    float totalCost;
    float shippingCost;
    NSString *strIds;
    NSString *strQtys;
    NSString *strTotal;
}

@end

@implementation AOCheckOutViewController

@synthesize m_imgArrow, m_lblPhone, m_btnMethod, m_tableView;
@synthesize m_viewMethod, m_lblLocation, m_lblShipping, m_lblSubTotal;
@synthesize m_lblUsername, m_lblGrandTotal;
@synthesize m_btnApply, m_txtCoupon, m_viewCoupon, m_btnCancel;
@synthesize m_lblDiscountTotal, m_lblDiscount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewMethod.hidden = YES;
    strPaymentMethod = PAYMENT_CASH;
    
    m_lblUsername.text = [NSString stringWithFormat:@"%@ %@", [GlobalData sharedGlobalData].g_userInfo.firstName, [GlobalData sharedGlobalData].g_userInfo.lastName];
    m_lblLocation.text = [GlobalData sharedGlobalData].g_addressData.street;
    m_lblPhone.text = [GlobalData sharedGlobalData].g_addressData.telephone;
    
    [GlobalData sharedGlobalData].g_strShippingAddress = [NSString stringWithFormat:@"%@ %@\n%@, %@\nT:%@", [GlobalData sharedGlobalData].g_userInfo.firstName, [GlobalData sharedGlobalData].g_userInfo.lastName, [GlobalData sharedGlobalData].g_addressData.city, [GlobalData sharedGlobalData].g_addressData.street, [GlobalData sharedGlobalData].g_addressData.telephone];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClosePaymentMethod)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapPayment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPaymentMethod)];
    tapPayment.cancelsTouchesInView = NO;
    [m_btnMethod addGestureRecognizer:tapPayment];
    
    [GlobalData sharedGlobalData].g_strCouponCode = @"";
    [GlobalData sharedGlobalData].g_discountPercent = 0.0f;
    
    m_lblDiscount.text = NSLocalizedString(@"discount", "");
    m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", [GlobalData sharedGlobalData].g_discountPercent]];
    
    m_btnApply.hidden = NO;
    m_btnCancel.hidden = YES;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewMethod.layer.cornerRadius = 2.0f;
    m_viewMethod.layer.borderColor = [UIColor colorWithHexString:@"aabfbfbf"].CGColor;
    m_viewMethod.layer.shadowOpacity = 0.6;
    m_viewMethod.layer.shadowRadius = 3.0f;
    m_viewMethod.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    m_viewCoupon.layer.borderWidth = 1.0f;
    m_viewCoupon.layer.borderColor = [UIColor colorWithHexString:@"bebfbd"].CGColor;
    
    [self onCalculateGrandTotal];
    
    [self addProductToCart];
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
    
    m_lblSubTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost]];
    m_lblShipping.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", shippingCost]];
    m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost]];
    
    strTotal = [NSString stringWithFormat:@"%f", totalCost];
}

- (void)addProductToCart {
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] deleteCart:TAG_DELETE_CART email:[GlobalData sharedGlobalData].g_userInfo.email success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 1) {
                
                [[APIManager sharedManager] addToCart:TAG_ADD_TO_CART ids:strIds qtys:strQtys email:[GlobalData sharedGlobalData].g_userInfo.email success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject) {
                        
                        int success = [responseObject[KEY_SUCCESS] intValue];
                        
                        if (success == 1) {
                            
                            SVPROGRESSHUD_DISMISS;
                            
                            int intTotal = [responseObject[KEY_TOTAL] intValue];
                            strTotal = [NSString stringWithFormat:@"%i", intTotal];
                            
                            NSLog(@"=========  Total ===========  %@", strTotal);
                            
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
                [self onShowCheckoutStockErrorAlert];
            }
            
        } else {
            [self onShowCheckoutStockErrorAlert];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onShowCheckoutStockErrorAlert];
    }];
}

- (IBAction)onBack:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCouponCode = @"";
    [GlobalData sharedGlobalData].g_discountPercent = 0.0f;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayCart.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CheckoutCell" forIndexPath:indexPath];
    
    UILabel *m_lblShipment = (UILabel*)[_cell viewWithTag:1];
    UILabel *m_lblCount = (UILabel*)[_cell viewWithTag:2];
    UILabel *m_lblProductName = (UILabel*)[_cell viewWithTag:3];
    UILabel *m_lblCost = (UILabel*)[_cell viewWithTag:4];
    UIImageView *m_imgProduct = (UIImageView*)[_cell viewWithTag:5];
    
    m_lblShipment.text = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"shipment", ""), (int)indexPath.row + 1];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:record.image];
    [m_imgProduct setShowActivityIndicatorView:YES];
    [m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    m_lblProductName.text = record.name;
    m_lblCost.text = [self getFormattedPrice:record.discount];
    m_lblCount.text = [NSString stringWithFormat:@"%ix", record.productCount];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!m_viewMethod.isHidden) {
        [self closeAnimationView:m_viewMethod];
    }
    
    [self dismissKeyboard];
}

- (NSString *)getFormattedPrice:(NSString *)price {
    
    if ([price containsString:@"."]) {
        NSArray *items = [price componentsSeparatedByString:@"."];
        price = [NSString stringWithFormat:@"%@.%@ %@", [items objectAtIndex:0], [[items objectAtIndex:1] substringToIndex:2], CURRENCY_CODE];
    } else {
        price = [NSString stringWithFormat:@"%@.00 %@", price, CURRENCY_CODE];
    }
    
    return price;
}

//------------- Payment Method ------------

- (void)showAnimationView:(UIView *)mView {
    
    mView.hidden = NO;
    mView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 1;
        m_imgArrow.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationView:(UIView *)mView {
    
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 0;
        mView.hidden = YES;
        m_imgArrow.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)onClosePaymentMethod {
    [self closeAnimationView:m_viewMethod];
}

- (void)onSelectPaymentMethod {
    
    if (m_viewMethod.isHidden) {
        [self showAnimationView:m_viewMethod];
    } else {
        [self closeAnimationView:m_viewMethod];
    }
}

- (IBAction)onCashPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_CASH;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_cash", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

- (IBAction)onBankPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_BANK;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_bank", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

- (IBAction)onPaypalPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_PAYPAL;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_paypal", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

- (IBAction)onCreditPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_CREDIT;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_credit", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onDiscountCouponCancel:(id)sender {
    
    m_txtCoupon.text = @"";
    m_btnCancel.hidden = YES;
    [m_btnApply setEnabled:true];
    [m_txtCoupon setEnabled:true];
    
    [GlobalData sharedGlobalData].g_strCouponCode = @"";
    [GlobalData sharedGlobalData].g_discountPercent = 0.0f;
    
    m_lblDiscount.text = NSLocalizedString(@"discount", "");
    m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", [GlobalData sharedGlobalData].g_discountPercent]];
    m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost]];
    
    [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_cancel_coupon", "")];
}

- (IBAction)onDiscountCouponApply:(id)sender {
    
    NSString *strCouponCode = m_txtCoupon.text;
    
    if ([strCouponCode isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_coupon", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] setCouponCode:TAG_SET_COUPON_CODE couponCode:strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            int success = [responseObject[KEY_SUCCESS] intValue];
            
            if (success == 1) {
                
                SVPROGRESSHUD_DISMISS;

                NSString *strCouponName = responseObject[KEY_SHOPCART_NAME];
                
                if ([strCouponName isEqualToString:INVALID_COUPON_CODE] || [strCouponName isEqualToString:@""]) {
                    
                    [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_coupon", "")];
                    
                    m_btnCancel.hidden = YES;
                    [m_btnApply setEnabled:true];
                    [m_txtCoupon setEnabled:true];
                    
                    [GlobalData sharedGlobalData].g_strCouponCode = @"";
                    [GlobalData sharedGlobalData].g_discountPercent = 0.0f;
                    
                } else {
                    
                    [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_success_coupon", "")];
                    
                    m_btnCancel.hidden = NO;
                    [m_btnApply setEnabled:false];
                    [m_txtCoupon setEnabled:false];
                    
                    [GlobalData sharedGlobalData].g_strCouponCode = strCouponCode;
                    [GlobalData sharedGlobalData].g_discountPercent = [responseObject[KEY_SHOPCART_RULE] floatValue];
                }
                
                if ([[GlobalData sharedGlobalData].g_strCouponCode isEqualToString:@""]) {
                    
                    m_lblDiscount.text = NSLocalizedString(@"discount", "");
                    m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", [GlobalData sharedGlobalData].g_discountPercent]];
                    m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost]];
                    
                } else {
                    
                    m_lblDiscount.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"discount", ""), [GlobalData sharedGlobalData].g_strCouponCode];
                    
                    float discountCost = totalCost * ([GlobalData sharedGlobalData].g_discountPercent / 100);
                    
                    m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", discountCost]];
                    m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost - discountCost]];
                }
                
            } else {
                SVPROGRESSHUD_DISMISS;
                [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_coupon", "")];
            }
        } else {
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_coupon", "")];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_coupon", "")];
    }];
}

//------------ Make Payment -------------

- (IBAction)onMakePayment:(id)sender {
    
    if ([strPaymentMethod isEqualToString:PAYMENT_CASH]) {
        
        SVPROGRESSHUD_SHOW;
        
        [[APIManager sharedManager] checkout:TAG_CHECKOUT email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
                    record.type = PAYMENT_CASH;
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
        
    } else if ([strPaymentMethod isEqualToString:PAYMENT_BANK]) {
        
        AOBankTransferViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BANK_TRANSFER];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else if ([strPaymentMethod isEqualToString:PAYMENT_PAYPAL]) {
        
        AOPaypalViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_PAYPAL];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else if ([strPaymentMethod isEqualToString:PAYMENT_CREDIT]) {
        
        AOCreditCardViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_CREDIT_CARD];
        [self.navigationController pushViewController:nextCtrl animated:true];
    }
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
                            
                            int intTotal = [responseObject[KEY_TOTAL] intValue];
                            strTotal = [NSString stringWithFormat:@"%i", intTotal];
                            
                            NSLog(@"=========  Total ===========  %@", strTotal);
                            
                            [[APIManager sharedManager] checkout:TAG_CHECKOUT email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
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
                                        record.type = PAYMENT_CASH;
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
    
    [self performSegueWithIdentifier:UNWIND_CHECKOUT_CART sender:nil];
}

@end
