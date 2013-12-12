//
//  SuggestListTableViewController.m
//  Lime Finder
//
//  Created by idstorm on 13. 6. 6..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "SuggestListTableViewController.h"
#import "RootViewController.h"
#import "SuggestListTableViewCell.h"

@interface SuggestListTableViewController ()


@end

@implementation SuggestListTableViewController
@synthesize rootViewController_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = rootViewController_.mainViewController_.searchView_.suggestArray_.count;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    SuggestListTableViewCell *cell = [[SuggestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.tag = indexPath.row;
    NSString *suggestString = [[NSString alloc] initWithFormat:@"%@ ", [rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:indexPath.row]];
    [cell.label_ setText:suggestString];
    [cell.label_ setFont:[UIFont systemFontOfSize:16.0]];
    [cell.label_ setTextColor:[[UIColor alloc] initWithRed:(153.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1.0]];
    [cell.label_ setTextColor:[[UIColor alloc] initWithRed:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0] range:[suggestString rangeOfString:rootViewController_.mainViewController_.searchView_.searchField_.text]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([rootViewController_.mainViewController_.searchView_.searchField_.text isEqualToString:[rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:indexPath.row]])
        cell.suggestAddButton_.hidden = YES;
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (rootViewController_.mainViewController_.searchView_.searchViewState_ == SEARCH_VIEW_STATE_SEARCH)
    {
        rootViewController_.mainViewController_.searchView_.searchField_.text = [rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:indexPath.row];
        [rootViewController_.mainViewController_.listTableViewController_ setSearchString:rootViewController_.mainViewController_.searchView_.searchField_.text];
        [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
        [rootViewController_.mainViewController_.searchView_.searchField_ resignFirstResponder];
    }
    else
    {
        rootViewController_.mainViewController_.searchView_.searchField_.text = [rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:indexPath.row];
        NSString *string = rootViewController_.mainViewController_.searchView_.searchField_.text;
        NSString *urlString = @"";
        if (![string isEqualToString:@""] && string != nil)
        {
            [rootViewController_.mainViewController_.searchView_.searchField_ resignFirstResponder];
            urlString = [rootViewController_.mainViewController_.searchView_ getURLStringWithString:string];
            [rootViewController_.webViewController_.webNavigationBar_ selectListButton:NO];
            [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:urlString]];
            [rootViewController_ showWebView];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

@end
