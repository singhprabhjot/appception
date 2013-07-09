//
//  PSMasterViewController.m
//  iOSAppception
//
//  Created by Prabhjot on 7/1/13.
//  Copyright (c) 2013 Appception. All rights reserved.
//

#import "PSMasterViewController.h"
#import "PSDetailViewController.h"

@interface PSMasterViewController () {
    NSMutableArray *_objects;
}
@end

id jsonObjects;

@implementation PSMasterViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Word List", @"Word List");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    _objects = [[NSMutableArray alloc] init];
    [self readTextFromFile:@"synonym"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
        cell.textLabel.text = [_objects objectAtIndex:indexPath.row];
//      cell.imageView.image = [UIImage imageNamed:@"appception.jpg"];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *object = _objects[indexPath.row];
   NSString *synonyms= [jsonObjects objectForKey:object];    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[PSDetailViewController alloc] initWithNibName:@"PSDetailViewController_iPhone" bundle:nil];
	    }
	    self.detailViewController.detailItem = synonyms;
        self.detailViewController.labelWord = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.labelWord = object;
        self.detailViewController.detailItem = synonyms;
    }
    object = nil;
    synonyms = nil;
}

-(void) readTextFromFile: (NSString*) fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (jsonData) {
        jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"error is %@", [error localizedDescription]);
            return;
        }
        NSArray *keys = [jsonObjects allKeys];
        for (NSString *key in keys) {
            [_objects addObject:key];
        }
        [_objects sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    } else {
         NSLog(@"Not found");
    }
    filePath =nil;
    jsonData = nil; 
}

@end
