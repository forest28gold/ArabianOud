//
//  AOCartViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOCartViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewEmpty;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCost;

- (IBAction)unwindCheckoutToCart:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindBankTransferToCart:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindPaypalToCart:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindCreditCardToCart:(UIStoryboardSegue *)unwindSegue;

@end
