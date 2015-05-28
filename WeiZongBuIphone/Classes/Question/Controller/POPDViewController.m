//
//  POPDViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDViewController.h"
#import "POPDCell.h"

#define TABLECOLOR [UIColor colorWithRed:208.0/255.0 green:221.0/255.0 blue:212.0/255.0 alpha:1.0]
#define CELLSELECTED [UIColor colorWithRed:228.0/255.0 green:217.0/255.0 blue:225.0/255.0 alpha:1.0]
#define SEPARATOR [UIColor colorWithRed:31.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0]
#define SEPSHADOW [UIColor colorWithRed:80.0/255.0 green:97.0/255.0 blue:110.0/255.0 alpha:1.0]
#define SHADOW [UIColor colorWithRed:69.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0]
#define TEXT [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]

static NSString *kheader = @"menuSectionHeader";
static NSString *ksubSection = @"menuSubSection";

@interface POPDViewController ()
@property NSArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *showingArray;
@end


@implementation POPDViewController
@synthesize delegate;

- (id)initWithMenuSections:(NSArray *) menuSections
{
    self = [super init];
    if (self) {
        self.sections = menuSections;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = TABLECOLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.tableView.frame = self.view.frame;

    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
   [self setMenuSections:self.sections];
    
     [self setExtraCellLineHidden:self.tableView];
    
}

- (void)setMenuSections:(NSArray *)menuSections{
    
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:kheader];
        NSArray *subSection = [sec objectForKey:ksubSection];

        NSMutableArray *section = [NSMutableArray new];
        [section addObject:header];
        
        for (NSString *sub in subSection) {
            [section addObject:sub];
        }
        [self.sectionsArray addObject:section];
        [self.showingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else{
        return [[self.sectionsArray objectAtIndex:section]count];;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (![[self.showingArray objectAtIndex:section]boolValue]) {
        return 50;
    }
    else
    {
        if (section==0) {
            if (row==0) {
                return 50;
            }
            else
                return 270;
            
        }
        else if(section==1)
        {
            if (row==0) {
                return 50;
            }
            else
                return 200;
        }
        else if(section==2)
        {
            if (row==0) {
                return 50;
            }
            else
                return 270;
        }
        else if(section==3)
        {
            if (row==0) {
                return 50;
            }
            else
                return 330;
        }
        else if(section==4)
        {
            if (row==0) {
                return 50;
            }
            else
                return 150;
        }
        else
            return 50;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row ==0){
    if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
        [cell setBackgroundColor:CELLSELECTED];
    }else{
//        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:TABLECOLOR];
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    
    POPDCell *cell = nil;
    cell = (POPDCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"POPDCell" owner:self options:nil];
    
    if (cell == nil) {
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.backgroundColor = TABLECOLOR;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (![[self.showingArray objectAtIndex:indexPath.section]boolValue]) {
        cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 44);
    }
    else
    {
        if (section==0) {
            if (row==0) {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30,44);
                cell.labelText.font = [UIFont systemFontOfSize:15.0f];
            }
            else
            {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 250);
                cell.labelText.font = [UIFont systemFontOfSize:14.0f];
            }
        }
        else if(section==1)
        {
            if (row==0) {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30,44);
                cell.labelText.font = [UIFont systemFontOfSize:15.0f];
            }
            else
            {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 180);
                cell.labelText.font = [UIFont systemFontOfSize:14.0f];
            }
        }
        else if(section==2)
        {
            if (row==0) {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30,44);
                 cell.labelText.font = [UIFont systemFontOfSize:15.0f];
            }
            else
            {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 250);
                cell.labelText.font = [UIFont systemFontOfSize:14.0f];
            }
        }

        else if(section==3)
        {
            if (row==0) {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30,44);
                cell.labelText.font = [UIFont systemFontOfSize:15.0f];
            }
            else
            {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 310);
                cell.labelText.font = [UIFont systemFontOfSize:14.0f];
            }
        }

        else if(section==4)
        {
            if (row==0) {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30,44);
                cell.labelText.font = [UIFont systemFontOfSize:15.0f];
            }
            else
            {
                cell.labelText.frame = CGRectMake(20, 7, self.view.frame.size.width-30, 130);
                cell.labelText.font = [UIFont systemFontOfSize:14.0f];
            }
        }

        
        
    }
    
    
    cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.labelText.numberOfLines=0;
    
    
    
    cell.labelText.textColor = TEXT;
//    cell.separator.backgroundColor = SEPARATOR;
//    cell.sepShadow.backgroundColor = SEPSHADOW;
//    cell.shadow.backgroundColor = SHADOW;
    
    cell.separator.hidden=YES;
    cell.sepShadow.hidden=YES;
    cell.shadow.hidden=YES;


    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
        [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
    }else{
        [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    [self.delegate didSelectRowAtIndexPath:indexPath];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
