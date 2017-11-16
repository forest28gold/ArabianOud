//
//  AOStoredAddressViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOShippingAddressViewController.h"
#import "AOAddAddressViewController.h"
#import "AOCheckOutViewController.h"

@interface AOShippingAddressViewController ()

@end

@implementation AOShippingAddressViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([GlobalData sharedGlobalData].g_toggleProfileIsOn) {
        m_tableView.allowsSelection = NO;
    } else {
        m_tableView.allowsSelection = YES;
    }
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    SVPROGRESSHUD_SHOW;
    [self onLoadStoredAddresses];
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

- (void)onLoadStoredAddresses {
    
    [GlobalData sharedGlobalData].g_arrayStoredAddresses = [[NSMutableArray alloc] init];
    
    [[APIManager sharedManager] getAllAddresses:TAG_GET_ALL_ADDRESSES email:[GlobalData sharedGlobalData].g_userInfo.email success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            NSArray* addresses = responseObject[KEY_ADDRESSES];
            if (addresses && addresses.count > 0) {
                
                for (int i = 0; i < addresses.count; i++) {
                    
                    NSArray* arrayAddress = addresses[i];
                    
                    AddressData *record = [[AddressData alloc] init];
                    record.city = arrayAddress[0];
                    record.street = arrayAddress[1];
                    record.telephone = arrayAddress[2];
                    record.addressID = arrayAddress[3];
                    
                    [[GlobalData sharedGlobalData].g_arrayStoredAddresses addObject:record];
                }
                
                [m_tableView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SVPROGRESSHUD_DISMISS;
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([GlobalData sharedGlobalData].g_toggleProfileIsOn) {
        return 0;
    } else {
        return 55 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    headerView.frame = CGRectMake(0, 0, m_tableView.frame.size.width, 55 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y);
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel* lblGuide = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, m_tableView.frame.size.width-40, 55 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y)];
    lblGuide.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    lblGuide.textColor = [UIColor darkGrayColor];
    lblGuide.numberOfLines = 2;
    lblGuide.text = NSLocalizedString(@"select_address", "");
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        lblGuide.textAlignment = NSTextAlignmentRight;
    }
    
    [headerView addSubview:lblGuide];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayStoredAddresses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    
    UILabel *m_lblCity = (UILabel*)[_cell viewWithTag:1];
    UILabel *m_lblStreetName = (UILabel*)[_cell viewWithTag:2];
    UILabel *m_lblPhone = (UILabel*)[_cell viewWithTag:3];
    
    AddressData *record = [GlobalData sharedGlobalData].g_arrayStoredAddresses[indexPath.row];
    
    m_lblCity.text = record.city;
    m_lblStreetName.text = record.street;
    m_lblPhone.text = record.telephone;
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_addressData = [[AddressData alloc] init];
    [GlobalData sharedGlobalData].g_addressData = [GlobalData sharedGlobalData].g_arrayStoredAddresses[indexPath.row];
    
    AOCheckOutViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_CHECK_OUT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddAddress:(id)sender {
    
    AOAddAddressViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_ADD_ADDRESS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)unwindStoreAddress:(UIStoryboardSegue *)unwindSegue {
    
    [self onLoadStoredAddresses];
}

@end
