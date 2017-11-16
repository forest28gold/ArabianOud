//
// Copyright (c) 2016 by ACI Worldwide, Inc.
// All rights reserved.
//
// This software is the confidential and proprietary information
// of ACI Worldwide Inc ("Confidential Information"). You shall
// not disclose such Confidential Information and shall use it
// only in accordance with the terms of the license agreement
// you entered with ACI Worldwide Inc.
//

#import <UIKit/UIKit.h>
#import "OPPCheckoutPaymentMethod.h"

/**
 Class that extends UIButton in order to esily integrate separate payment methods in the app.
 
 By default button contains appropriate logo if a valid payment method is set. Button can be fully customized as common UIButton.
 
 [OPPCheckoutProvider presentCheckoutWithPaymentMethod:loadingHandler:completionHandler:cancelHandler:] is recommended to use in button action method to create and submit a transaction.
 */
NS_ASSUME_NONNULL_BEGIN
@interface OPPPaymentButton : UIButton

/** @name Initialization methods */

/**
 Creates and returns payment button initialized with the payment method.
 @param paymentMethod Payment method for the transaction.
 */
+ (instancetype)paymentButtonWithPaymentMethod:(OPPCheckoutPaymentMethod)paymentMethod;

/**
 Creates and returns payment button initialized with the payment method.
 @param paymentMethod Payment method for the transaction.
 */
- (instancetype)initWithPaymentMethod:(OPPCheckoutPaymentMethod)paymentMethod;


/** @name Properties */
/** 
 Payment method for the transaction that is used to display an appropriate logo.
 @see OPPCheckoutPaymentMethod The list of supported payment methods.
 */
@property (nonatomic) OPPCheckoutPaymentMethod paymentMethod;

@end
NS_ASSUME_NONNULL_END
