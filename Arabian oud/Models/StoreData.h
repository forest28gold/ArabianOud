//
//  StoreData.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/10/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayAddress;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
