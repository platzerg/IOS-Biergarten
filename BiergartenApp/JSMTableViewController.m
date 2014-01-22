//
//  JSMTableViewController.m
//  Inventar
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSMTableViewController.h"
#import "JSMToolbox.h"
#import "Constants.h"

@interface JSMTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *barButtonItemEdit;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemDone;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemCancel;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemSearch;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemAdd;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemDelete;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation JSMTableViewController
@synthesize barButtonItemEdit = _barButtonItemEdit;
@synthesize barButtonItemDone = _barButtonItemDone;
@synthesize barButtonItemCancel = _barButtonItemCancel;
@synthesize barButtonItemSearch = _barButtonItemSearch;
@synthesize barButtonItemAdd = _barButtonItemAdd;
@synthesize barButtonItemDelete = _barButtonItemDelete;
@synthesize searchBar = _searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialisieren der BarButtonItems
    self.barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barButtonItemAddPressed:)];
    self.barButtonItemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemCancelPressed:)];
    self.barButtonItemDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(barButtonItemDeletePressed:)];
    self.barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemDonePressed:)];
    self.barButtonItemEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(barButtonItemEditPressed:)];
    self.barButtonItemSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(barButtonItemSearchPressed:)];
    
    // Setzen der RightBarButtonItems
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil];
    
    // Toolbar aufbauen
    self.toolbarItems = [NSArray arrayWithObjects:
                         self.barButtonItemDelete, 
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         self.barButtonItemAdd,
                         nil
                         ];
    
    // Den Style der Toolbar setzen
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // Aufbau der SearchBar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleBlackOpaque;
    self.searchBar.showsCancelButton = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.barButtonItemAdd = nil;
    self.barButtonItemCancel = nil;
    self.barButtonItemDelete = nil;
    self.barButtonItemDone = nil;
    self.barButtonItemEdit = nil;
    self.barButtonItemSearch = nil;
    self.searchBar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudReload:) name:cNotificationPersistentStoreAdded object:nil];
}

- (void) cloudReload: (id) sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [JSMCoreDataHelper performFetchOnFetchedResultsController:self.fetchedResultsController];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tableView.isEditing) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cNotificationPersistentStoreAdded object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return self.tableView.isEditing;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[[JSMCoreDataHelper sharedInstance] managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }   
}

#pragma mark - barButtonItmes
- (void) barButtonItemEditPressed: (id) sender
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.tableView setEditing:YES animated:YES];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemDone, self.barButtonItemSearch, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.barButtonItemCancel animated:YES];
}

- (void) barButtonItemDonePressed: (id) sender
{
    [JSMCoreDataHelper saveManagedObjectContext:[[JSMCoreDataHelper sharedInstance] managedObjectContext]];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

- (void) barButtonItemCancelPressed: (id) sender
{
    [[[JSMCoreDataHelper sharedInstance] managedObjectContext] rollback];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemEdit, self.barButtonItemSearch, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

- (void) barButtonItemSearchPressed: (id) sender
{
    if (self.tableView.tableHeaderView == nil) { // Die Searchbar ist noch nicht da
        [self.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchBar;
        [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:NO];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        self.searchBar.text = nil;
        [self searchBar:self.searchBar textDidChange:nil];
        if (self.tableView.contentOffset.y <= self.tableView.tableHeaderView.frame.size.height) {
            [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.tableView.tableHeaderView = nil;
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            });
        } else {
            CGFloat yOffset = self.tableView.contentOffset.y - self.tableView.tableHeaderView.frame.size.height;
            self.tableView.tableHeaderView = nil;
            [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }
    }
}

- (void) barButtonItemAddPressed: (id) sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) barButtonItemDeletePressed: (id) sender
{
    JSMBlockAlertView *alert = [[JSMBlockAlertView alloc] initWithTitle:@"Bestätigung" message:@"Wollen Sie wirklich alle angezeigten Datensätze löschen?"];
    [alert addButtonWithTitle:@"Ja" andBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSManagedObject *managedObject in self.fetchedResultsController.fetchedObjects) {
                [[[JSMCoreDataHelper sharedInstance] managedObjectContext] deleteObject:managedObject];
            }
        });
    }];
    [alert addButtonWithTitle:@"Nein" andBlock:nil];
    [alert show];
}

#pragma mark - must be overloaded methods
- (NSFetchedResultsController *) fetchedResultsController
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subcluss", NSStringFromSelector(_cmd)] userInfo:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.barButtonItemSearch.tintColor = [UIColor orangeColor];
    } else {
        self.barButtonItemSearch.tintColor = nil;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}
@end
