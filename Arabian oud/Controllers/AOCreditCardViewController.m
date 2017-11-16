//
//  AOCreditCardViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOCreditCardViewController.h"
#import "AOPaymentConfirmViewController.h"
#import <OPPWAMobile/OPPWAMobile.h>

@interface AOCreditCardViewController () <UIAlertViewDelegate>
{
    NSString *strPaymentMethod;
    float totalCost;
    float shippingCost;
    NSString *strIds;
    NSString *strQtys;
    NSString *strTotal;
    
    BOOL togglePaymentIsOn;
    NSString *strCheckoutID;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;

@property (strong, nonatomic) OPPPaymentProvider *provider;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;

@end

@implementation AOCreditCardViewController
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    
    int year;
    int month;
}

@synthesize m_txtCVV, m_txtUserName, m_txtCardNumber, m_txtExpireDate;
@synthesize m_viewMethod, m_btnMethod, m_imgArrow, m_viewPicker, m_viewPurchase;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewMethod.hidden = YES;
    strPaymentMethod = @"";
    togglePaymentIsOn = false;
    m_viewPurchase.hidden = YES;
    strCheckoutID = @"";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClosePaymentMethod)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapLanguage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPaymentMethod)];
    tapLanguage.cancelsTouchesInView = NO;
    [m_btnMethod addGestureRecognizer:tapLanguage];
    
    [m_txtUserName addTarget:self action:@selector(nameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtCardNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self initSetPicker];

    self.provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeTest];  // OPPProviderModeLive
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewMethod.layer.cornerRadius = 2.0f;
    m_viewMethod.layer.borderColor = [UIColor colorWithHexString:@"aabfbfbf"].CGColor;
    m_viewMethod.layer.shadowOpacity = 0.6;
    m_viewMethod.layer.shadowRadius = 3.0f;
    m_viewMethod.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    
    self.m_viewPicker.frame = CGRectMake(self.m_viewPicker.frame.origin.x, (self.view.frame.size.height + self.m_viewPicker.frame.size.height), self.m_viewPicker.frame.size.width, self.m_viewPicker.frame.size.height);
    
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

- (void)nameTextFieldDidChange:(UITextField *)textField {
    [self arabicFormat:textField];
}

- (void)arabicFormat:(UITextField *)textField {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:textField.text
                                                    options:0
                                                      range:NSMakeRange(0, [textField.text length])];
    if (match) {
        textField.textAlignment = NSTextAlignmentRight;
    } else {
        textField.textAlignment = NSTextAlignmentLeft;
    }
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN] && textField.text.length == 0) {
        textField.textAlignment = NSTextAlignmentRight;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([textField.text length] > 19) {
        textField.text= [textField.text substringToIndex:[textField.text length] - 1];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == m_txtUserName) {
        [textField resignFirstResponder];
        [m_txtCardNumber becomeFirstResponder];
    } else if (textField == m_txtCardNumber) {
        [self dismissKeyboard];
        [self showAnimationPickerView:m_viewPicker];
    } else if (textField == m_txtCVV) {
        [self dismissKeyboard];
        [self onPurchase:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == m_txtExpireDate) {
        [self dismissKeyboard];
        [self showAnimationPickerView:m_viewPicker];
    } else {
        [self closeAnimationPickerView:m_viewPicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == m_txtExpireDate) {
        [self dismissKeyboard];
        [self showAnimationPickerView:m_viewPicker];
    } else {
        [self closeAnimationPickerView:m_viewPicker];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

//------------- Picker -------------------

- (void)showAnimationPickerView:(UIView *)mView {
    
    [UIView animateWithDuration:.3 animations:^{
        mView.frame = CGRectMake(mView.frame.origin.x, (self.view.frame.size.height - mView.frame.size.height*1.2), mView.frame.size.width, mView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationPickerView:(UIView *)mView {
    
    [UIView animateWithDuration:.3 animations:^{
        mView.frame = CGRectMake(mView.frame.origin.x, (self.view.frame.size.height + mView.frame.size.height), mView.frame.size.width, mView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)initSetPicker {
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    year = [currentyearString intValue];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date] integerValue]];
    month = [currentMonthString intValue] - 1;
    
    yearArray = [[NSMutableArray alloc] init];
    
    for (int i = year; i <= 2100; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // PickerView -  Months data
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    // PickerView - Default Selection as per current Date
    [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:1 animated:YES];
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:0 animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    } else {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH / 2, 80 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16.0 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y]];
    }
    
    if (component == 0) {
        pickerLabel.text =  [monthArray objectAtIndex:row]; // Month
    } else {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    
    return pickerLabel;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) { // month
        return [monthArray count];
    } else { // year
        return [yearArray count];
    }
}

- (IBAction)actionCancel:(id)sender {
    
    [self closeAnimationPickerView:m_viewPicker];
    
}

- (IBAction)actionDone:(id)sender {
    
    m_txtExpireDate.text = [NSString stringWithFormat:@"%@/%@", [self monthStringFormat:[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:0]]], [yearArray objectAtIndex:[self.customPicker selectedRowInComponent:1]]];
    
    [self closeAnimationPickerView:m_viewPicker];
    
    if ([m_txtCVV.text isEqualToString:@""]) {
        [m_txtCVV resignFirstResponder];
        [m_txtCVV becomeFirstResponder];
    }
}

- (NSString *)monthStringFormat:(NSString *)strMonth {
    
    if (strMonth.length == 1) {
        strMonth = [NSString stringWithFormat:@"0%@", strMonth];
    }
    return strMonth;
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
    [self dismissKeyboard];
    [self closeAnimationView:m_viewMethod];
}

- (void)onSelectPaymentMethod {
    
    if (m_viewMethod.isHidden) {
        [self showAnimationView:m_viewMethod];
    } else {
        [self closeAnimationView:m_viewMethod];
    }
}

- (IBAction)onVisaCardPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_CREDIT_VISA;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_visa_card", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

- (IBAction)onMasterCardPayment:(id)sender {
    
    strPaymentMethod = PAYMENT_CREDIT_MASTER;
    [m_btnMethod setTitle:NSLocalizedString(@"payment_master_card", "") forState:UIControlStateNormal];
    [self closeAnimationView:m_viewMethod];
}

- (IBAction)onConfirmPayment:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    [self onCheckout];
}

- (IBAction)onPurchase:(id)sender {
    
    NSString *strName = m_txtUserName.text;
    NSString *strCardNumber = m_txtCardNumber.text;
    NSString *strExpireDate = m_txtExpireDate.text;
    NSString *strCVV = m_txtCVV.text;
    
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
//    
//    NSString *visaCardRegEx = @"^4[0-9]{3}?"; //@"^4[0-9]{12}(?:[0-9]{3})?$";
//    NSPredicate *visaCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", visaCardRegEx];
//    
//    NSString *masterCardRegEx = @"^5[1-5][0-9]{2}$"; //@"^(5[1-5][0-9]{4}|677189)[0-9]{5,}$";
//    NSPredicate *masterCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", masterCardRegEx];
    
    if ([strPaymentMethod isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_select_payment_method", "")];
        return;
    } else if ([strName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_name", "")];
        return;
    } else if ([strCardNumber isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_card_number", "")];
        return;
    } else if (![[GlobalData sharedGlobalData] isValidCheckDigitForCardNumberString:strCardNumber]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_card_number_invalid", "")];
        return;
    } else if ([strExpireDate isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_expire_date", "")];
        return;
    } else if ([strCVV isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_cvv", "")];
        return;
    }
    
//    else if(![visaCardTest evaluateWithObject:strCardNumber] && [strPaymentMethod isEqualToString:PAYMENT_CREDIT_VISA]) {
//        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_visa_card_number_invalid", "")];
//        return;
//    } else if(![masterCardTest evaluateWithObject:strCardNumber] && [strPaymentMethod isEqualToString:PAYMENT_CREDIT_MASTER]) {
//        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_master_card_number_invalid", "")];
//        return;
//    }
    
    // Get the expiry date and month
    NSMutableString* expDateAndMonth = [strExpireDate mutableCopy];
    [expDateAndMonth replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, expDateAndMonth.length)];
    NSString* expYear = @"";
    NSString* expMonth = @"";
    if (expDateAndMonth.length == 6) {
        expYear = [expDateAndMonth substringWithRange:NSMakeRange(2, 4)];
        expMonth = [expDateAndMonth substringWithRange:NSMakeRange(0, 2)];
    }
    
    double amount = (totalCost + shippingCost)/CURRENCY_RATE;
    
    if ([[GlobalData sharedGlobalData].g_strCouponCode isEqualToString:@""]) {
        amount = (totalCost + shippingCost)/CURRENCY_RATE;
    } else {
        float discountCost = totalCost * ([GlobalData sharedGlobalData].g_discountPercent / 100);
        amount = (totalCost + shippingCost - discountCost)/CURRENCY_RATE;
    }
    
    
    
    NSError *error = nil;
    OPPCardPaymentParams *params = nil;
    
    if ([strPaymentMethod isEqualToString:PAYMENT_CREDIT_VISA]) {
        params = [OPPCardPaymentParams cardPaymentParamsWithCheckoutID:strCheckoutID brand:OPPPaymentParamsBrandVISA holder:strName number:strCardNumber expiryMonth:expMonth expiryYear:expYear CVV:strCVV error:&error];
    } else {
        params = [OPPCardPaymentParams cardPaymentParamsWithCheckoutID:strCheckoutID brand:OPPPaymentParamsBrandMasterCard holder:strName number:strCardNumber expiryMonth:expMonth expiryYear:expYear CVV:strCVV error:&error];
    }
    
    if (error) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_invalid_card_data", "")];
        return;
    }
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] creditcardCheckout:KEY_CREDIT_CARD_CHECKOUT amount:[NSString stringWithFormat:@"%.02f", amount] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSDictionary *result = responseObject[KEY_RESULT];
            NSString *strCode = result[KEY_CODE];
            
            if ([strCode isEqualToString:@"000.200.100"]) {
                
                strCheckoutID = responseObject[KEY_ID];
                
                OPPTransaction *transaction = [OPPTransaction transactionWithPaymentParams:params];
                
                [self.provider submitTransaction:transaction completionHandler:^(OPPTransaction * _Nonnull transaction, NSError * _Nullable error) {
                    if (transaction.type == OPPTransactionTypeAsynchronous || transaction.type == OPPTransactionTypeSynchronous) {
                        
                        togglePaymentIsOn = true;
                        [self.view makeToast:NSLocalizedString(@"alert_payment_gateway_success", "") duration:1.0 position:CSToastPositionBottom];
                        
                        [self onCheckoutCreditCard];
                        
                    } else {
                        // Handle the error.
                        
                        SVPROGRESSHUD_DISMISS;
                        
                        togglePaymentIsOn = false;
                        m_viewPurchase.hidden = YES;
                        
                        [[GlobalData sharedGlobalData] onErrorAlert:[NSString stringWithFormat:@"%@", [error description]]];
                        
                        NSLog(@"===== Card Getway error :  %@", [error description]);
                    }
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

- (void)onCheckoutCreditCard {
    
    [[APIManager sharedManager] checkoutGatePlay:TAG_CREDIT_CARD email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                record.type = PAYMENT_CREDIT;
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
                            
                            [[APIManager sharedManager] checkoutGatePlay:TAG_CREDIT_CARD email:[GlobalData sharedGlobalData].g_userInfo.email total:strTotal address:[GlobalData sharedGlobalData].g_strShippingAddress couponCode:[GlobalData sharedGlobalData].g_strCouponCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
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
                                        record.type = PAYMENT_CREDIT;
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
    
    m_viewPurchase.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self performSegueWithIdentifier:UNWIND_CREDIT_CART_CART sender:nil];
}

@end
