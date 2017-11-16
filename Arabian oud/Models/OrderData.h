//
//  OrderData.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderData : NSObject

@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *ship;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *couponCode;
@property (strong, nonatomic) NSString *discountPercent;

@end
