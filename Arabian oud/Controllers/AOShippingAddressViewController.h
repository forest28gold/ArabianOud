//
//  AOStoredAddressViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOShippingAddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

- (IBAction)unwindStoreAddress:(UIStoryboardSegue *)unwindSegue;

@end
