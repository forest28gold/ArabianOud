//
//  AOLoginViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPassword;

- (IBAction)unwindSignup:(UIStoryboardSegue *)unwindSegue;

@end
