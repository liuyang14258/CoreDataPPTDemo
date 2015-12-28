//
//  TableViewController.m
//  CoreDataPPT
//
//  Created by 刘杨 on 15/11/11.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "TableViewController.h"
#import "DataBaseManager.h"
#import "Entity+CoreDataProperties.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insert)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)insert
{
    [[DataBaseManager sharedInstance] insertManagedObject:@"插入成功"];
    [[DataBaseManager sharedInstance] saveManaged];
    [self.tableView reloadData];
}

- (void)cancel
{
    [[DataBaseManager sharedInstance] deleteAllManagedObject];
    [[DataBaseManager sharedInstance] saveManaged];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataBaseManager sharedInstance] selectAllManagedObject] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if ([[DataBaseManager sharedInstance] selectAllManagedObject]) {
        NSArray *array = [[DataBaseManager sharedInstance] selectAllManagedObject];
        Entity *entity = array[indexPath.row];
        cell.textLabel.text = entity.name;
        cell.detailTextLabel.text = [entity.date description];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *array = [[DataBaseManager sharedInstance] selectAllManagedObject];
        Entity *entity = array[indexPath.row];
        [[DataBaseManager sharedInstance] deleteManagedObject:entity];
        [[DataBaseManager sharedInstance] saveManaged];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删我啊";
}

@end