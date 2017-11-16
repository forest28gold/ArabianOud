//
//  GlobalData.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *_globalData = nil;

+ (GlobalData *) sharedGlobalData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalData == nil) {
            _globalData = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalData;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        [self setG_appDelegate:[[UIApplication sharedApplication] delegate]];       
    }
    
    return self;
}

#pragma mark - checking validate email

- (BOOL)checkingVaildateEmailWithString:(NSString *)strEmail
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,8}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:strEmail];
}

# pragma mark - Trim string

- (NSString *)trimString:(NSString *) string
{   
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - converting date

- (NSDate *)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat TimeZone:(NSTimeZone *) timeZone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (strDateFormat == nil || [@"" isEqualToString:strDateFormat]) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:strDateFormat];
    }
    
    if (timeZone != nil) {
        
        dateFormatter.timeZone = timeZone;
    }
    
    return [dateFormatter dateFromString:strDate];
}

#pragma mark - saving to user defaults

- (void)saveToUserDefaultsWithValue:(id)value
                                 Key:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:strKey];
        [standardUserDefaults synchronize];
    }
}

- (id)userDefaultWithKey:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:strKey];
    }
    
    return nil;
}

- (void)removeValueFromUserDefaults:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:strKey];
        [standardUserDefaults synchronize];
    }
}

#pragma mark - checking validate credit card

- (BOOL)isValidCheckDigitForCardNumberString:(NSString *)cardNumberString {
    int checkSum = 0;
    uint8_t *cardDigitArray = (uint8_t *)[cardNumberString dataUsingEncoding:NSUTF8StringEncoding].bytes;
    int digitsCount = (int)cardNumberString.length;
    BOOL odd = cardNumberString.length % 2;
    
    for (int digitIndex=0; digitIndex<digitsCount; digitIndex++) {
        uint8_t cardDigit = cardDigitArray[digitIndex] - '0';
        if (digitIndex % 2 == odd) {
            cardDigit = cardDigit * 2;
            cardDigit = cardDigit / 10 + cardDigit % 10;
        }
        checkSum += cardDigit;
    }
    
    return (checkSum % 10 == 0);
}

#pragma mark - hex color

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    
    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

#pragma mark - get current date

- (NSString*)getCurrentDate {
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Min
    [formatter setDateFormat:@"mm"];
    NSString *currentMinString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Second
    [formatter setDateFormat:@"ss"];
    NSString *currentSecondString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@", currentMonthString, currentDateString, currentyearString, currentHourString, currentMinString, currentSecondString];
}

#pragma mark - show error alert

- (void)onErrorAlert:(NSString*)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                          otherButtonTitles:nil];
    [alert show];
}

@end
