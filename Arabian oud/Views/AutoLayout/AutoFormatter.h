//
//  AutoFormatter.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoFormatter : UIView
{
    
}

@property(readwrite) float SCALE_X;
@property(readwrite) float SCALE_Y;

+(AutoFormatter*)getInstance;

- (void) initTextFldType:(UITextField*)_textFld placeholder:(NSString*)_txt;
- (void) resizeView:(UIView*)__view;

@end
