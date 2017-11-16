//
//  AOStoresLocationViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/4/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOStoresLocationViewController.h"

@interface AOStoresLocationViewController ()
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D destination;
    BOOL toggleCountryIsOn;
    BOOL toggleCityIsOn;
    BOOL toggleBranchIsOn;
    
    NSMutableArray *arrayCountry;
    NSMutableArray *arrayCity;
    NSMutableArray *arrayBranch;
    
    NSString *strSelectedCountry;
}

@end

@implementation AOStoresLocationViewController

@synthesize m_viewStores, m_mapView, m_viewDirection;
@synthesize m_viewCity, m_viewBranch, m_viewCountry;
@synthesize m_tableViewCity, m_tableViewBranch, m_tableViewCountry;
@synthesize m_btnCity, m_lblCity, m_btnBranch, m_lblBranch, m_btnCountry, m_lblCountry;
@synthesize m_imgArrowCity, m_imgArrowBranch, m_imgArrowCountry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewStores.hidden = YES;
    m_viewDirection.hidden = YES;
    [self closeAnimationDirectionView:m_viewDirection];
    
    toggleCountryIsOn = toggleCityIsOn = toggleBranchIsOn = false;
    strSelectedCountry = @"";
    
    arrayCountry = [[NSMutableArray alloc] init];
    arrayCity = [[NSMutableArray alloc] init];
    arrayBranch = [[NSMutableArray alloc] init];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseStoresView)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapCountry = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectCountry)];
    tapCountry.cancelsTouchesInView = NO;
    [m_btnCountry addGestureRecognizer:tapCountry];
    
    UITapGestureRecognizer *tapCity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectCity)];
    tapCity.cancelsTouchesInView = NO;
    [m_btnCity addGestureRecognizer:tapCity];
    
    UITapGestureRecognizer *tapBranch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectBranch)];
    tapBranch.cancelsTouchesInView = NO;
    [m_btnBranch addGestureRecognizer:tapBranch];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTapped:)];
    [self.m_mapView addGestureRecognizer:tapRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewStores.layer.cornerRadius = 2.0f;
    m_viewStores.layer.borderColor = [UIColor colorWithHexString:@"aabfbfbf"].CGColor;
    m_viewStores.layer.shadowOpacity = 0.6;
    m_viewStores.layer.shadowRadius = 3.0f;
    m_viewStores.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    
    m_viewCountry.layer.borderWidth = 1.0f;
    m_viewCountry.layer.borderColor = [UIColor grayColor].CGColor;
    m_viewCity.layer.borderWidth = 1.0f;
    m_viewCity.layer.borderColor = [UIColor grayColor].CGColor;
    m_viewBranch.layer.borderWidth = 1.0f;
    m_viewBranch.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    m_mapView.showsUserLocation = YES;
    [m_mapView setMapType:MKMapTypeStandard];
    [m_mapView setZoomEnabled:YES];
    [m_mapView setScrollEnabled:YES];
    m_mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    if ([GlobalData sharedGlobalData].g_arrayStores.count > 0) {
        [self onParseStoreLocationData];
    } else {
        [self onLoadStoreLocationsData];
    }
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

- (void)setupLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark Location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        MKCoordinateRegion region;
        region.span = span;
        region.center = currentLocation.coordinate;
        [m_mapView setRegion:region animated:YES];
    }
    [_locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [errorAlert show];
}

- (void)onLoadStoreLocationsData {
    
    SVPROGRESSHUD_SHOW;
    
    [GlobalData sharedGlobalData].g_arrayStores = [[NSMutableArray alloc] init];
    
    [[APIManager sharedManager] getStoreLocations:TAG_LOCATIONS success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
         
            NSArray *locations = responseObject[KEY_LOCATIONS];

            if (locations && locations.count > 0) {
                
                for (int i = 0; i < locations.count; i++) {
                    
                    NSDictionary* locationInfo = locations[i];
                    
                    if (locationInfo) {
                        
                        StoreData *record = [[StoreData alloc] init];
                        record.name = [locationInfo objectForKey:KEY_NAME];
                        record.displayAddress = [locationInfo objectForKey:KEY_DISPLAY_ADDRESS];
                        record.zipCode = [locationInfo objectForKey:KEY_ZIP_CODE];
                        record.city = [locationInfo objectForKey:KEY_CITY];
                        record.state = [locationInfo objectForKey:KEY_STATE];
                        record.countryId = [locationInfo objectForKey:KEY_COUNTRY_ID];
                        record.phone = [locationInfo objectForKey:KEY_PHONE];
                        record.latitude = [locationInfo objectForKey:KEY_LAT];
                        record.longitude = [locationInfo objectForKey:KEY_LONG];
                        
                        [[GlobalData sharedGlobalData].g_arrayStores addObject:record];
                    }
                }
                
                [self onParseStoreLocationData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SVPROGRESSHUD_DISMISS;
    }];
}

- (void)onParseStoreLocationData {
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayStores.count; i++) {
        
        StoreData *record = [GlobalData sharedGlobalData].g_arrayStores[i];
        
        if (![arrayCountry containsObject:record.countryId]) {
            [arrayCountry addObject:record.countryId];
        }
        
        if (![arrayCity containsObject:record.city]) {
            [arrayCity addObject:record.city];
        }
        
        [arrayBranch addObject:record];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [record.latitude floatValue];
        coordinate.longitude = [record.longitude floatValue];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:record.name];
        [annotation setSubtitle:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"phone", ""), record.phone]];
        [self.m_mapView addAnnotation:annotation];
    }
    
    [m_tableViewCountry reloadData];
    [m_tableViewCity reloadData];
    [m_tableViewBranch reloadData];
}

- (void)showAnimationView:(UIView *)mView arrow:(UIImageView*)arrowView {
    
    mView.hidden = NO;
    mView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 1;
        arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationView:(UIView *)mView arrow:(UIImageView*)arrowView {
    
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 0;
        mView.hidden = YES;
        arrowView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationArrowView:(UIImageView*)arrowView {
    
    [UIView animateWithDuration:.3 animations:^{
        arrowView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)onSelectCountry {
    
    toggleCountryIsOn = true;
    
    m_tableViewCountry.hidden = NO;
    m_tableViewCity.hidden = YES;
    m_tableViewBranch.hidden = YES;
    
    if (m_viewStores.isHidden) {
        [self showAnimationView:m_viewStores arrow:m_imgArrowCountry];
    } else {
        [self closeAnimationView:m_viewStores arrow:m_imgArrowCountry];
    }
    
    [self closeAnimationArrowView:m_imgArrowCity];
    [self closeAnimationArrowView:m_imgArrowBranch];
}

- (void)onSelectCity {
    
    m_tableViewCountry.hidden = YES;
    m_tableViewCity.hidden = NO;
    m_tableViewBranch.hidden = YES;
    
    if (m_viewStores.isHidden) {
        [self showAnimationView:m_viewStores arrow:m_imgArrowCity];
    } else {
        [self closeAnimationView:m_viewStores arrow:m_imgArrowCity];
    }
    
    [self closeAnimationArrowView:m_imgArrowCountry];
    [self closeAnimationArrowView:m_imgArrowBranch];
}

- (void)onSelectBranch {
    
    m_tableViewCountry.hidden = YES;
    m_tableViewCity.hidden = YES;
    m_tableViewBranch.hidden = NO;
    
    if (m_viewStores.isHidden) {
        [self showAnimationView:m_viewStores arrow:m_imgArrowBranch];
    } else {
        [self closeAnimationView:m_viewStores arrow:m_imgArrowBranch];
    }
    
    [self closeAnimationArrowView:m_imgArrowCountry];
    [self closeAnimationArrowView:m_imgArrowCity];
}

- (void)onCloseStoresView {
    
    [UIView animateWithDuration:.3 animations:^{
        m_viewStores.alpha = 0;
        m_viewStores.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    
    [self closeAnimationArrowView:m_imgArrowCountry];
    [self closeAnimationArrowView:m_imgArrowCity];
    [self closeAnimationArrowView:m_imgArrowBranch];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Annotations

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    
    if(annotation != m_mapView.userLocation)
    {
        static NSString *AnnotationViewID = @"annotationViewID";
        annotationView = (MKAnnotationView *)[m_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"pin.png"];
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [m_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    destination = view.annotation.coordinate;
    
//    NSString *strName = view.annotation.title;
//    NSString *strPhone = view.annotation.subtitle;
    
    [self showAnimationDirectionView:m_viewDirection];
}

// Handle touch event
- (void)mapViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self closeAnimationDirectionView:m_viewDirection];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1) { // Country
        return arrayCountry.count;
    } else if (tableView.tag == 2) { // City
        return arrayCity.count;
    } else { // Branch
        return arrayBranch.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 34 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) { // Country
        
        UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
        
        UILabel *m_lblLocation = (UILabel*)[_cell viewWithTag:1];
        
        NSString *strCountry = [self onGetFormattedCountry:arrayCountry[indexPath.row]];
        
        m_lblLocation.text = strCountry;
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:strCountry
                                                        options:0
                                                          range:NSMakeRange(0, [strCountry length])];
        if (match) {
            m_lblLocation.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblLocation.textAlignment = NSTextAlignmentLeft;
        }
        
        UIView* m_view = (UIView*)[_cell viewWithTag:10];
        if (m_view.frame.size.width < self.m_tableViewCountry.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
        }
        
        return _cell;
        
    } else if (tableView.tag == 2) { // City
        
        UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
        
        UILabel *m_lblLocation = (UILabel*)[_cell viewWithTag:1];

        NSString *strCity = arrayCity[indexPath.row];
        
        m_lblLocation.text = strCity;
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:strCity
                                                        options:0
                                                          range:NSMakeRange(0, [strCity length])];
        if (match) {
            m_lblLocation.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblLocation.textAlignment = NSTextAlignmentLeft;
        }
        
        UIView* m_view = (UIView*)[_cell viewWithTag:10];
        if (m_view.frame.size.width < self.m_tableViewCity.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
        }
        
        return _cell;
        
        
    } else { // Branch
        
        UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BranchCell" forIndexPath:indexPath];
        
        UILabel *m_lblLocation = (UILabel*)[_cell viewWithTag:1];
        
        StoreData *record = arrayBranch[indexPath.row];
        m_lblLocation.text = record.name;
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:record.name
                                                        options:0
                                                          range:NSMakeRange(0, [record.name length])];
        if (match) {
            m_lblLocation.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblLocation.textAlignment = NSTextAlignmentLeft;
        }
        
        UIView* m_view = (UIView*)[_cell viewWithTag:10];
        if (m_view.frame.size.width < self.m_tableViewBranch.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
        }
        
        return _cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView.tag == 1) { // Country
        
        strSelectedCountry = arrayCountry[indexPath.row];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:strSelectedCountry
                                                        options:0
                                                          range:NSMakeRange(0, [strSelectedCountry length])];
        if (match) {
            m_lblCountry.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblCountry.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblCountry.text = [self onGetFormattedCountry:strSelectedCountry];
        
        NSTextCheckingResult *match_city = [regex firstMatchInString:NSLocalizedString(@"city", "")
                                                        options:0
                                                          range:NSMakeRange(0, [NSLocalizedString(@"city", "") length])];
        if (match_city) {
            m_lblCity.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblCity.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblCity.text = NSLocalizedString(@"city", "");
        
        NSTextCheckingResult *match_branch = [regex firstMatchInString:NSLocalizedString(@"branch", "")
                                                        options:0
                                                          range:NSMakeRange(0, [NSLocalizedString(@"branch", "") length])];
        if (match_branch) {
            m_lblBranch.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblBranch.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblBranch.text = NSLocalizedString(@"branch", "");
        
        [self onCloseStoresView];
        
        [self closeAnimationDirectionView:m_viewDirection];
        
        [self onParseCountryStoreLocationData];
        
    } else if (tableView.tag == 2) { // City
        
        NSString *strCity = arrayCity[indexPath.row];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:strCity
                                                        options:0
                                                          range:NSMakeRange(0, [strCity length])];
        if (match) {
            m_lblCity.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblCity.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblCity.text = strCity;
        
        NSTextCheckingResult *match_branch = [regex firstMatchInString:NSLocalizedString(@"branch", "")
                                                               options:0
                                                                 range:NSMakeRange(0, [NSLocalizedString(@"branch", "") length])];
        if (match_branch) {
            m_lblBranch.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblBranch.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblBranch.text = NSLocalizedString(@"branch", "");
        
        [self onCloseStoresView];
        
        [self closeAnimationDirectionView:m_viewDirection];
        
        [self onParseCityStoreLocationData:strCity];
        
    } else { // Branch
        
     
        StoreData *record = arrayBranch[indexPath.row];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:record.name
                                                        options:0
                                                          range:NSMakeRange(0, [record.name length])];
        if (match) {
            m_lblBranch.textAlignment = NSTextAlignmentRight;
        } else {
            m_lblBranch.textAlignment = NSTextAlignmentLeft;
        }
        
        m_lblBranch.text = record.name;
        
        [self onCloseStoresView];
        
        [self closeAnimationDirectionView:m_viewDirection];
        
        destination.latitude = [record.latitude floatValue];
        destination.longitude = [record.longitude floatValue];
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        MKCoordinateRegion region;
        region.span = span;
        region.center = destination;
        [m_mapView setRegion:region animated:YES];
        
    }
}

- (NSString *)onGetFormattedCountry:(NSString *)strCountry {
    
    if ([strCountry isEqualToString:@"SA"]) {
        return NSLocalizedString(@"country_sa", "");
    } else if ([strCountry isEqualToString:@"BH"]) {
        return NSLocalizedString(@"country_bh", "");
    } else if ([strCountry isEqualToString:@"OM"]) {
        return NSLocalizedString(@"country_om", "");
    } else if ([strCountry isEqualToString:@"QA"]) {
        return NSLocalizedString(@"country_qa", "");
    } else if ([strCountry isEqualToString:@"AE"]) {
        return NSLocalizedString(@"country_ae", "");
    } else if ([strCountry isEqualToString:@"FR"]) {
        return NSLocalizedString(@"country_fr", "");
    } else if ([strCountry isEqualToString:@"EG"]) {
        return NSLocalizedString(@"country_eg", "");
    } else if ([strCountry isEqualToString:@"JO"]) {
        return NSLocalizedString(@"country_jo", "");
    } else if ([strCountry isEqualToString:@"IQ"]) {
        return NSLocalizedString(@"country_iq", "");
    } else if ([strCountry isEqualToString:@"MY"]) {
        return NSLocalizedString(@"country_my", "");
    } else if ([strCountry isEqualToString:@"GB"]) {
        return NSLocalizedString(@"country_gb", "");
    } else if ([strCountry isEqualToString:@"KW"]) {
        return NSLocalizedString(@"country_kw", "");
    } else if ([strCountry isEqualToString:@"PL"]) {
        return NSLocalizedString(@"country_pl", "");
    } else {
        return strCountry;
    }
}

- (void)onParseCountryStoreLocationData {
    
    arrayCity = [[NSMutableArray alloc] init];
    arrayBranch = [[NSMutableArray alloc] init];
    
    [self.m_mapView removeAnnotations:self.m_mapView.annotations];
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayStores.count; i++) {
        
        StoreData *record = [GlobalData sharedGlobalData].g_arrayStores[i];
        
        if ([strSelectedCountry isEqualToString:record.countryId]) {

            if (![arrayCity containsObject:record.city]) {
                [arrayCity addObject:record.city];
            }
            
            [arrayBranch addObject:record];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [record.latitude floatValue];
            coordinate.longitude = [record.longitude floatValue];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coordinate];
            [annotation setTitle:record.name];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"phone", ""), record.phone]];
            [self.m_mapView addAnnotation:annotation];
        }
    }
    
    [self.m_mapView showAnnotations:self.m_mapView.annotations animated:YES];
    
    [m_tableViewCity reloadData];
    [m_tableViewBranch reloadData];
}

- (void)onParseCityStoreLocationData:(NSString *)strCity {
    
    arrayBranch = [[NSMutableArray alloc] init];
    
    [self.m_mapView removeAnnotations:self.m_mapView.annotations];
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayStores.count; i++) {
        
        StoreData *record = [GlobalData sharedGlobalData].g_arrayStores[i];
        
        if ([strSelectedCountry isEqualToString:@""]) {
            
            if ([strCity isEqualToString:record.city]) {
                
                [arrayBranch addObject:record];
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [record.latitude floatValue];
                coordinate.longitude = [record.longitude floatValue];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:coordinate];
                [annotation setTitle:record.name];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"phone", ""), record.phone]];
                [self.m_mapView addAnnotation:annotation];
            }
            
        } else {
            
            if ([strSelectedCountry isEqualToString:record.countryId] && [strCity isEqualToString:record.city]) {
                
                [arrayBranch addObject:record];
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [record.latitude floatValue];
                coordinate.longitude = [record.longitude floatValue];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:coordinate];
                [annotation setTitle:record.name];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"phone", ""), record.phone]];
                [self.m_mapView addAnnotation:annotation];
            }
        }
        
    }
    
    [self.m_mapView showAnnotations:self.m_mapView.annotations animated:YES];
    
    [m_tableViewBranch reloadData];
}

//===============  Map Direction and Location in GoogleMap App ==============

- (IBAction)onSelectMapDirection:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]]) {
        
//        CLLocationCoordinate2D start = { 34.052222, -118.243611 };
//        CLLocationCoordinate2D dest = { 37.322778, -122.031944 };
//        
//        NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
//                                         start.latitude, start.longitude, dest.latitude, dest.longitude];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
        
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?daddr=%1.6f,%1.6f", destination.latitude, destination.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        NSString *string = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f", destination.latitude, destination.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

- (IBAction)onSelectMapLocation:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]]) {
        
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?center=%1.6f,%1.6f&q=%1.6f,%1.6f&zoom=15", destination.latitude, destination.longitude, destination.latitude, destination.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        NSString *string = [NSString stringWithFormat:@"http://maps.google.com/?center=%1.6f,%1.6f&q=%1.6f,%1.6f&zoom=15", destination.latitude, destination.longitude, destination.latitude, destination.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

- (void)showAnimationDirectionView:(UIView *)mView {
    
    mView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        mView.frame = CGRectMake(self.view.frame.size.width - mView.frame.size.width, mView.frame.origin.y, mView.frame.size.width, mView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationDirectionView:(UIView *)mView {
    
    [UIView animateWithDuration:.2 animations:^{
        mView.frame = CGRectMake(self.view.frame.size.width, mView.frame.origin.y, mView.frame.size.width, mView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            mView.hidden = YES;
        }
    }];
}

@end
