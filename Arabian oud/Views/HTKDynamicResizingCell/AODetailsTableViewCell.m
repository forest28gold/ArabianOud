//
//  AODetailsTableViewCell.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//


#import "AODetailsTableViewCell.h"

@interface AODetailsTableViewCell ()


@end

@implementation AODetailsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Fix for contentView constraint warning
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.contentLabel];
    
    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    self.viewSeperate.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_titleLabel, _contentLabel, _viewSeperate);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @15, @"verticalBuffer" : @10, @"seperateHeight" : @1};
    
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_titleLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_contentLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewSeperate]|" options:0 metrics:metricDict views:viewDict]];
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_titleLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_titleLabel]-verticalBuffer-[_contentLabel]-verticalBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_titleLabel]-verticalBuffer-[_contentLabel]-verticalBuffer-[_viewSeperate(seperateHeight)]-seperateHeight-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.contentLabel.preferredMaxLayoutWidth = defaultSize.width;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.contentView];
}

- (void)setupCellWithData:(DetailsData *)data {
    
    // Pull out sample data
    NSString *strTitle = data.title;
    NSString *strContent = data.details;
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    
    // Set values
    self.titleLabel.text = strTitle;
    self.contentLabel.text = strContent;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.contentLabel.text
                                                    options:0
                                                      range:NSMakeRange(0, [self.contentLabel.text length])];
    if (match) {
        self.contentLabel.textAlignment = NSTextAlignmentRight;
    } else if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        self.contentLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
    }

}

@end

