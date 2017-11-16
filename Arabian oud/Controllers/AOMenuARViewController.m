//
//  AOMenuARViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/19/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOMenuARViewController.h"
#import "AOCategoryViewController.h"
#import "AOProfileViewController.h"
#import "AOLoginViewController.h"
#import "AOContactUsViewController.h"
#import "AOStoresLocationViewController.h"

@interface AOMenuARViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *itemsInTable;

@end

@implementation AOMenuARViewController

@synthesize m_btnAvatar, m_lblUserName, m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onLoadCategoryData];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)onLoadCategoryData {
    
    NSMutableArray* subCategoryArray1 = [[NSMutableArray alloc] init];
    
    NSDictionary *subCategoryDic11 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_MENS_COLLECTION,@"Name",[NSNumber numberWithInt:1],@"level",@"27",@"id", nil];
    NSDictionary *subCategoryDic12 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_WOMENS_COLLECTION,@"Name",[NSNumber numberWithInt:1],@"level",@"26",@"id", nil];
    NSDictionary *subCategoryDic13 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_UNISEX_COLLECTION,@"Name",[NSNumber numberWithInt:1],@"level",@"28",@"id", nil];
    NSDictionary *subCategoryDic14 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ORIENTAL_PERFUMES,@"Name",[NSNumber numberWithInt:1],@"level",@"30",@"id", nil];
    NSDictionary *subCategoryDic15 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_WESTERN_PERFUMES,@"Name",[NSNumber numberWithInt:1],@"level",@"29",@"id", nil];
    NSDictionary *subCategoryDic16 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ORIENTAL_WESTERN,@"Name",[NSNumber numberWithInt:1],@"level",@"31",@"id", nil];
    [subCategoryArray1 addObject:subCategoryDic11];
    [subCategoryArray1 addObject:subCategoryDic12];
    [subCategoryArray1 addObject:subCategoryDic13];
    [subCategoryArray1 addObject:subCategoryDic14];
    [subCategoryArray1 addObject:subCategoryDic15];
    [subCategoryArray1 addObject:subCategoryDic16];
    
    NSMutableArray* subCategoryArray2 = [[NSMutableArray alloc] init];
    
    NSDictionary *subCategoryDic21 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ARABIAN_OUD,@"Name",[NSNumber numberWithInt:1],@"level",@"36",@"id", nil];
    NSDictionary *subCategoryDic22 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ARABIAN_MAJOON,@"Name",[NSNumber numberWithInt:1],@"level",@"37",@"id", nil];
    NSDictionary *subCategoryDic23 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ARABIAN_MABTHOTH,@"Name",[NSNumber numberWithInt:1],@"level",@"38",@"id", nil];
    [subCategoryArray2 addObject:subCategoryDic21];
    [subCategoryArray2 addObject:subCategoryDic22];
    [subCategoryArray2 addObject:subCategoryDic23];
    
    NSMutableArray* subCategoryArray3 = [[NSMutableArray alloc] init];
    
    NSDictionary *subCategoryDic31 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_DEHN_OUD,@"Name",[NSNumber numberWithInt:1],@"level",@"7",@"id", nil];
    NSDictionary *subCategoryDic32 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_ARABIAN_BLENDS,@"Name",[NSNumber numberWithInt:1],@"level",@"24",@"id", nil];
    NSDictionary *subCategoryDic33 = [NSDictionary dictionaryWithObjectsAndKeys:SUBCATEGORY_AROMATIC_OILS,@"Name",[NSNumber numberWithInt:1],@"level",@"50",@"id", nil];
    [subCategoryArray3 addObject:subCategoryDic31];
    [subCategoryArray3 addObject:subCategoryDic32];
    [subCategoryArray3 addObject:subCategoryDic33];
    
    
    NSDictionary  *mainCategoryDic1 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_PERFUMES,@"Name",subCategoryArray1,@"SubItems",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_perfumes",@"icon",@"32",@"id", nil];
    NSDictionary  *mainCategoryDic2 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_OUD_INCENSE,@"Name",subCategoryArray2,@"SubItems",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_oud_incense",@"icon",@"34",@"id", nil];
    NSDictionary  *mainCategoryDic3 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_OIL_PERFUMES,@"Name",subCategoryArray3,@"SubItems",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_oil_perfumes",@"icon",@"35",@"id", nil];
    NSDictionary  *mainCategoryDic4 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_SPRAY_PERFUMES,@"Name",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_spray_perfums",@"icon",@"4",@"id", nil];
    NSDictionary  *mainCategoryDic5 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_EXCLUSIVE,@"Name",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_execlusive",@"icon",@"61",@"id", nil];
    NSDictionary  *mainCategoryDic6 = [NSDictionary  dictionaryWithObjectsAndKeys:CATEGORY_TODAY_DEALS,@"Name",[NSNumber numberWithInt:0],@"level",UNCHECKED,@"Checked",@"menu_intense_perfumes",@"icon",@"58",@"id", nil];
    
    
    self.itemsInTable = [[NSMutableArray alloc] init];
    
    [self.itemsInTable addObject:mainCategoryDic1];
    [self.itemsInTable addObject:mainCategoryDic2];
    [self.itemsInTable addObject:mainCategoryDic3];
    [self.itemsInTable addObject:mainCategoryDic4];
    [self.itemsInTable addObject:mainCategoryDic5];
    [self.itemsInTable addObject:mainCategoryDic6];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsInTable count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 0) {
        return 44 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
    } else {
        return 40 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Title = [[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    return [self createCellWithTitle:Title isCheck:[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Checked"] indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 1) {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)CollapseRows:(NSArray*)array
{
    for(NSDictionary *dInner in array )
    {
        NSUInteger indexToRemove=[self.itemsInTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"SubItems"];
        if(arInner && [arInner count]>0)
        {
            [self CollapseRows:arInner];
        }
        
        if([self.itemsInTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [self.itemsInTable removeObjectIdenticalTo:dInner];
            [self.m_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title isCheck:(NSString *)isCheck indexPath:(NSIndexPath*)indexPath
{
    if ([[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 0) {
        
        UITableViewCell* cell = (UITableViewCell*)[m_tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
        
        UIButton *m_btnMainCategory = [cell viewWithTag:1];
        UIButton *m_btnExpand = [cell viewWithTag:2];
        UILabel *m_lblCategory = [cell viewWithTag:3];
        
        m_lblCategory.text = [title uppercaseString];
        
        if ([isCheck isEqualToString:CHECKED]) {
            [m_btnExpand setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        } else {
            [m_btnExpand setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        }
        
        NSDictionary *d1 = [self.itemsInTable objectAtIndex:indexPath.row];
        
        if ([d1 valueForKey:@"SubItems"]) {
            m_btnExpand.hidden = NO;
            [m_btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            m_btnExpand.hidden = YES;
        }
        
        [m_btnMainCategory setImage:[UIImage imageNamed:[d1 valueForKey:@"icon"]] forState:UIControlStateNormal];
        [m_btnMainCategory addTarget:self action:@selector(showSubItemsChecked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* m_view = (UIView*)[cell viewWithTag:10];
        if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:cell];
        }
        
        return cell;
        
    } else {
        
        UITableViewCell* cell = (UITableViewCell*)[m_tableView dequeueReusableCellWithIdentifier:@"SubCategoryCell" forIndexPath:indexPath];
        
        UIButton *m_btnSubCategory = [cell viewWithTag:1];
        [m_btnSubCategory setTitle:title forState:UIControlStateNormal];
        
        [m_btnSubCategory addTarget:self action:@selector(showSubItemsChecked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* m_view = (UIView*)[cell viewWithTag:10];
        if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:cell];
        }
        
        return cell;
    }
}

-(void)showSubItemsChecked:(id) sender {
    
    UIButton *m_imgChecked = (UIButton*)sender;
    
    CGRect buttonFrameInTableView = [m_imgChecked convertRect:m_imgChecked.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    NSDictionary *dict = (NSDictionary *)[self.itemsInTable objectAtIndex:indexPath.row];
    
    [GlobalData sharedGlobalData].g_strCategory = [dict valueForKey:@"Name"];
    [GlobalData sharedGlobalData].g_strCategoryID = [dict valueForKey:@"id"];
    [self onGotoPerfumes];
}

-(void)showSubItems:(id) sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[self.itemsInTable objectAtIndex:indexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    
    if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"plus"]]) {
        [newDict setObject:CHECKED forKey:@"Checked"];
        [btn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    } else {
        [newDict setObject:UNCHECKED forKey:@"Checked"];
        [btn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    }
    
    [self.itemsInTable replaceObjectAtIndex:indexPath.row withObject:newDict];
    
    NSDictionary *d=[self.itemsInTable objectAtIndex:indexPath.row];
    NSArray *arr=[d valueForKey:@"SubItems"];
    
    if([d valueForKey:@"SubItems"]) {
        
        BOOL isTableExpanded=NO;
        
        for(NSDictionary *subitems in arr ) {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded) {
            [self CollapseRows:arr];
        } else {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr ) {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:count++];
            }
            [self.m_tableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
    
}

- (void)onGotoPerfumes {
    
    AOCategoryViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CATEGORY];
    [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
    
    [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)onChangeLanguage:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                    message:NSLocalizedString(@"change_language", "")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                          otherButtonTitles:NSLocalizedString(@"cancel", ""), nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        
        [NSBundle setLanguage:LANGUAGE_ENGLISH];
        [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
        
        [GlobalData sharedGlobalData].g_userInfo.language = LANGUAGE_ENGLISH;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        [NSBundle setLanguage:LANGUAGE_ENGLISH];
        
        exit(0);
        
    } else if (buttonIndex == 1) { // Cancel
        
//        [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
    }
}

- (IBAction)onSelectAccount:(id)sender {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.signup isEqualToString:USER_LOGIN]) {
        
        AOProfileViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_PROFILE];
        [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
        
        [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
        
    } else {
        
        AOLoginViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_LOGIN];
        [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
        
        [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
    }
}

- (IBAction)onSelectStore:(id)sender {
    
    AOStoresLocationViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_STORES_LOCATION];
    [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
    
    [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)onSelectContactUs:(id)sender {
    
    AOContactUsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CONTACTUS];
    [[GlobalData sharedGlobalData].g_mainCtrl.navigationController pushViewController:nextCtrl animated:YES];
    
    [[GlobalData sharedGlobalData].g_mainCtrl.rightMenuView hideRightViewAnimated:YES completionHandler:nil];
}

@end
