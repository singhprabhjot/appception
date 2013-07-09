//
//  PSMasterViewController.h
//  iOSAppception
//
//  Created by Prabhjot on 7/1/13.
//  Copyright (c) 2013 Appception. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSDetailViewController;

@interface PSMasterViewController : UITableViewController

@property (strong, nonatomic) PSDetailViewController *detailViewController;
@property (nonatomic) BOOL loadingMoreTableViewData;

@end
