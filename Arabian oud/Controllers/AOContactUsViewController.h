//
//  AOContactUsViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/27/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOContactUsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *m_txtName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *m_txtSubject;
@property (strong, nonatomic) IBOutlet UITextView *m_txtComment;

@property (strong, nonatomic) IBOutlet UIView *m_viewName;
@property (strong, nonatomic) IBOutlet UIView *m_viewPhone;
@property (strong, nonatomic) IBOutlet UIView *m_viewSubject;
@property (strong, nonatomic) IBOutlet UIView *m_viewComment;

@end
