//
//  AOMainViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "MVRightSlideView.h"

@interface AOMainViewController : UIViewController

@property (nonatomic ,strong) MenuView *leftMenuView;
@property (nonatomic, strong) MVRightSlideView *rightMenuView;
@property (strong, nonatomic) IBOutlet UIButton *m_btnWishlist;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCart;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIButton *m_btnSearch;
@property (strong, nonatomic) IBOutlet UIView *m_viewNewArrival;

- (IBAction)unwindPaymentConfirm:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindLogout:(UIStoryboardSegue *)unwindSegue;

@end
