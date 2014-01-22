//
//  JSMTableViewController.h
//  Inventar
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JSMTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

- (NSFetchedResultsController *) fetchedResultsController;

@end
