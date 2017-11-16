//
//  AOMenuViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOMenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnAvatar;
@property (strong, nonatomic) IBOutlet UILabel *m_lblUserName;

@property (nonatomic, strong) IBOutlet UITableView *m_tableView;

@end
