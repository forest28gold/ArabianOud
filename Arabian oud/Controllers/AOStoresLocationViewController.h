//
//  AOStoresLocationViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/4/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AOStoresLocationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *m_viewCountry;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCountry;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCountry;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgArrowCountry;

@property (strong, nonatomic) IBOutlet UIView *m_viewCity;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCity;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCity;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgArrowCity;

@property (strong, nonatomic) IBOutlet UIView *m_viewBranch;
@property (strong, nonatomic) IBOutlet UIButton *m_btnBranch;
@property (strong, nonatomic) IBOutlet UILabel *m_lblBranch;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgArrowBranch;

@property (strong, nonatomic) IBOutlet UITableView *m_tableViewCountry;
@property (strong, nonatomic) IBOutlet UITableView *m_tableViewCity;
@property (strong, nonatomic) IBOutlet UITableView *m_tableViewBranch;

@property (strong, nonatomic) IBOutlet UIView *m_viewStores;
@property (nonatomic, strong) IBOutlet MKMapView *m_mapView;
@property (strong, nonatomic) IBOutlet UIView *m_viewDirection;

@end
