//
//  CalendarViewController.m
//  BoulderTheater
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "JSON.h"
#import "ShowCell.h"
#import "AudioStreamer.h"
#import "ASIFormDataRequest.h"
#import "UIImage+Resize.h"
#import "VenueConnect.h"

@implementation CalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    m_isShowsTable = true;
	
	defaults = [NSUserDefaults standardUserDefaults];
	appDelegate = (BoulderTheaterAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	currentView = @"home";
	currentShow = -1;
	backButton.alpha = 0.0;
    
    // CGRect rtWebView = webView.frame;
	// webView.frame = CGRectMake(G_WIDTH,rtWebView.origin.y,rtWebView.size.width,rtWebView.size.height);
    webView.frame = [self moveFrameHorz:webView.frame :G_WIDTH];
    
    // CGRect rtDetailsView = detailView.frame;
	// detailView.frame = CGRectMake(G_WIDTH, rtDetailsView.origin.y, rtDetailsView.size.width, rtDetailsView.size.height);
    detailView.frame = [self moveFrameHorz:detailView.frame :G_WIDTH];
    
	[favoritesTable removeFromSuperview];
	
	// shows = [[defaults objectForKey:@"shows"] retain];
    NSString *returnString = [defaults objectForKey:@"shows"];
    NSError *error;
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSArray *tempShows;
    shows = nil;
    
    @try{
        tempShows = [[jsonParser objectWithString:returnString error:&error] objectForKey:@"showDates"];
        
        shows = nil;
        if([tempShows count] > 0) {
            shows = [[NSMutableArray arrayWithArray:tempShows] retain];
            for (NSDictionary *d in shows){
                if ([[d objectForKey:@"opener"] isKindOfClass:[NSNull class]]){
                    [d setValue:@"" forKey:@"opener"];
                }
            }
        }
    }
    @catch(NSException *exception){
        
    }
    
    /***** Remove past shows from [shows] *****/
    
    NSMutableArray *pastShows = [NSMutableArray arrayWithCapacity:4];
    for (NSDictionary *d in shows){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"showDate"]];
        date = [date dateByAddingTimeInterval:86400];
        // date = [date addTimeInterval:86400];
        [dateFormatter release];
        
        NSDate *today = [NSDate date];
        //NSLog(@"%@ : %@ :: %@",date,today,[today laterDate:date]);
        if([today laterDate:date] == today) {
            [pastShows addObject:d];
        }
    }
    [shows removeObjectsInArray:pastShows];
    
	favorites = [[NSMutableArray arrayWithArray:[defaults objectForKey:@"favorites"]] retain];
	
	NSMutableArray *pastFavs = [NSMutableArray arrayWithCapacity:4];
	for(NSDictionary *d in favorites) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"showDate"]];
        date = [date dateByAddingTimeInterval:86400];
		// date = [date addTimeInterval:86400];
		[dateFormatter release];
		
		NSDate *today = [NSDate date];
		//NSLog(@"%@ : %@ :: %@",date,today,[today laterDate:date]);
		if([today laterDate:date] == today) {
			[pastFavs addObject:d];
		}
	}
	[favorites removeObjectsInArray:pastFavs];
	[defaults setObject:favorites forKey:@"favorites"];
	[self reloadTables];
	
	if([[defaults objectForKey:@"openToFavorites"] isEqualToString:@"YES"]) {
		[self flipTables];
		[defaults setObject:@"NO" forKey:@"openToFavorites"];
	}
	
	[self performSelectorInBackground:@selector(loadShows) withObject:nil];
}

- (void)loadShows {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		int i = 0;
		while([appDelegate.finishedInitLoad intValue] == 0) {
			i++;
		}
		//NSLog(@"GOSHOWS");
		
        NSString *szUrl = [defaults objectForKey:@"shows_feed"];
        NSLog(@"%@",szUrl);
        if (szUrl == nil || szUrl.length == 0){
            szUrl = @"http://foxtheatre.com/json_upcomingshows.aspx";
        }
		// NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"shows_feed"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:szUrl] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30];

        // NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:szUrl]];
        
		NSData *urlData;
		NSURLResponse *response;
		NSError *error;
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		
		// replace all occurrences of &#39; with apostrophes
		NSString *processedString = [returnString stringByReplacingOccurrencesOfString: @"&#39;" withString:@"'"];

		SBJSON *jsonParser = [[SBJSON alloc] init];
		NSArray *tempShows = [[jsonParser objectWithString:processedString error:&error] objectForKey:@"showDates"];

		if([tempShows count] > 0) {
			[shows release];
			shows = nil;
			shows = [[NSMutableArray arrayWithArray:tempShows] retain];
            for (NSDictionary *d in shows){
                if ([[d objectForKey:@"opener"] isKindOfClass:[NSNull class]]){
                    [d setValue:@"" forKey:@"opener"];
                }
            }
			// [defaults setObject:shows forKey:@"shows"];
            
            /***** Remove past shows from [shows] *****/
            
            NSMutableArray *pastShows = [NSMutableArray arrayWithCapacity:4];
            for (NSDictionary *d in shows){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"showDate"]];
                date = [date dateByAddingTimeInterval:86400];
                // date = [date addTimeInterval:86400];
                [dateFormatter release];
                
                NSDate *today = [NSDate date];
                //NSLog(@"%@ : %@ :: %@",date,today,[today laterDate:date]);
                if([today laterDate:date] == today) {
                    [pastShows addObject:d];
                }
            }
            [shows removeObjectsInArray:pastShows];
            
            [defaults setObject:processedString forKey:@"shows"];
		}
		
		
		[jsonParser release];
		[returnString release];
	} else {
		if([shows count] == 0) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,210,300,20)];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor whiteColor];
			label.numberOfLines = 0;
			label.font = [UIFont boldSystemFontOfSize:13];
			label.textAlignment = NSTextAlignmentCenter;
			label.text = @"You must be connected to the internet to get the list of the newest shows.";
			[label sizeToFit];
			[self.view addSubview:label];
			[label release];
		}
	}
	
	[self performSelectorOnMainThread:@selector(reloadTables) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

- (void)reloadTables {
	[showsTable reloadData];
	[favoritesTable reloadData];
}

- (IBAction)flipTables {
	// if([showsTable superview]) {
    if(m_isShowsTable == true) {
		if([favorites count] == 0) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You do not currently have any shows favorited."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert setTag:0];
			[alert show];
			[alert release];
		} else {
			[flipButton setTitle:@"All Shows" forState:UIControlStateNormal];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tablesHolder cache:YES];
			[showsTable removeFromSuperview];
			[tablesHolder addSubview:favoritesTable];
			[UIView commitAnimations];
            m_isShowsTable = false;
		}
	} else {
		[flipButton setTitle:@"Favorites" forState:UIControlStateNormal];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tablesHolder cache:YES];
		[favoritesTable removeFromSuperview];
		[tablesHolder addSubview:showsTable];
		[UIView commitAnimations];
        m_isShowsTable = true;
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1) {
		if(buttonIndex == 1) {
			//ADD TO FAVORITES
			[favorites addObject:[defaults objectForKey:@"tempFavoritesDict"]];
            // [favorites addObject:[self getTempFavoritesDictFromDefaults]];
            
			[self reloadTables];
			[self flipTables];
			
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
			NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,nil];
			[favorites sortUsingDescriptors:sortDescriptors];
			[sortDescriptor release];
			
			//REGISTER FOR NOTIFICATION
			NSInteger timeDiff = [[NSTimeZone localTimeZone] secondsFromGMT];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			NSDate *date = [dateFormatter dateFromString:[[defaults objectForKey:@"tempFavoritesDict"] objectForKey:@"showDate"]];
            date = [date dateByAddingTimeInterval:-216000 - timeDiff];
			// date = [date addTimeInterval:-216000 - timeDiff];
            
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSString *newDate = [dateFormatter stringFromDate:date];
			
			//NSDate *now = [NSDate dateWithTimeInterval:180-timeDiff sinceDate:[NSDate date]];
			//NSString *newDate = [dateFormatter stringFromDate:now];
			//NSLog(@"scheduled date=%@", newDate);
			
			[dateFormatter release];
			
			NSURL *url = [NSURL URLWithString:@"https://go.urbanairship.com/api/push/"];
			ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
			request.requestMethod = @"POST";
			
			//NSLog(@"%@, %@",newDate,[defaults objectForKey:@"_UALastDeviceToken"]);
			// Send along our device alias as the JSON encoded request body
			[request addRequestHeader: @"Content-Type" value: @"application/json"];
			[request appendPostData:[[NSString stringWithFormat:@"{\"device_tokens\": [\"%@\"] ,\"schedule_for\": [ { \"alias\": \"%@_%@\", \"scheduled_time\": \"%@\" } ],\"aps\": { \"badge\": 0, \"alert\": \"You have an upcoming show at The Fox Theater in your Favorites Folder!\", \"sound\": \"default\" } }",
									  [defaults objectForKey:@"_UALastDeviceToken"],
									  [[defaults objectForKey:@"tempFavoritesDict"] objectForKey:@"showId"],
									  [defaults objectForKey:@"_UALastDeviceToken"],
									  newDate
									  ] dataUsingEncoding:NSUTF8StringEncoding]];
/*  test going to Mark's phone
			[request appendPostData:[[NSString stringWithFormat:@"{\"device_tokens\": [\"%@\"] ,\"schedule_for\": [ { \"alias\": \"%@_%@\", \"scheduled_time\": \"%@\" } ],\"aps\": { \"badge\": 0, \"alert\": \"3You have an upcoming show at The Boulder Theater in your Favorites Folder!\", \"sound\": \"default\" } }",
									  @"F6F9C4D8C5E5370BB209C367108B1BBEF773A8F1D7AFBD56DE623E4B605E3BB7",
									  [[defaults objectForKey:@"tempFavoritesDict"] objectForKey:@"showId"],
									  @"F6F9C4D8C5E5370BB209C367108B1BBEF773A8F1D7AFBD56DE623E4B605E3BB7",
									  newDate
									  ] dataUsingEncoding:NSUTF8StringEncoding]];			
*/			
			// Authenticate to the server
			// request.username = [[VenueConnect sharedVenueConnect] pushNotificationApplicationKey];
			// request.password = [[VenueConnect sharedVenueConnect] pushNotificationApplicationSecret];
            request.username = [[VenueConnect sharedVenueConnect] getConfigKey:@"pushNotificationApplicationKey"];
            request.password = [[VenueConnect sharedVenueConnect] getConfigKey:@"pushNotificationApplicationSecret"];
            
			[request setDelegate:self];
			[request startAsynchronous];
			
			[defaults setObject:favorites forKey:@"favorites"];
		}
		[defaults removeObjectForKey:@"tempFavoritesDict"];
	} else if(alertView.tag == 2) {
		if(buttonIndex == 1) {
			//REMOVE FROM FAVORITES
			[favorites removeObject:[defaults objectForKey:@"tempFavoritesDict"]];
			[self reloadTables];
			if([favorites count] == 0) {
				[self flipTables];
			}
			
			//CANCEL THE NOTIFICATION
			
/*			
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://go.urbanairship.com/api/push/scheduled/alias/%@_%@",
											   [[defaults objectForKey:@"tempFavoritesDict"] objectForKey:@"showId"],
											   [defaults objectForKey:@"_UALastDeviceToken"]
											   ]];
*/			
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://go.urbanairship.com/api/push/scheduled/alias/%@_%@",
											   [[defaults objectForKey:@"tempFavoritesDict"] objectForKey:@"showId"],
											   @"F6F9C4D8C5E5370BB209C367108B1BBEF773A8F1D7AFBD56DE623E4B605E3BB7"
											   ]];
			
			
			ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
			request.requestMethod = @"DELETE";
			[request addRequestHeader: @"Content-Type" value: @"application/json"];
			
			// Authenticate to the server
			request.username = [[VenueConnect sharedVenueConnect] getConfigKey:@"pushNotificationApplicationKey"];
            request.password = [[VenueConnect sharedVenueConnect] getConfigKey:@"pushNotificationApplicationSecret"];
			
            [request setDelegate:self];
			[request startAsynchronous];
			
			[defaults setObject:favorites forKey:@"favorites"];
		}
		[defaults removeObjectForKey:@"tempFavoritesDict"];
	}
}


#pragma mark -
#pragma mark ASI Requests

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"finish: %d",[request responseStatusCode]);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSLog(@"ERROR: NSError query result: %@", error);
}


#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == showsTable) {
		return [shows count];
	} else {
		return [favorites count];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ShowCell *cell = (ShowCell *)[tableView dequeueReusableCellWithIdentifier:@"identifier"];
	
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ShowCell" owner:self options:nil];
		cell = [nibs objectAtIndex:0];
    }
	cell.show.frame = CGRectMake(56,26,228,45);
	
	
	// Determine sample height of single line - needed for Show information calculation
	UITextView *testTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 500, 228, 45)];
	[tableView addSubview:testTextView];
	
	testTextView.text = @"A";
	NSNumber *oneRowHeight = [[NSNumber alloc] initWithFloat:testTextView.contentSize.height];
	
	if(tableView == showsTable) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0,0,24,24);
		button.backgroundColor = [UIColor clearColor];
		button.tag = indexPath.row;
		[button addTarget:self action:@selector(accessoryAction:) forControlEvents:UIControlEventTouchUpInside];
		[button setBackgroundImage:[UIImage imageNamed:@"cellAccessory.png"] forState:UIControlStateNormal];
		cell.accessoryView = button;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSDate *date = [dateFormatter dateFromString:[[shows objectAtIndex:indexPath.row] objectForKey:@"showDate"]];
		[dateFormatter setDateFormat:@"EEE"];
		cell.day.text = [[dateFormatter stringFromDate:date] uppercaseString];
		[dateFormatter release];
		
		//NSLog(@"title=%@, date=%@", [[shows objectAtIndex:indexPath.row] objectForKey:@"headliner"], [[shows objectAtIndex:indexPath.row] objectForKey:@"showDate"]);
		
		cell.date.text = [[shows objectAtIndex:indexPath.row] objectForKey:@"showDate"];
		
		testTextView.text = [[shows objectAtIndex:indexPath.row] objectForKey:@"title"];
		[testTextView sizeToFit];
		
		if(testTextView.contentSize.height == [oneRowHeight floatValue])	// Only one row displayed - see if there is an opening act 
		{
			
			if(([[shows objectAtIndex:indexPath.row] objectForKey:@"opener"] != [NSNull null])&&([[[shows objectAtIndex:indexPath.row] objectForKey:@"opener"] length])) { //Fixed to prevent crashing by Nic
				
				[cell.show setText: [NSString stringWithFormat: @"%@\n%@", [[shows objectAtIndex:indexPath.row] objectForKey:@"title"], [[shows objectAtIndex:indexPath.row] objectForKey:@"opener"]]];
			}
			else if(([[shows objectAtIndex:indexPath.row] objectForKey:@"presentedBy"] != [NSNull null])&&[[[shows objectAtIndex:indexPath.row] objectForKey:@"presentedBy"] length]) {		// No opening act - if there is a presented by then display it
				
			
				[cell.show setText: [NSString stringWithFormat: @"%@\n%@", [[shows objectAtIndex:indexPath.row] objectForKey:@"presentedBy"], [[shows objectAtIndex:indexPath.row] objectForKey:@"title"]]];
			}
			else {
				[cell.show setText:[[shows objectAtIndex:indexPath.row] objectForKey:@"title"]];
			}

		}
		else {
			[cell.show setText:[[shows objectAtIndex:indexPath.row] objectForKey:@"title"]];
		}
        
		CGSize newShowSize = [cell.show.text sizeWithFont:cell.show.font constrainedToSize:cell.show.frame.size lineBreakMode:NSLineBreakByWordWrapping];
		cell.show.frame = CGRectMake(56,26,228,newShowSize.height);
		cell.showtime.text = [[[shows objectAtIndex:indexPath.row] objectForKey:@"showTime"] uppercaseString];
		
		if([[[shows objectAtIndex:indexPath.row] objectForKey:@"doorTime"] length]) {
			cell.doors.text = [[[shows objectAtIndex:indexPath.row] objectForKey:@"doorTime"] uppercaseString];
			cell.doorsLabel.hidden = NO;
			cell.doors.hidden = NO;
		}
		else {
			cell.doorsLabel.hidden = YES;
			cell.doors.hidden = YES;
		}
		
		[testTextView removeFromSuperview];
			
	} else {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0,0,34,34);
		button.backgroundColor = [UIColor clearColor];
		button.tag = indexPath.row;
		[button addTarget:self action:@selector(accessoryAction:) forControlEvents:UIControlEventTouchUpInside];
		[button setBackgroundImage:[UIImage imageNamed:@"lightboxClose.png"] forState:UIControlStateNormal];
		cell.accessoryView = button;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSDate *date = [dateFormatter dateFromString:[[favorites objectAtIndex:indexPath.row] objectForKey:@"showDate"]];
		[dateFormatter setDateFormat:@"EEE"];
		cell.day.text = [[dateFormatter stringFromDate:date] uppercaseString];
		[dateFormatter release];
		
		cell.date.text = [[favorites objectAtIndex:indexPath.row] objectForKey:@"showDate"];
		
		testTextView.text = [[favorites objectAtIndex:indexPath.row] objectForKey:@"title"];
		[testTextView sizeToFit];		
		
		
		if(testTextView.contentSize.height == [oneRowHeight floatValue])	// Only one row displayed - see if there is an opening act 
		{
			if([[[favorites objectAtIndex:indexPath.row] objectForKey:@"opener"] length]) {
				[cell.show setText: [NSString stringWithFormat: @"%@\n%@", [[favorites objectAtIndex:indexPath.row] objectForKey:@"title"], [[favorites objectAtIndex:indexPath.row] objectForKey:@"opener"]]];
			}
			else if([[[shows objectAtIndex:indexPath.row] objectForKey:@"presentedBy"] length]) {		// No opening act - if there is a presented by then display it
				[cell.show setText: [NSString stringWithFormat: @"%@\n%@", [[favorites objectAtIndex:indexPath.row] objectForKey:@"presentedBy"], [[favorites objectAtIndex:indexPath.row] objectForKey:@"title"]]];
			}
		}
		else {
			[cell.show setText:[[favorites objectAtIndex:indexPath.row] objectForKey:@"title"]];
		}		
		
		//cell.show.text = [[favorites objectAtIndex:indexPath.row] objectForKey:@"title"];
		
		
		CGSize newShowSize = [cell.show.text sizeWithFont:cell.show.font constrainedToSize:cell.show.frame.size lineBreakMode:NSLineBreakByWordWrapping];
		cell.show.frame = CGRectMake(56,26,228,newShowSize.height);
		cell.showtime.text = [[[favorites objectAtIndex:indexPath.row] objectForKey:@"showTime"] uppercaseString];
		cell.doors.text = [[[favorites objectAtIndex:indexPath.row] objectForKey:@"doorTime"] uppercaseString];
		
		if([[[favorites objectAtIndex:indexPath.row] objectForKey:@"doorTime"]  length]) {
			cell.doors.text = [[[favorites objectAtIndex:indexPath.row] objectForKey:@"doorTime"] uppercaseString];
			cell.doors.hidden = NO;
			cell.doorsLabel.hidden = NO;
		}
		else {
			cell.doors.hidden = YES;
			cell.doorsLabel.hidden = YES;
		}
	}
	
	[testTextView release];
	[oneRowHeight release];	
    return cell;	
}

- (void)accessoryAction:(id)sender {
	// if([showsTable superview]) {
    if(m_isShowsTable == true) {
		if([favorites containsObject:[shows objectAtIndex:[sender tag]]]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This show is already in your favorites."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert setTag:0];
			[alert show];
			[alert release];
		} else {
			//ADD TO FAVORITES
            // int index = [sender tag];
            // NSObject *obj = [shows objectAtIndex:index];
            // ChrisLin Modified: 2014-10-20   ====>   Raises error "Attempt to set a non-property-list object"
			[defaults setObject:[shows objectAtIndex:[sender tag]] forKey:@"tempFavoritesDict"];
            // [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:@"tempFavoritesDict"];
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to add this show to your favorites? If you have push notifications turned on, you will be sent a reminder three days before the show."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
			[alert setTag:1];
			[alert show];
			[alert release];
		}
	} else {
		//REMOVE FROM FAVORITES
		[defaults setObject:[favorites objectAtIndex:[sender tag]] forKey:@"tempFavoritesDict"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to remove this show from your favorites?"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove",nil];
		[alert setTag:2];
		[alert show];
		[alert release];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	currentShow = indexPath.row;
	
	//NSLog(@"Beggining");
	NSDictionary *d;
	// if([showsTable superview]) {
    if(m_isShowsTable == true) {
		d = [shows objectAtIndex:indexPath.row];
	} else {
		d = [favorites objectAtIndex:indexPath.row];
	}

	detailImage.image = nil;
	
	//NSLog(@"image=%@", [d objectForKey:@"showImage"]);
	
	[self performSelectorInBackground:@selector(downloadImage:) withObject:[d objectForKey:@"showImage"]];

	UIColor *textColor = [UIColor whiteColor];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"showDate"]];
	[dateFormatter setDateFormat:@"EEE"];
	detailDate.text = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:date],[d objectForKey:@"showDate"]];
	detailDate.textColor = textColor;
	[dateFormatter release];

	detailPresents.text = [d objectForKey:@"presentedBy"];
	detailPresents.textColor = textColor;
	
	detailHeadliner.text = [d objectForKey:@"headliner"];
	detailHeadliner.textColor = textColor;
	
    if ([[d objectForKey:@"opener"] isKindOfClass:[NSNull class]]){
        detailOpener.text = @"";
        detailOpener.textColor = textColor;
    }
    else{
        detailOpener.text = [d objectForKey:@"opener"];
        detailOpener.textColor = textColor;
    }
	
	if([[d objectForKey:@"doorTime"] length])
	{
		detailDoorsTime.text = [[d objectForKey:@"doorTime"] uppercaseString];
		detailDoorsTime.hidden = NO;
		detailDoorsLabel.hidden = NO;	
		detailDoorsTime.textColor = textColor;		
	}
	else
	{
		detailDoorsTime.hidden = YES;
		detailDoorsLabel.hidden = YES;
	}
		
	//NSLog(@"Half"); // Nic Debug
	detailShowTime.text = [d objectForKey:@"showTime"];
	detailShowTime.textColor = textColor;
	
	detailPrice.text = [d objectForKey:@"ticketPricing"];
	detailPrice.textColor = textColor;
	
	detailAges.text = [NSString stringWithFormat:@"Ages: %@",[d objectForKey:@"ages"]];
	detailAges.textColor = textColor;
	
	detailTicketsButton.tag = indexPath.row;
	
	//NSLog(@"ticketURL=%@", [d objectForKey:@"ticketLink"]);
	
	if([[[shows objectAtIndex:indexPath.row] objectForKey:@"ticketLink"] length]) {
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[d objectForKey:@"ticketLink"]]]];
		detailTicketsButton.hidden = NO;
	}
	else {
		// Hide the Buy Tickets button
		detailTicketsButton.hidden = YES;
	}


	for(UIImageView *i in [detailView subviews]) {
		if([i isKindOfClass:[UIView class]] && i.tag == -1) {
			[i removeFromSuperview];
		}
	}

	int y = 267;
	int c = 0;
	for(NSDictionary *dict in [d objectForKey:@"mp3s"])
	{
		UIView *songView = [[UIView alloc] initWithFrame:CGRectMake(11,y,297,50)];
		songView.tag = -1;
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0,0,297,50);
		button.tag = c;
		button.backgroundColor = [UIColor clearColor];
		button.contentEdgeInsets = UIEdgeInsetsMake(0,65,0,0);
		button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[button setBackgroundImage:[UIImage imageNamed:@"songPlayBG.png"] forState:UIControlStateNormal];
		[button setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(playSong:) forControlEvents:UIControlEventTouchUpInside];
		[songView addSubview:button];
		
		UIView *loader = [[UIView alloc] initWithFrame:CGRectMake(11,9,275,31)];
		loader.tag = 2;
		loader.hidden = YES;
		UIImageView *loaderBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"songLoaderBG.png"]];
		loaderBG.frame = CGRectMake(0,0,275,31);
		[loader addSubview:loaderBG];
		[loaderBG release];
		
		UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spin.frame = CGRectMake(10,6,20,20);
		[spin startAnimating];
		[loader addSubview:spin];
		[spin release];
		
		UILabel *loaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,6,200,20)];
		loaderLabel.backgroundColor = [UIColor clearColor];
		loaderLabel.font = [UIFont systemFontOfSize:14];
		loaderLabel.textColor = [UIColor whiteColor];
		loaderLabel.text = @"Loading...";
		[loader addSubview:loaderLabel];
		[loaderLabel release];
		
		[songView addSubview:loader];
		[loader release];
		
		
		[detailView addSubview:songView];
		[songView release];
		
		y += 55;
		c++;
	}

	y += 10;
	detailWriteUpHeader.frame = CGRectMake(10,y,300,22);

	y += 22;
	
	detailWriteUp.text = [d objectForKey:@"writeup"];
	detailWriteUp.textColor = textColor;
	
	[detailWriteUp sizeToFit];
	detailWriteUp.frame = CGRectMake(10,y,300,detailWriteUp.frame.size.height);
	y += detailWriteUp.frame.size.height + 15;

	detailView.contentSize = CGSizeMake(320,y);
	
	currentView = @"detail";
	[self showBackButton];
	[self showAddToFavoritesButton];
	[self hideFavoritesButton];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
    
    // ChrisLin Modified: 2014-10-20
    // CGRect rtTablesHolder = tablesHolder.frame;
	// tablesHolder.frame = CGRectMake(-G_WIDTH, rtTablesHolder.origin.y, rtTablesHolder.size.width, rtTablesHolder.size.height);
    
    tablesHolder.frame = [self moveFrameHorz:tablesHolder.frame :(-G_WIDTH)];
    
    // CGRect rtDetailsView = detailView.frame;
	// detailView.frame = CGRectMake(0, rtDetailsView.origin.y, rtDetailsView.size.width, rtDetailsView.size.height);
    detailView.frame = [self moveFrameHorz:detailView.frame :0];
    
	[UIView commitAnimations];
	
	//NSLog(@"Full");
}


#pragma mark -
#pragma mark Nav Actions

- (void)showBackButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideBackButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)showAddToFavoritesButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	addToFavoritesButton.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideAddToFavoritesButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	addToFavoritesButton.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)showFavoritesButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	flipButton.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideFavoritesButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	flipButton.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)showWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	webBackButton.alpha = 1.0;
	webForwardButton.alpha = 1.0;
	webLoader.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	webBackButton.alpha = 0.0;
	webForwardButton.alpha = 0.0;
	webLoader.alpha = 0.0;
	[UIView commitAnimations];
}

- (IBAction)addToFavoritesAction {
	NSDictionary *d;
	// if([showsTable superview]) {
    if(m_isShowsTable == true) {
		d = [shows objectAtIndex:currentShow];
	} else {
		d = [favorites objectAtIndex:currentShow];
	}
	
	if([favorites containsObject:d]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This show is already in your favorites."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert setTag:0];
		[alert show];
		[alert release];
	} else {
		//ADD TO FAVORITES
		[defaults setObject:d forKey:@"tempFavoritesDict"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to add this show to your favorites? If you have push notifications turned on, you will be sent a reminder three days before the show."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
		[alert setTag:1];
		[alert show];
		[alert release];
	}
}

- (IBAction)backAction {
	if([currentView isEqualToString:@"detail"]) {
		currentSongView = nil;
		[self hideBackButton];
		[self hideAddToFavoritesButton];
		[self showFavoritesButton];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
        
		// tablesHolder.frame = CGRectMake(0,48,320,391);
		// detailView.frame = CGRectMake(320,48,320,391);
        tablesHolder.frame = [self moveFrameHorz:tablesHolder.frame :0];
        detailView.frame = [self moveFrameHorz:detailView.frame :G_WIDTH];
        
		[UIView commitAnimations];
		currentView = @"home";
	} else if([currentView isEqualToString:@"web"]) {
		[self hideWebButtons];
		[self showAddToFavoritesButton];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
        
        webView.frame = [self moveFrameHorz:webView.frame :G_WIDTH];
        detailView.frame = [self moveFrameHorz:detailView.frame :0];
		// webView.frame = CGRectMake(320,48,320,361);
		// detailView.frame = CGRectMake(0,48,320,391);
		[UIView commitAnimations];
		currentView = @"detail";
	}
}


#pragma mark -
#pragma mark Audio

- (void)playbackStateChanged:(NSNotification *)aNotification {
	UIView *loader = [[currentSongView subviews] objectAtIndex:1];
	UIButton *button = [[currentSongView subviews] objectAtIndex:0];
	
	if ([streamer isWaiting]) {
		loader.hidden = NO;
		button.userInteractionEnabled = NO;
	} else if ([streamer isPlaying]) {
		loader.hidden = YES;
		button.userInteractionEnabled = YES;
		[button setBackgroundImage:[UIImage imageNamed:@"songPauseBG.png"] forState:UIControlStateNormal];
		[button removeTarget:self action:@selector(playSong:) forControlEvents:UIControlEventTouchUpInside];
		[button addTarget:self action:@selector(stopSong:) forControlEvents:UIControlEventTouchUpInside];
	} else if ([streamer isIdle]) {
		loader.hidden = YES;
		button.userInteractionEnabled = YES;
		[button setBackgroundImage:[UIImage imageNamed:@"songPlayBG.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(playSong:) forControlEvents:UIControlEventTouchUpInside];
		[button removeTarget:self action:@selector(stopSong:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)playSong:(id)sender {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		[self stopSong:sender];
		
		currentSongView = [sender superview];
		
		NSDictionary *d;
		// if([showsTable superview]) {
        if(m_isShowsTable == true) {
			d = [[[shows objectAtIndex:currentShow] objectForKey:@"mp3s"] objectAtIndex:[sender tag]];
		} else {
			d = [[[favorites objectAtIndex:currentShow] objectForKey:@"mp3s"] objectAtIndex:[sender tag]];
		}
		
		NSString *firstChar = [[d objectForKey:@"url"] substringToIndex:1];
		NSString *song;
		
		if([firstChar isEqualToString:@"/"]) {
			// song = [NSString stringWithFormat:@"%@%@",[[VenueConnect sharedVenueConnect] venueURL],[[d objectForKey:@"url"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            song = [NSString stringWithFormat:@"%@%@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueURL"],[[d objectForKey:@"url"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		} else {
			song = [[d objectForKey:@"url"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		}
		
		streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:song]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:streamer];
		[streamer start];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to stream this song." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)stopSong:(id)sender {
	if(streamer) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:streamer];
		[streamer stop];
		[streamer release];
		streamer = nil;
		
		if(currentSongView) {
			UIButton *button = [[currentSongView subviews] objectAtIndex:0];
			button.hidden = NO;
			[button setBackgroundImage:[UIImage imageNamed:@"songPlayBG.png"] forState:UIControlStateNormal];
			[button removeTarget:self action:@selector(stopSong:) forControlEvents:UIControlEventTouchUpInside];
			[button addTarget:self action:@selector(playSong:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
}


#pragma mark -
#pragma mark Web View

- (void)webViewDidStartLoad:(UIWebView *)wView {
	webLoader.hidden = NO;
	[webLoader startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
	webLoader.hidden = YES;
}

- (void)webView:(UIWebView *)wView didFailLoadWithError:(NSError *)error {
	webLoader.hidden = YES;
}

- (BOOL)webView:(UIWebView *)wView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return TRUE;
}


#pragma mark -


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)buyTicketsAction {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		currentView = @"web";
		[self hideAddToFavoritesButton];
		[self showWebButtons];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
        
		// webView.frame = CGRectMake(0,48,320,361);
		// detailView.frame = CGRectMake(-320,48,320,392);
        
        webView.frame = [self moveFrameHorz:webView.frame :0];
        detailView.frame = [self moveFrameHorz:detailView.frame :(-G_WIDTH)];
        
		[UIView commitAnimations];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to buy tickets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)downloadImage:(NSString *)image {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Beggining of DownloadImage");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSArray *pieces = [image componentsSeparatedByString:@"/"];
	NSString *clubImage = [NSString stringWithFormat:@"/%@",[pieces lastObject]];
	
	NSLog(@"3");
	if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:clubImage]]) {
		NSURL *myURL = [NSURL URLWithString:image];
		
		NSData *data = [NSData dataWithContentsOfURL:myURL]; //This line is crashing
			
		if(!data) {
			clubImage = nil;
		} else {
			[data writeToFile:[documentsDirectory stringByAppendingString:clubImage] atomically:YES];
		}
	}
	NSLog(@"4");
	[self performSelectorOnMainThread:@selector(changeDetailImage:) withObject:clubImage waitUntilDone:NO];
	
	NSLog(@"End of DownloadImage");
	[pool release];
}

- (void)changeDetailImage:(NSString *)clubImage {
	if(clubImage) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		UIImage *workingImage = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:clubImage]];
		
		CGSize newSize;		// Set up the target size
		newSize.width = detailImage.frame.size.width;
		newSize.height = detailImage.frame.size.height;
		
		UIImage *newImage;
		
		if((workingImage.size.width > newSize.width) && (workingImage.size.height > newSize.height)) {	// Need to scale image
			newImage = [workingImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
		}
		else {
			newImage = workingImage;
		}
		
		if((newImage.size.width > newSize.width) || (newImage.size.height > newSize.height)) {	// Need to crop width and/or height
			
			CGRect newRect = CGRectMake(floor((newImage.size.width - newSize.width) / 2),floor((newImage.size.height - newSize.height) / 2),newSize.width,newSize.height);
			
			newImage = [newImage croppedImage:newRect];
		}
		
		detailImage.image = newImage;
		
	} else {
		detailImage.image = [UIImage imageNamed:@"showDefault.png"];
	}
}

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
	[shows release];
	[favorites release];
}

- (CGRect) moveFrameHorz: (CGRect) rtFrame :(int) newX{
    CGRect rtResult = CGRectMake(newX, rtFrame.origin.y, rtFrame.size.width, rtFrame.size.height);
    return rtResult;
}

- (NSDictionary*) getTempFavoritesDictFromDefaults{
    NSData *data = [defaults objectForKey:@"tempFavoritesDict"];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [[NSDictionary alloc] initWithDictionary:dict];
}

@end
