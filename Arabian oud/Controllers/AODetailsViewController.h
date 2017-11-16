//
//  AODetailsViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AODetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *m_btnWishlist;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCart;

@property (strong, nonatomic) IBOutlet UILabel *m_lblProductName;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
