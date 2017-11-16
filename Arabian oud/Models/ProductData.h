//
//  ProductData.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/6/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductData : NSObject

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *discount;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *percentage;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *fragrance;
@property (nonatomic, assign) int productCount;

@end
