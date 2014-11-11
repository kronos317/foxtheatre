//
//  GalleryViewController.h
//  BoulderTheater
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"
#import "BoulderTheaterAppDelegate.h"


@interface GalleryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	NSArray *sets;
	NSUserDefaults *defaults;
	NSString *currentView;
	
	BoulderTheaterAppDelegate *appDelegate;
	
	PhotoViewController *photoViewController;
	UINavigationController *photosViewer;
	
	IBOutlet UITableView *setsTable;
	IBOutlet UIButton *backButton;
	IBOutlet UIView *loader;
}

- (void)loadSets;
- (void)reloadTables;

- (void)hidePhotoViewer;

@end
