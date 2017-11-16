//
//  AOAddAddressViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOAddAddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewMain;
@property (strong, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtSecondName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtTelephone;
@property (strong, nonatomic) IBOutlet UITextField *m_txtStreetName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtStreetNumber;
@property (strong, nonatomic) IBOutlet UITextField *m_txtAddressExtra;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCity;

@property (strong, nonatomic) IBOutlet UIView *m_viewCity;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
