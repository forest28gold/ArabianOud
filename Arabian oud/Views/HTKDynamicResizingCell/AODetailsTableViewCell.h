//
//  AODetailsTableViewCell.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HTKDynamicResizingTableViewCell.h"
#import "HTKDynamicResizingCellProtocol.h"

/**
 * Default cell size. This is required to properly size cells.
 */
#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 40}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface AODetailsTableViewCell : HTKDynamicResizingTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *viewSeperate;

/**
 * Sets up the cell with data
 */
- (void)setupCellWithData:(DetailsData *)data;

@end
