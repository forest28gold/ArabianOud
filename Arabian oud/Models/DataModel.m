//
//  DataModel.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize dbHandler;

+ (BOOL)createTable:(sqlite3 *)dbHandler {
	NSString* strQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);"
                          "CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);"
                          "CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);"
                          "CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);"
                          "CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);",
                           TABLE_USER, FIELD_USER_ID, FIELD_FIRST_NAME, FIELD_LAST_NAME, FIELD_EMAIL, FIELD_PASSWORD, FIELD_ADDRESS, FIELD_TELEPHONE, FIELD_LANGUAGE, FIELD_SIGNUP,
                           TABLE_WISHLIST, FIELD_PRODUCT_ID, FIELD_NAME, FIELD_PRICE, FIELD_DISCOUNT, FIELD_DESCRIPTION, FIELD_IMAGE, FIELD_PERCENTAGE, FIELD_URL, FIELD_SKU, FIELD_SIZE, FIELD_TYPE, FIELD_ORIGIN, FIELD_FRAGRANCE, FIELD_EMAIL,
                           TABLE_CART, FIELD_PRODUCT_ID, FIELD_NAME, FIELD_PRICE, FIELD_DISCOUNT, FIELD_DESCRIPTION, FIELD_IMAGE, FIELD_PERCENTAGE, FIELD_URL, FIELD_SKU, FIELD_SIZE, FIELD_TYPE, FIELD_ORIGIN, FIELD_FRAGRANCE, FIELD_COUNT, FIELD_EMAIL,
                          TABLE_PRODUCT, FIELD_PRODUCT_ID, FIELD_NAME, FIELD_PRICE, FIELD_DISCOUNT, FIELD_DESCRIPTION, FIELD_IMAGE, FIELD_PERCENTAGE, FIELD_URL, FIELD_SKU, FIELD_SIZE, FIELD_TYPE, FIELD_ORIGIN, FIELD_FRAGRANCE, FIELD_COUNT, FIELD_ORDER_ID, FIELD_EMAIL,
                           TABLE_ORDER, FIELD_ORDER_ID, FIELD_DATE, FIELD_SHIP, FIELD_TOTAL, FIELD_TYPE, FIELD_NAME, FIELD_ADDRESS, FIELD_TELEPHONE, FIELD_EMAIL, FIELD_COUPON_CODE, FIELD_DISCOUNT_PERCENT];
    
	if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
		return NO;

	return YES;
}

-(id)initWithDBHandler:(sqlite3*)_dbHandler {
	self = [super init];
	
	if (self) {
		self.dbHandler = _dbHandler;
        
        [GlobalData sharedGlobalData].g_userInfo = [[UserData alloc] init];
        
		NSString *strQuery_user = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_USER];
        sqlite3_stmt* stmt_user;
		
		if (sqlite3_prepare_v2(dbHandler, [strQuery_user UTF8String], -1, &stmt_user, NULL) == SQLITE_OK) {
			//int userId;
            
			while(sqlite3_step(stmt_user) == SQLITE_ROW) {
               UserData * record = [[UserData alloc] init];
                record.userID = @"";
                record.firstName = @"";
                record.lastName = @"";
                record.email = @"";
                record.password = @"";
                record.address = @"";
                record.telephone = @"";
                record.language = @"";
                record.signup = @"";
                
                char *userID = (char*)sqlite3_column_text(stmt_user, 0);
				char *firstName = (char*)sqlite3_column_text(stmt_user, 1);
                char *lastName = (char*)sqlite3_column_text(stmt_user, 2);
                char *email = (char*)sqlite3_column_text(stmt_user, 3);
                char *password = (char*)sqlite3_column_text(stmt_user, 4);
                char *address = (char*)sqlite3_column_text(stmt_user, 5);
                char *telephone = (char*)sqlite3_column_text(stmt_user, 6);
                char *language = (char*)sqlite3_column_text(stmt_user, 7);
                char *signup = (char*)sqlite3_column_text(stmt_user, 8);
                
                if (userID != nil)
                    record.userID = [NSString stringWithUTF8String:userID];
                
				if (firstName != nil)
					record.firstName = [NSString stringWithUTF8String:firstName];
                
                if (lastName != nil)
                    record.lastName = [NSString stringWithUTF8String:lastName];
                
                if (email != nil)
                    record.email = [NSString stringWithUTF8String:email];
                
                if (password != nil)
                    record.password = [NSString stringWithUTF8String:password];
                
                if (address != nil)
                    record.address = [NSString stringWithUTF8String:address];
                
                if (telephone != nil)
                    record.telephone = [NSString stringWithUTF8String:telephone];
                
                if (language != nil)
                    record.language = [NSString stringWithUTF8String:language];

                if (signup != nil)
                    record.signup = [NSString stringWithUTF8String:signup];

                [GlobalData sharedGlobalData].g_userInfo = record;
                
			}
            sqlite3_finalize(stmt_user);
		}
        
        
        [GlobalData sharedGlobalData].g_arrayWishlist = [[NSMutableArray alloc] init];
        
        NSString *strQuery_wishlist = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", TABLE_WISHLIST, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
        sqlite3_stmt* stmt_wishlist;
        
        if (sqlite3_prepare_v2(dbHandler, [strQuery_wishlist UTF8String], -1, &stmt_wishlist, NULL) == SQLITE_OK) {
            //int userId;
            
            while(sqlite3_step(stmt_wishlist) == SQLITE_ROW) {
                ProductData *record = [[ProductData alloc] init];
                record.productId = @"";
                record.name = @"";
                record.price = @"";
                record.discount = @"";
                record.productDescription = @"";
                record.image = @"";
                record.percentage = @"";
                record.url = @"";
                record.sku = @"";
                record.size = @"";
                record.type = @"";
                record.origin = @"";
                record.fragrance = @"";
                
                char *productId = (char*)sqlite3_column_text(stmt_wishlist, 0);
                char *name = (char*)sqlite3_column_text(stmt_wishlist, 1);
                char *price = (char*)sqlite3_column_text(stmt_wishlist, 2);
                char *discount = (char*)sqlite3_column_text(stmt_wishlist, 3);
                char *productDescription = (char*)sqlite3_column_text(stmt_wishlist, 4);
                char *image = (char*)sqlite3_column_text(stmt_wishlist, 5);
                char *percentage = (char*)sqlite3_column_text(stmt_wishlist, 6);
                char *url = (char*)sqlite3_column_text(stmt_wishlist, 7);
                char *sku = (char*)sqlite3_column_text(stmt_wishlist, 8);
                char *size = (char*)sqlite3_column_text(stmt_wishlist, 9);
                char *type = (char*)sqlite3_column_text(stmt_wishlist, 10);
                char *origin = (char*)sqlite3_column_text(stmt_wishlist, 11);
                char *fragrance = (char*)sqlite3_column_text(stmt_wishlist, 12);
                
                if (productId != nil)
                    record.productId = [NSString stringWithUTF8String:productId];
                
                if (name != nil)
                    record.name = [NSString stringWithUTF8String:name];
                
                if (price != nil)
                    record.price = [NSString stringWithUTF8String:price];
                
                if (discount != nil)
                    record.discount = [NSString stringWithUTF8String:discount];
                
                if (productDescription != nil)
                    record.productDescription = [NSString stringWithUTF8String:productDescription];
                
                if (image != nil)
                    record.image = [NSString stringWithUTF8String:image];
                
                if (percentage != nil)
                    record.percentage = [NSString stringWithUTF8String:percentage];
                
                if (url != nil)
                    record.url = [NSString stringWithUTF8String:url];
                
                if (sku != nil)
                    record.sku = [NSString stringWithUTF8String:sku];
                
                if (size != nil)
                    record.size = [NSString stringWithUTF8String:size];
                
                if (type != nil)
                    record.type = [NSString stringWithUTF8String:type];
                
                if (origin != nil)
                    record.origin = [NSString stringWithUTF8String:origin];
                
                if (fragrance != nil)
                    record.fragrance = [NSString stringWithUTF8String:fragrance];
                
                [[GlobalData sharedGlobalData].g_arrayWishlist addObject:record];
            }
            sqlite3_finalize(stmt_wishlist);
        }
        
        
        [GlobalData sharedGlobalData].g_arrayCart = [[NSMutableArray alloc] init];
        
        NSString *strQuery_cart = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", TABLE_CART, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
        sqlite3_stmt* stmt_cart;
        
        if (sqlite3_prepare_v2(dbHandler, [strQuery_cart UTF8String], -1, &stmt_cart, NULL) == SQLITE_OK) {
            //int userId;
            
            while(sqlite3_step(stmt_cart) == SQLITE_ROW) {
                ProductData *record = [[ProductData alloc] init];
                record.productId = @"";
                record.name = @"";
                record.price = @"";
                record.discount = @"";
                record.productDescription = @"";
                record.image = @"";
                record.percentage = @"";
                record.url = @"";
                record.sku = @"";
                record.size = @"";
                record.type = @"";
                record.origin = @"";
                record.fragrance = @"";
                record.productCount = 1;
                
                
                char *productId = (char*)sqlite3_column_text(stmt_cart, 0);
                char *name = (char*)sqlite3_column_text(stmt_cart, 1);
                char *price = (char*)sqlite3_column_text(stmt_cart, 2);
                char *discount = (char*)sqlite3_column_text(stmt_cart, 3);
                char *productDescription = (char*)sqlite3_column_text(stmt_cart, 4);
                char *image = (char*)sqlite3_column_text(stmt_cart, 5);
                char *percentage = (char*)sqlite3_column_text(stmt_cart, 6);
                char *url = (char*)sqlite3_column_text(stmt_cart, 7);
                char *sku = (char*)sqlite3_column_text(stmt_cart, 8);
                char *size = (char*)sqlite3_column_text(stmt_cart, 9);
                char *type = (char*)sqlite3_column_text(stmt_cart, 10);
                char *origin = (char*)sqlite3_column_text(stmt_cart, 11);
                char *fragrance = (char*)sqlite3_column_text(stmt_cart, 12);
                char *count = (char*)sqlite3_column_text(stmt_cart, 13);
                
                if (productId != nil)
                    record.productId = [NSString stringWithUTF8String:productId];
                
                if (name != nil)
                    record.name = [NSString stringWithUTF8String:name];
                
                if (price != nil)
                    record.price = [NSString stringWithUTF8String:price];
                
                if (discount != nil)
                    record.discount = [NSString stringWithUTF8String:discount];
                
                if (productDescription != nil)
                    record.productDescription = [NSString stringWithUTF8String:productDescription];
                
                if (image != nil)
                    record.image = [NSString stringWithUTF8String:image];
                
                if (percentage != nil)
                    record.percentage = [NSString stringWithUTF8String:percentage];
                
                if (url != nil)
                    record.url = [NSString stringWithUTF8String:url];
                
                if (sku != nil)
                    record.sku = [NSString stringWithUTF8String:sku];
                
                if (size != nil)
                    record.size = [NSString stringWithUTF8String:size];
                
                if (type != nil)
                    record.type = [NSString stringWithUTF8String:type];
                
                if (origin != nil)
                    record.origin = [NSString stringWithUTF8String:origin];
                
                if (fragrance != nil)
                    record.fragrance = [NSString stringWithUTF8String:fragrance];
                
                if (count != nil)
                    record.productCount = [[NSString stringWithUTF8String:count] intValue];
                
                [[GlobalData sharedGlobalData].g_arrayCart addObject:record];
            }
            sqlite3_finalize(stmt_cart);
        }
        
        
        [GlobalData sharedGlobalData].g_arrayOrder = [[NSMutableArray alloc] init];
        
        NSString *strQuery_order = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' ORDER BY %@ DESC", TABLE_ORDER, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email, FIELD_ORDER_ID];
        sqlite3_stmt* stmt_order;
        
        if (sqlite3_prepare_v2(dbHandler, [strQuery_order UTF8String], -1, &stmt_order, NULL) == SQLITE_OK) {
            //int userId;
            
            while(sqlite3_step(stmt_order) == SQLITE_ROW) {
                OrderData *record = [[OrderData alloc] init];
                record.orderID = @"";
                record.date = @"";
                record.ship = @"";
                record.total = @"";
                record.type = @"";
                record.username = @"";
                record.address = @"";
                record.telephone = @"";
                
                char *orderID = (char*)sqlite3_column_text(stmt_order, 0);
                char *date = (char*)sqlite3_column_text(stmt_order, 1);
                char *ship = (char*)sqlite3_column_text(stmt_order, 2);
                char *total = (char*)sqlite3_column_text(stmt_order, 3);
                char *type = (char*)sqlite3_column_text(stmt_order, 4);
                char *username = (char*)sqlite3_column_text(stmt_order, 5);
                char *address = (char*)sqlite3_column_text(stmt_order, 6);
                char *telephone = (char*)sqlite3_column_text(stmt_order, 7);
                
                if (orderID != nil)
                    record.orderID = [NSString stringWithUTF8String:orderID];
                
                if (date != nil)
                    record.date = [NSString stringWithUTF8String:date];
                
                if (ship != nil)
                    record.ship = [NSString stringWithUTF8String:ship];
                
                if (total != nil)
                    record.total = [NSString stringWithUTF8String:total];
                
                if (type != nil)
                    record.type = [NSString stringWithUTF8String:type];
                
                if (username != nil)
                    record.username = [NSString stringWithUTF8String:username];
                
                if (address != nil)
                    record.address = [NSString stringWithUTF8String:address];
                
                if (telephone != nil)
                    record.telephone = [NSString stringWithUTF8String:telephone];
                
                [[GlobalData sharedGlobalData].g_arrayOrder addObject:record];
            }
            sqlite3_finalize(stmt_order);
        }
        
	}
	return self;
}

- (BOOL)updateUserDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_USER];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;

    UserData* record = [[UserData alloc] init];
    record = [GlobalData sharedGlobalData].g_userInfo;
    strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                TABLE_USER,
                record.userID,
                record.firstName,
                record.lastName,
                record.email,
                record.password,
                record.address,
                record.telephone,
                record.language,
                record.signup];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

//------- Wishlist Data ------------------

- (BOOL)onLoadWishlistDataDB {
    
    [GlobalData sharedGlobalData].g_arrayWishlist = [[NSMutableArray alloc] init];
    
    NSString *strQuery_wishlist = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", TABLE_WISHLIST, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
    sqlite3_stmt* stmt_wishlist;
    
    if (sqlite3_prepare_v2(dbHandler, [strQuery_wishlist UTF8String], -1, &stmt_wishlist, NULL) == SQLITE_OK) {
        //int userId;
        
        while(sqlite3_step(stmt_wishlist) == SQLITE_ROW) {
            ProductData *record = [[ProductData alloc] init];
            record.productId = @"";
            record.name = @"";
            record.price = @"";
            record.discount = @"";
            record.productDescription = @"";
            record.image = @"";
            record.percentage = @"";
            record.url = @"";
            record.sku = @"";
            record.size = @"";
            record.type = @"";
            record.origin = @"";
            record.fragrance = @"";
            
            char *productId = (char*)sqlite3_column_text(stmt_wishlist, 0);
            char *name = (char*)sqlite3_column_text(stmt_wishlist, 1);
            char *price = (char*)sqlite3_column_text(stmt_wishlist, 2);
            char *discount = (char*)sqlite3_column_text(stmt_wishlist, 3);
            char *productDescription = (char*)sqlite3_column_text(stmt_wishlist, 4);
            char *image = (char*)sqlite3_column_text(stmt_wishlist, 5);
            char *percentage = (char*)sqlite3_column_text(stmt_wishlist, 6);
            char *url = (char*)sqlite3_column_text(stmt_wishlist, 7);
            char *sku = (char*)sqlite3_column_text(stmt_wishlist, 8);
            char *size = (char*)sqlite3_column_text(stmt_wishlist, 9);
            char *type = (char*)sqlite3_column_text(stmt_wishlist, 10);
            char *origin = (char*)sqlite3_column_text(stmt_wishlist, 11);
            char *fragrance = (char*)sqlite3_column_text(stmt_wishlist, 12);
            
            if (productId != nil)
                record.productId = [NSString stringWithUTF8String:productId];
            
            if (name != nil)
                record.name = [NSString stringWithUTF8String:name];
            
            if (price != nil)
                record.price = [NSString stringWithUTF8String:price];
            
            if (discount != nil)
                record.discount = [NSString stringWithUTF8String:discount];
            
            if (productDescription != nil)
                record.productDescription = [NSString stringWithUTF8String:productDescription];
            
            if (image != nil)
                record.image = [NSString stringWithUTF8String:image];
            
            if (percentage != nil)
                record.percentage = [NSString stringWithUTF8String:percentage];
            
            if (url != nil)
                record.url = [NSString stringWithUTF8String:url];
            
            if (sku != nil)
                record.sku = [NSString stringWithUTF8String:sku];
            
            if (size != nil)
                record.size = [NSString stringWithUTF8String:size];
            
            if (type != nil)
                record.type = [NSString stringWithUTF8String:type];
            
            if (origin != nil)
                record.origin = [NSString stringWithUTF8String:origin];
            
            if (fragrance != nil)
                record.fragrance = [NSString stringWithUTF8String:fragrance];
            
            [[GlobalData sharedGlobalData].g_arrayWishlist addObject:record];
        }
        sqlite3_finalize(stmt_wishlist);
    }
    
    return YES;
}

- (BOOL)insertWishlistDataDB:(ProductData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          TABLE_WISHLIST,
                          record.productId,
                          record.name,
                          record.price,
                          record.discount,
                          record.productDescription,
                          record.image,
                          record.percentage,
                          record.url,
                          record.sku,
                          record.size,
                          record.type,
                          record.origin,
                          record.fragrance,
                          [GlobalData sharedGlobalData].g_userInfo.email];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)deleteWishlistDataDB:(ProductData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@' AND %@='%@'", TABLE_WISHLIST, FIELD_PRODUCT_ID, record.productId, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)deleteAllWishlistDataDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_WISHLIST];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)updateNoneWishlistDataDB {
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@='%@'",
                          TABLE_WISHLIST,
                          FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email,
                          FIELD_EMAIL, USER_NONE];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

//--------------- Cart Data ----------------

- (BOOL)onLoadCartDataDB {
    
    [GlobalData sharedGlobalData].g_arrayCart = [[NSMutableArray alloc] init];
    
    NSString *strQuery_cart = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", TABLE_CART, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
    sqlite3_stmt* stmt_cart;
    
    if (sqlite3_prepare_v2(dbHandler, [strQuery_cart UTF8String], -1, &stmt_cart, NULL) == SQLITE_OK) {
        //int userId;
        
        while(sqlite3_step(stmt_cart) == SQLITE_ROW) {
            ProductData *record = [[ProductData alloc] init];
            record.productId = @"";
            record.name = @"";
            record.price = @"";
            record.discount = @"";
            record.productDescription = @"";
            record.image = @"";
            record.percentage = @"";
            record.url = @"";
            record.sku = @"";
            record.size = @"";
            record.type = @"";
            record.origin = @"";
            record.fragrance = @"";
            record.productCount = 1;
            
            
            char *productId = (char*)sqlite3_column_text(stmt_cart, 0);
            char *name = (char*)sqlite3_column_text(stmt_cart, 1);
            char *price = (char*)sqlite3_column_text(stmt_cart, 2);
            char *discount = (char*)sqlite3_column_text(stmt_cart, 3);
            char *productDescription = (char*)sqlite3_column_text(stmt_cart, 4);
            char *image = (char*)sqlite3_column_text(stmt_cart, 5);
            char *percentage = (char*)sqlite3_column_text(stmt_cart, 6);
            char *url = (char*)sqlite3_column_text(stmt_cart, 7);
            char *sku = (char*)sqlite3_column_text(stmt_cart, 8);
            char *size = (char*)sqlite3_column_text(stmt_cart, 9);
            char *type = (char*)sqlite3_column_text(stmt_cart, 10);
            char *origin = (char*)sqlite3_column_text(stmt_cart, 11);
            char *fragrance = (char*)sqlite3_column_text(stmt_cart, 12);
            char *count = (char*)sqlite3_column_text(stmt_cart, 13);
            
            if (productId != nil)
                record.productId = [NSString stringWithUTF8String:productId];
            
            if (name != nil)
                record.name = [NSString stringWithUTF8String:name];
            
            if (price != nil)
                record.price = [NSString stringWithUTF8String:price];
            
            if (discount != nil)
                record.discount = [NSString stringWithUTF8String:discount];
            
            if (productDescription != nil)
                record.productDescription = [NSString stringWithUTF8String:productDescription];
            
            if (image != nil)
                record.image = [NSString stringWithUTF8String:image];
            
            if (percentage != nil)
                record.percentage = [NSString stringWithUTF8String:percentage];
            
            if (url != nil)
                record.url = [NSString stringWithUTF8String:url];
            
            if (sku != nil)
                record.sku = [NSString stringWithUTF8String:sku];
            
            if (size != nil)
                record.size = [NSString stringWithUTF8String:size];
            
            if (type != nil)
                record.type = [NSString stringWithUTF8String:type];
            
            if (origin != nil)
                record.origin = [NSString stringWithUTF8String:origin];
            
            if (fragrance != nil)
                record.fragrance = [NSString stringWithUTF8String:fragrance];
            
            if (count != nil)
                record.productCount = [[NSString stringWithUTF8String:count] intValue];
            
            [[GlobalData sharedGlobalData].g_arrayCart addObject:record];
        }
        sqlite3_finalize(stmt_cart);
    }
    
    return YES;
}

- (BOOL)insertCartDataDB:(ProductData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          TABLE_CART,
                          record.productId,
                          record.name,
                          record.price,
                          record.discount,
                          record.productDescription,
                          record.image,
                          record.percentage,
                          record.url,
                          record.sku,
                          record.size,
                          record.type,
                          record.origin,
                          record.fragrance,
                          [NSString stringWithFormat:@"%i", record.productCount],
                          [GlobalData sharedGlobalData].g_userInfo.email];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)deleteCartDataDB:(ProductData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@' AND %@='%@'", TABLE_CART, FIELD_PRODUCT_ID, record.productId, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)updateCartDataDB:(ProductData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@='%@' AND %@='%@'",
                          TABLE_CART,
                          FIELD_COUNT, [NSString stringWithFormat:@"%i", record.productCount],
                          FIELD_PRODUCT_ID, record.productId,
                          FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email];

    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)deleteAllCartDataDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_CART];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

- (BOOL)updateNoneCartDataDB {
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@='%@'",
                          TABLE_CART,
                          FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email,
                          FIELD_EMAIL, USER_NONE];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

//--------------- Order Data ----------------

- (BOOL)onLoadOrderDataDB {
    
    [GlobalData sharedGlobalData].g_arrayOrder = [[NSMutableArray alloc] init];
    
    NSString *strQuery_order = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' ORDER BY %@ DESC", TABLE_ORDER, FIELD_EMAIL, [GlobalData sharedGlobalData].g_userInfo.email, FIELD_ORDER_ID];
    sqlite3_stmt* stmt_order;
    
    if (sqlite3_prepare_v2(dbHandler, [strQuery_order UTF8String], -1, &stmt_order, NULL) == SQLITE_OK) {
        //int userId;
        
        while(sqlite3_step(stmt_order) == SQLITE_ROW) {
            OrderData *record = [[OrderData alloc] init];
            record.orderID = @"";
            record.date = @"";
            record.ship = @"";
            record.total = @"";
            record.type = @"";
            record.username = @"";
            record.address = @"";
            record.telephone = @"";
            record.couponCode = @"";
            record.discountPercent = @"";
            
            char *orderID = (char*)sqlite3_column_text(stmt_order, 0);
            char *date = (char*)sqlite3_column_text(stmt_order, 1);
            char *ship = (char*)sqlite3_column_text(stmt_order, 2);
            char *total = (char*)sqlite3_column_text(stmt_order, 3);
            char *type = (char*)sqlite3_column_text(stmt_order, 4);
            char *username = (char*)sqlite3_column_text(stmt_order, 5);
            char *address = (char*)sqlite3_column_text(stmt_order, 6);
            char *telephone = (char*)sqlite3_column_text(stmt_order, 7);
            char *couponCode = (char*)sqlite3_column_text(stmt_order, 9);
            char *discountPercent = (char*)sqlite3_column_text(stmt_order, 10);
            
            if (orderID != nil)
                record.orderID = [NSString stringWithUTF8String:orderID];
            
            if (date != nil)
                record.date = [NSString stringWithUTF8String:date];
            
            if (ship != nil)
                record.ship = [NSString stringWithUTF8String:ship];
            
            if (total != nil)
                record.total = [NSString stringWithUTF8String:total];
            
            if (type != nil)
                record.type = [NSString stringWithUTF8String:type];
            
            if (username != nil)
                record.username = [NSString stringWithUTF8String:username];
            
            if (address != nil)
                record.address = [NSString stringWithUTF8String:address];
            
            if (telephone != nil)
                record.telephone = [NSString stringWithUTF8String:telephone];
            
            if (couponCode != nil)
                record.couponCode = [NSString stringWithUTF8String:couponCode];
            
            if (discountPercent != nil)
                record.discountPercent = [NSString stringWithUTF8String:discountPercent];
            
            [[GlobalData sharedGlobalData].g_arrayOrder addObject:record];
        }
        sqlite3_finalize(stmt_order);
    }
    
    return YES;
}

- (BOOL)insertOrderDataDB:(OrderData*)record {
    
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%f')",
                          TABLE_ORDER,
                          record.orderID,
                          record.date,
                          record.ship,
                          record.total,
                          record.type,
                          record.username,
                          record.address,
                          record.telephone,
                          [GlobalData sharedGlobalData].g_userInfo.email,
                          [GlobalData sharedGlobalData].g_strCouponCode,
                          [GlobalData sharedGlobalData].g_discountPercent];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

//--------------- Product Data ----------------

- (BOOL)onLoadProductDataDB:(NSString*)strOrderId {
    
    NSString *strQuery_product = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", TABLE_PRODUCT, FIELD_ORDER_ID, strOrderId];
    sqlite3_stmt* stmt_product;
    
    if (sqlite3_prepare_v2(dbHandler, [strQuery_product UTF8String], -1, &stmt_product, NULL) == SQLITE_OK) {
        //int userId;
        [GlobalData sharedGlobalData].g_arrayProduct = [[NSMutableArray alloc] init];
        while(sqlite3_step(stmt_product) == SQLITE_ROW) {
            ProductData *record = [[ProductData alloc] init];
            record.productId = @"";
            record.name = @"";
            record.price = @"";
            record.discount = @"";
            record.productDescription = @"";
            record.image = @"";
            record.percentage = @"";
            record.url = @"";
            record.sku = @"";
            record.size = @"";
            record.type = @"";
            record.origin = @"";
            record.fragrance = @"";
            record.productCount = 1;
            
            char *productId = (char*)sqlite3_column_text(stmt_product, 0);
            char *name = (char*)sqlite3_column_text(stmt_product, 1);
            char *price = (char*)sqlite3_column_text(stmt_product, 2);
            char *discount = (char*)sqlite3_column_text(stmt_product, 3);
            char *productDescription = (char*)sqlite3_column_text(stmt_product, 4);
            char *image = (char*)sqlite3_column_text(stmt_product, 5);
            char *percentage = (char*)sqlite3_column_text(stmt_product, 6);
            char *url = (char*)sqlite3_column_text(stmt_product, 7);
            char *sku = (char*)sqlite3_column_text(stmt_product, 8);
            char *size = (char*)sqlite3_column_text(stmt_product, 9);
            char *type = (char*)sqlite3_column_text(stmt_product, 10);
            char *origin = (char*)sqlite3_column_text(stmt_product, 11);
            char *fragrance = (char*)sqlite3_column_text(stmt_product, 12);
            char *count = (char*)sqlite3_column_text(stmt_product, 13);
            
            if (productId != nil)
                record.productId = [NSString stringWithUTF8String:productId];
            
            if (name != nil)
                record.name = [NSString stringWithUTF8String:name];
            
            if (price != nil)
                record.price = [NSString stringWithUTF8String:price];
            
            if (discount != nil)
                record.discount = [NSString stringWithUTF8String:discount];
            
            if (productDescription != nil)
                record.productDescription = [NSString stringWithUTF8String:productDescription];
            
            if (image != nil)
                record.image = [NSString stringWithUTF8String:image];
            
            if (percentage != nil)
                record.percentage = [NSString stringWithUTF8String:percentage];
            
            if (url != nil)
                record.url = [NSString stringWithUTF8String:url];
            
            if (sku != nil)
                record.sku = [NSString stringWithUTF8String:sku];
            
            if (size != nil)
                record.size = [NSString stringWithUTF8String:size];
            
            if (type != nil)
                record.type = [NSString stringWithUTF8String:type];
            
            if (origin != nil)
                record.origin = [NSString stringWithUTF8String:origin];
            
            if (fragrance != nil)
                record.fragrance = [NSString stringWithUTF8String:fragrance];
            
            if (count != nil)
                record.productCount = [[NSString stringWithUTF8String:count] intValue];
            
            [[GlobalData sharedGlobalData].g_arrayProduct addObject:record];
        }
        sqlite3_finalize(stmt_product);
    }
    
    return YES;
}

- (BOOL)insertProductDataDB:(NSMutableArray*)productArray orderId:(NSString*)strOrderId {
    
    for (int i = 0; i < productArray.count; i++) {
        
        ProductData *record = [[ProductData alloc] init];
        record = productArray[i];
        
        NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                              TABLE_PRODUCT,
                              record.productId,
                              record.name,
                              record.price,
                              record.discount,
                              record.productDescription,
                              record.image,
                              record.percentage,
                              record.url,
                              record.sku,
                              record.size,
                              record.type,
                              record.origin,
                              record.fragrance,
                              [NSString stringWithFormat:@"%i", record.productCount],
                              strOrderId,
                              [GlobalData sharedGlobalData].g_userInfo.email];
        
        if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
            return NO;
        
    }
    
    return YES;
}

@end
