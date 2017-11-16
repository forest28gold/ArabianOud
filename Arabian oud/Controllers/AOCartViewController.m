//
//  AOCartViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOCartViewController.h"
#import "AOLoginViewController.h"
#import "AOShippingAddressViewController.h"

@interface AOCartViewController () <UIAlertViewDelegate>
{
    NSInteger deleteIndex;
}

@end

@implementation AOCartViewController

@synthesize m_tableView, m_lblCost, m_viewEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onShowCartData];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self onShowCartData];
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

- (void)onShowCartData {
    
    if ([GlobalData sharedGlobalData].g_arrayCart.count > 0) {
        m_viewEmpty.hidden = YES;
    } else {
        m_viewEmpty.hidden = NO;
    }
    [m_tableView reloadData];
}

- (void)onCalculateGrandTotal {
    
    float totalCost = 0.0f;
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayCart.count; i++) {
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[i];
        totalCost += [record.discount floatValue] * record.productCount;
    }
    
    m_lblCost.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayCart.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    
    UIImageView *_imgProduct = (UIImageView*)[_cell viewWithTag:1];
    UILabel *_lblName = (UILabel*)[_cell viewWithTag:2];
    UILabel *_lblCost = (UILabel*)[_cell viewWithTag:3];
    UILabel *_lblCount = (UILabel*)[_cell viewWithTag:4];
    UIButton* _btnDecrease = (UIButton*)[_cell viewWithTag:5];
    UIButton* _btnIncrease = (UIButton*)[_cell viewWithTag:6];
    UIButton* _btnDelete = (UIButton*)[_cell viewWithTag:7];
    UIView *m_viewCount = (UIView*)[_cell viewWithTag:8];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:record.image];
    [_imgProduct setShowActivityIndicatorView:YES];
    [_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _lblName.text = record.name;
    _lblCost.text = [self getFormattedPrice:record.discount];
    _lblCount.text = [NSString stringWithFormat:@"%i", record.productCount];
    
    [_btnDecrease addTarget:self action:@selector(onDecreaseCount:) forControlEvents:UIControlEventTouchUpInside];
    [_btnIncrease addTarget:self action:@selector(onIncreaseCount:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDelete addTarget:self action:@selector(onDeleteCart:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
        m_viewCount.layer.cornerRadius = 3.0f;
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)getFormattedPrice:(NSString *)price {
    
    if ([price containsString:@"."]) {
        NSArray *items = [price componentsSeparatedByString:@"."];
        price = [NSString stringWithFormat:@"%@.%@ %@", [items objectAtIndex:0], [[items objectAtIndex:1] substringToIndex:1], CURRENCY_CODE];
    } else {
        price = [NSString stringWithFormat:@"%@.0 %@", price, CURRENCY_CODE];
    }
    
    return price;
}

- (void)onDecreaseCount:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[indexPath.row];
    
    if (record.productCount > 1) {
        
        record.productCount--;
     
        [[GlobalData sharedGlobalData].g_arrayCart replaceObjectAtIndex:indexPath.row withObject:record];
        [[GlobalData sharedGlobalData].g_dataModel updateCartDataDB:record];
        
        [self onCalculateGrandTotal];
        
        [m_tableView reloadData];
    }
}

- (void)onIncreaseCount:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[indexPath.row];
    
    if (record.productCount < 10) {
        
        record.productCount++;
        
        [[GlobalData sharedGlobalData].g_arrayCart replaceObjectAtIndex:indexPath.row withObject:record];
        [[GlobalData sharedGlobalData].g_dataModel updateCartDataDB:record];
        
        [self onCalculateGrandTotal];
        
        [m_tableView reloadData];
    }
}

- (void)onDeleteCart:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    deleteIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirm", "")
                                                    message:NSLocalizedString(@"alert_delete_item", "")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"yes", "")
                                          otherButtonTitles:NSLocalizedString(@"no", ""), nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        // do something here...
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[deleteIndex];
        
        [[GlobalData sharedGlobalData].g_dataModel deleteCartDataDB:record];
        [[GlobalData sharedGlobalData].g_arrayCart removeObjectAtIndex:deleteIndex];
        
        [self onCalculateGrandTotal];
        
        [self onShowCartData];
        
    } else if (buttonIndex == 1) { // Cancel
        //Code for cancel button
        
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCheckout:(id)sender {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.signup isEqualToString:USER_LOGIN]) {
        
        [GlobalData sharedGlobalData].g_toggleProfileIsOn = false;
        
        AOShippingAddressViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_SHIPPING_ADDRESS];
        [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
        
    } else {
        
        AOLoginViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_LOGIN];
        [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
    }
}

- (IBAction)onContinueShopping:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)unwindCheckoutToCart:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)unwindBankTransferToCart:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)unwindPaypalToCart:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)unwindCreditCardToCart:(UIStoryboardSegue *)unwindSegue {
    
}

@end
