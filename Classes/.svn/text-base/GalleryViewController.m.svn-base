//
//  GalleryViewController.m
//  VenueConnect
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "SetsCell.h"
#import "JSON.h"
#import "VenueConnect.h"

@implementation GalleryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	defaults = [NSUserDefaults standardUserDefaults];
	appDelegate = (BoulderTheaterAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	currentView = @"sets";
	backButton.alpha = 0.0;
	
	photoViewController = [[PhotoViewController alloc] init];
	photoViewController.parent = self;
	photosViewer = [[UINavigationController alloc] initWithRootViewController:photoViewController];
	photosViewer.navigationBar.topItem.title = @"Photos";
	photosViewer.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:photoViewController action:@selector(backAction)];
	photosViewer.navigationBar.topItem.leftBarButtonItem = back;
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:photoViewController action:@selector(doneAction)];
	photosViewer.navigationBar.topItem.rightBarButtonItem = done;
	[done release];
	
	sets = [[defaults objectForKey:@"sets"] retain];
	if([sets count] > 0) {
		loader.hidden = YES;
	} else {
		loader.hidden = NO;
	}
	
	[self performSelectorInBackground:@selector(loadSets) withObject:nil];
}

- (void)loadSets {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"gallery_feed"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
		NSData *urlData;
		NSURLResponse *response;
		NSError *error;
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [[SBJSON alloc] init];
		sets = [[[[jsonParser objectWithString:[[returnString substringToIndex:[returnString length]-1] substringFromIndex:14] error:&error] objectForKey:@"photosets"] objectForKey:@"photoset"] retain];
		[jsonParser release];
		[returnString release];
		
		[defaults setObject:sets forKey:@"sets"];
	} else {
		if([sets count] == 0) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,210,300,20)];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor whiteColor];
			label.numberOfLines = 0;
			label.font = [UIFont boldSystemFontOfSize:13];
			label.textAlignment = UITextAlignmentCenter;
			label.text = @"You must be connected to the internet to view the photo galleries.";
			[label sizeToFit];
			[self.view addSubview:label];
			[label release];
		}
	}
	
	[self performSelectorOnMainThread:@selector(reloadTables) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

- (void)reloadTables {
	loader.hidden = YES;
	[setsTable reloadData];
}


#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [sets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SetsCell *cell = (SetsCell *)[tableView dequeueReusableCellWithIdentifier:@"identifier"];
	
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SetsCell" owner:self options:nil];
		cell = [nibs objectAtIndex:0];
    }
	
	cell.title.text = [NSString stringWithFormat:@"%@ (%@)",[[[sets objectAtIndex:indexPath.row] objectForKey:@"title"] objectForKey:@"_content"],[[sets objectAtIndex:indexPath.row] objectForKey:@"photos"]];
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		appDelegate.advert.alpha = 0.0;
		photosViewer.navigationBar.topItem.title = [[[sets objectAtIndex:indexPath.row] objectForKey:@"title"] objectForKey:@"_content"];
		[photoViewController setSource:[NSString stringWithFormat:[defaults objectForKey:@"set_string"],[[sets objectAtIndex:indexPath.row] objectForKey:@"id"]]];
		[appDelegate.tabBarController presentModalViewController:photosViewer animated:YES];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to view this gallery's photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


#pragma mark -

- (void)hidePhotoViewer {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:0.2];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	appDelegate.advert.alpha = 1.0;
	[UIView commitAnimations];
	
	[appDelegate.tabBarController dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[photoViewController release];
	[photosViewer release];
}


@end
